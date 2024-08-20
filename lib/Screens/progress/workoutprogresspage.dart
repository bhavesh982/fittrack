import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fittrackai/Screens/progress/progress_chart.dart';
import 'package:flutter/material.dart';

class WorkoutProgressPage extends StatefulWidget {
  @override
  _WorkoutProgressPageState createState() => _WorkoutProgressPageState();
}

class _WorkoutProgressPageState extends State<WorkoutProgressPage> {
  Map<String, dynamic>? workoutData;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    fetchWorkoutData();
  }

  Future<void> fetchWorkoutData() async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      setState(() {
        // Check if workoutProgram exists and is not null
        workoutData = userDoc['workoutProgram'] as Map<String, dynamic>? ?? {};
      });
    } catch (e) {
      print('Error fetching workout data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (workoutData==null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'No data to show',
            style: TextStyle(fontSize: 16, color: Colors.white), // White text color
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Weekly Volume', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
        ),
        body: WorkoutProgressChart(workoutData: workoutData!),
      );
    }
  }
}
