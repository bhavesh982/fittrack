import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WorkoutProgramPage extends StatefulWidget {
  const WorkoutProgramPage({super.key});

  @override
  State<WorkoutProgramPage> createState() => _WorkoutProgramPageState();
}

class _WorkoutProgramPageState extends State<WorkoutProgramPage> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  Map<String, dynamic>? programData;
  int selectedWeekIndex = 0;

  @override
  void initState() {
    super.initState();
    _getProgramData();
  }

  Future<void> _getProgramData() async {
    final ref = FirebaseFirestore.instance.collection('users').doc(uid);
    final docSnapshot = await ref.get();

    if (docSnapshot.exists) {
      setState(() {
        programData = docSnapshot.data()!['POWERLIFTING PROGRAM'];
      });
    } else {
      print('Workout program not found');
    }
  }
  void sortitfirst(){}

  void _changeWeek(int direction) {
    if (programData != null) {
      final sortedWeeks = programData!.keys.toList()..sort();
      final newIndex = selectedWeekIndex + direction;

      if (newIndex >= 0 && newIndex < sortedWeeks.length) {
        setState(() {
          selectedWeekIndex = newIndex;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (programData != null) {
      final sortedWeeks = programData!.keys.toList()..sort();
      final selectedWeek = sortedWeeks[selectedWeekIndex];
      final weekData = programData![selectedWeek];
      List<MapEntry<String, dynamic>> sortedDayEntries = weekData.entries.toList();
      sortedDayEntries.sort((a, b) => a.key.compareTo(b.key));
      return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_left),
                onPressed: () => _changeWeek(-1),
              ),
              Text(selectedWeek),
              IconButton(
                icon: const Icon(Icons.arrow_right),
                onPressed: () => _changeWeek(1),
              ),
            ],
          ),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        backgroundColor: Colors.black,
        body: ListView.builder(
          itemCount: 1, // Only show 1 item (selected week data)
          itemBuilder: (context, index) {
            // Display week data here
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var dayEntry in sortedDayEntries)
                          buildDayDetails(dayEntry.key, dayEntry.value),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
  Widget buildDayDetails(String dayName, Map<String, dynamic> dayData) {
    // Check if day has exercises (not a rest day)

    if (dayData.keys.first != "REST") {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dayName,
            style: const TextStyle(color: Colors.white70, fontSize: 16.0),
          ),
          const SizedBox(height: 4.0),
          // Loop through each exercise for the day
          for (var exerciseEntry in dayData.entries)
            buildExerciseDetails(exerciseEntry.key, exerciseEntry.value),
        ],
      );
    } else {
      return Text(
        dayName+" REST DAY",
        style: const TextStyle(color: Colors.white70, fontSize: 16.0),
      );
    }
  }

  Widget buildExerciseDetails(String exerciseName, Map<String, dynamic> sets) {
    // Loop through each set for the exercise

    return Text(
      '- $exerciseName: ${sets.entries.map((setEntry) => '\n${setEntry.key}: ${setEntry.value["reps"]}\n reps, ${setEntry.value["weight"]}\n').join(', ')}',
      style: const TextStyle(color: Colors.white70),
    );
  }
}
