import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fittrackai/Screens/home/exercisedetails/programviewpage.dart';
import 'package:fittrackai/Screens/tracker/weekslist.dart';
import 'package:fittrackai/assets/workouts/workouts.dart';
import 'package:flutter/material.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}


class _ExerciseScreenState extends State<ExerciseScreen> with AutomaticKeepAliveClientMixin{
  // Sample data for exercises (replace with your actual data)
  List program=[workouts_In_Json().powerlifting,workouts_In_Json().bodybuilding];
  Future<void> saveWorkout() async {
    final workoutData=program[0];
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
    Navigator.push(context, MaterialPageRoute(builder: (context)=> WeeksListPage()));
  }
  final List<String> programTitles = [
    'Bodybuilding',
    'Calisthenics',
    'Powerlifting',
    'Olympic Weightlifting',
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required to ensure AutomaticKeepAliveClientMixin works
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Programs',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Colors.black,
        child: GridView.builder(
          padding: EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemCount: programTitles.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProgramViewPage(programTitle:programTitles[index])
                  ),
                );
              },
              child: Card(
                color: Colors.grey[850],
                elevation: 4,
                child: Center(
                  child: Text(
                    programTitles[index],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}