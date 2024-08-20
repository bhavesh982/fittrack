import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkoutTrackerPage extends StatefulWidget {
  final String weekKey;
  final String dayKey;

  WorkoutTrackerPage({required this.weekKey, required this.dayKey});

  @override
  _WorkoutTrackerPageState createState() => _WorkoutTrackerPageState();
}

class _WorkoutTrackerPageState extends State<WorkoutTrackerPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  Map<String, dynamic>? workoutData;
  late String weekKey;
  late String dayKey;

  // Store user inputs separately
  final Map<String, Map<String, Map<String, String>>> _userInputData = {};

  @override
  void initState() {
    super.initState();
    weekKey = widget.weekKey;
    dayKey = widget.dayKey;
    _loadWorkoutData();
  }

  Future<void> _loadWorkoutData() async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        setState(() {
          workoutData = userDoc.get('workoutProgram');
          _initializeUserInputData();
        });
      }
    } catch (e) {
      print('Error loading workout data: $e');
    }
  }

  void _initializeUserInputData() {
    if (workoutData == null) return;

    _userInputData.clear();
    final dayData = workoutData!['PROGRAM'][weekKey][dayKey];
    if (dayData != null) {
      dayData.forEach((exercise, sets) {
        if (exercise != 'completed' && exercise != 'REST') {
          _userInputData[exercise] = {};
          sets.forEach((set, details) {
            _userInputData[exercise]![set] = {
              'reps': '',  // Initialize with empty values
              'weight': ''
            };
          });
        }
      });
    }
  }

  Future<void> _updateWorkoutData() async {
    if (workoutData == null) return;

    try {
      final updatedData = Map<String, dynamic>.from(workoutData!);
      final weekData = updatedData['PROGRAM'][weekKey];
      final dayData = weekData[dayKey];

      bool allFieldsFilled = true;

      // Update the workout data with user input
      _userInputData.forEach((exercise, sets) {
        sets.forEach((set, details) {
          if (details['reps']?.isEmpty ?? true) {
            allFieldsFilled = false;
          } else {
            final setData = dayData[exercise][set];
            setData['reps'] = int.tryParse(details['reps'] ?? '') ?? 0;
            setData['weight'] = details['weight'] ?? '';
          }
        });
      });

      if (!allFieldsFilled) {
        _showFillAllFieldsDialog();
        return;
      }

      // Update completed status
      dayData['completed'] = true;

      await _firestore.collection('users').doc(uid).update({
        'workoutProgram': updatedData,
      });

      print('Workout data updated successfully!');
    } catch (e) {
      print('Error updating workout data: $e');
    }
  }

  void _showFillAllFieldsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Incomplete Data'),
        content: Text('Please fill all the fields before submitting.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (workoutData == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Workout Tracker'),
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: Colors.black,
        body: const Center(
          child: CircularProgressIndicator(), // Show loading indicator while data is being fetched
        ),
      );
    }

    final dayData = workoutData?['PROGRAM']?[weekKey]?[dayKey];
    final isRestDay = dayData?['REST'] ?? false;
    final isCompleted = dayData?['completed'] ?? false;

    if (dayData == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Workout Tracker'),
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
        ),
        body: const Center(
          child: Text('No workout data found for this day.', style: TextStyle(color: Colors.white)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${weekKey} - ${dayKey}', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            if (isRestDay)
              Text('Rest Day', style: TextStyle(fontSize: 18, color: Colors.red))
            else
              Expanded(
                child: ListView(
                  children: _userInputData.entries.map((entry) {
                    final exercise = entry.key;
                    final sets = entry.value;

                    // Sort sets in reverse order
                    final sortedSets = sets.entries.toList()
                      ..sort((a, b) => b.key.compareTo(a.key));

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(exercise, style: TextStyle(color: Colors.white, fontSize: 20)),
                        ...sortedSets.reversed.map((setEntry) {
                          final set = setEntry.key;
                          final details = setEntry.value;
                          final originalDetails = dayData[exercise]?[set]; // Display original data

                          if (originalDetails == null) return SizedBox.shrink();

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Display previous reps and weight data as labels above the text fields
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        originalDetails['reps']?.toString() ?? 'N/A',
                                        style: TextStyle(color: Colors.grey, fontSize: 16),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 100),
                                      child: Text(
                                        originalDetails['weight']?.toString() ?? 'N/A',
                                        style: TextStyle(color: Colors.grey, fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          labelText: '$set',
                                          hintText: 'Reps', // Hint text for reps
                                          hintStyle: TextStyle(color: Colors.grey),
                                          filled: true,
                                          fillColor: Colors.grey[800],
                                          labelStyle: TextStyle(color: Colors.white),
                                        ),
                                        style: TextStyle(color: Colors.white),
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          setState(() {
                                            _userInputData[exercise]![set] = {
                                              'reps': value,
                                              'weight': details['weight'] ?? ""
                                            };
                                          });
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Weight',
                                          hintText: 'Weight', // Hint text for weight
                                          hintStyle: TextStyle(color: Colors.grey),
                                          filled: true,
                                          fillColor: Colors.grey[800],
                                          labelStyle: TextStyle(color: Colors.white),
                                        ),
                                        style: TextStyle(color: Colors.white),
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          setState(() {
                                            _userInputData[exercise]![set] = {
                                              'reps': details['reps'] ?? "",
                                              'weight': value
                                            };
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        Divider(color: Colors.white),
                      ],
                    );
                  }).toList(),
                ),
              ),
            SizedBox(height: 16),
            Center(
              child: Container(
                width: 200,
                child: ElevatedButton(
                  onPressed: isCompleted ? null : _updateWorkoutData,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: isCompleted ? Colors.green : Colors.blue, // Change color based on completion status
                  ),
                  child: Text(
                    isCompleted ? 'Completed' : 'Submit',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
