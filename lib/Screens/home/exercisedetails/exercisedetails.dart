import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fittrackai/Screens/tracker/weekslist.dart';
import 'package:fittrackai/assets/workouts/workouts.dart';
import 'package:flutter/material.dart';

class ExerciseDetailsPage extends StatefulWidget {
  final String programTitle;
  final int index;
  ExerciseDetailsPage({required this.programTitle,required this.index});

  @override
  State<ExerciseDetailsPage> createState() => _ExerciseDetailsPageState();
}

class _ExerciseDetailsPageState extends State<ExerciseDetailsPage> {
  //     'Bodybuilding',
  //     'Calisthenics',
  //     'Powerlifting',
  //     'Olympic Weightlifting',
  List program=[workouts_In_Json().bodybuilding,workouts_In_Json().calisthenics,workouts_In_Json().powerlifting,workouts_In_Json().olympicLifting];
  Future<void> saveWorkout() async {
    final workoutData=program[widget.index];
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    try {
      await _firestore.collection('programs').doc(widget.programTitle).set({
        'workoutProgram': workoutData,
      }, SetOptions(merge: true)); // Use merge to avoid overwriting existing data
      print('Workout program saved successfully!');
    } catch (e) {
      print('Error saving workout program: $e');
    }
    Navigator.push(context, MaterialPageRoute(builder: (context)=> WeeksListPage()));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body:  Center(
        child: ElevatedButton(
          onPressed: saveWorkout,
          child: Text("ADD"),
        ),
      )
    );
  }
}
