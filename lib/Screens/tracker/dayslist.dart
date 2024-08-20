import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fittrackai/Screens/tracker/usertracker.dart';

class DaysListPage extends StatefulWidget {
  final String weekKey;

  DaysListPage({required this.weekKey});

  @override
  _DaysListPageState createState() => _DaysListPageState();
}

class _DaysListPageState extends State<DaysListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  late Map<String, dynamic> workoutData;
  List<String> days = [];

  @override
  void initState() {
    super.initState();
    _loadDaysData();
  }

  Future<void> _loadDaysData() async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        setState(() {
          workoutData = userDoc.get('workoutProgram');
          final weekData = workoutData['PROGRAM'][widget.weekKey] as Map<String, dynamic>;
          days = weekData.keys
              .where((day) => day != 'completed') // Filter out 'completed' key
              .toList();
          days.sort();
        });
      }
    } catch (e) {
      print('Error loading days data: $e');
    }
  }

  Color _getContainerColor(String day) {
    final dayData = workoutData['PROGRAM'][widget.weekKey][day] as Map<String, dynamic>;
    final bool isCompleted = dayData['completed'] ?? false;
    return isCompleted ? Colors.green : Colors.grey; // Green if completed, black otherwise
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Days List - ${widget.weekKey}', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Colors.black,
        child: ListView(
          children: days.map((day) {
            return Column(
              children: [
                Container(
                  color: _getContainerColor(day), // Set the container color based on completion status
                  child: ListTile(
                    title: Text(day, style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkoutTrackerPage(
                            weekKey: widget.weekKey,
                            dayKey: day,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 10,)
              ],
            );
          }).toList(),
        ),
      ),
      backgroundColor: Colors.black, // Ensure the background is black
    );
  }
}
