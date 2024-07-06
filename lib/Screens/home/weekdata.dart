
import 'package:flutter/material.dart';
class WeekData extends StatelessWidget {
  final String weekName;
  final Map<String, dynamic> weekData;

  const WeekData({required this.weekName, required this.weekData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            weekName,
            style: const TextStyle(color: Colors.white, fontSize: 18.0),
          ),
          const SizedBox(height: 8.0),
          // Loop through each day in the week
          for (var dayEntry in weekData.entries)
            buildDayDetails(dayEntry.key, dayEntry.value),
        ],
      ),
    );
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
        dayName,
        style: const TextStyle(color: Colors.white70, fontSize: 16.0),
      );
    }
  }

  Widget buildExerciseDetails(String exerciseName, Map<String, dynamic> sets) {
    // Loop through each set for the exercise
    return Text(
      '- $exerciseName: ${sets.entries.map((setEntry) => '${setEntry.key}: ${setEntry.value["reps"]} reps, ${setEntry.value["weight"]}').join(', ')}',
      style: const TextStyle(color: Colors.white70),
    );
  }
}
