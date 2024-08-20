import 'package:firebase_auth/firebase_auth.dart';
import 'package:fittrackai/Screens/tracker/weekslist.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProgramViewPage extends StatefulWidget {
  final String programTitle;
  ProgramViewPage({required this.programTitle});

  @override
  _ProgramViewPageState createState() => _ProgramViewPageState();
}

class _ProgramViewPageState extends State<ProgramViewPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Map<String, dynamic> workoutData;
  List<String> weeks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWeeksData();
  }
  Future<void> saveWorkout() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final uid= FirebaseAuth.instance.currentUser!.uid;
    try {
      await _firestore.collection('users').doc(uid).set({
        'workoutProgram': workoutData,
      }, SetOptions(merge: true)); // Use merge to avoid overwriting existing data
      print('Workout program saved successfully!');
    } catch (e) {
      print('Error saving workout program: $e');
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> WeeksListPage()));
  }
  Future<void> _loadWeeksData() async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('programs').doc(widget.programTitle).get();
      if (userDoc.exists) {
        setState(() {
          workoutData = userDoc.get('workoutProgram') as Map<String, dynamic>;
          weeks = (workoutData['PROGRAM'] as Map<String, dynamic>).keys.toList();
          weeks.sort();
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading weeks data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.programTitle, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
        saveWorkout
        ,
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.black,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : weeks.isEmpty
          ? Center(child: Text('Start workout by selecting a program', style: TextStyle(color: Colors.white)))
          : ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: weeks.length,
        itemBuilder: (context, index) {
          final week = weeks[index];
          final weekData = workoutData['PROGRAM'][week] as Map<String, dynamic>;

          return Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: ExpansionTile(
              title: Text(
                week,
                style: TextStyle(color: Colors.white),
              ),
              tilePadding: EdgeInsets.all(10),
              children: weekData.keys
                  .where((day) => day.startsWith('DAY'))
                  .map<Widget>((day) {
                final dayData = weekData[day] as Map<String, dynamic>;
                final isCompleted = dayData['completed'] ?? false;
                final exercises = dayData.keys
                    .where((key) => !['completed', 'REST'].contains(key))
                    .toList();

                return ExpansionTile(
                  title: Text(
                    day,
                    style: TextStyle(color: isCompleted ? Colors.green : Colors.grey),
                  ),
                  subtitle: Text(
                    dayData['REST'] ? 'Rest Day' : 'Workout Day',
                    style: TextStyle(color: Colors.white),
                  ),
                  children: exercises.map<Widget>((exercise) {
                    final sets = dayData[exercise] as Map<String, dynamic>;

                    return ListTile(
                      title: Text(exercise, style: TextStyle(color: Colors.white)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: sets.keys.map<Widget>((set) {
                          final setData = sets[set] as Map<String, dynamic>;
                          return Text(
                            '${set}: ${setData['reps']} (${setData['weight']})',
                            style: TextStyle(color: Colors.white70),
                          );
                        }).toList(),
                      ),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
