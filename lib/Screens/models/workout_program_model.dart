import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutProgram {
  final Map<String, Week> weeks;

  WorkoutProgram({required this.weeks});

  factory WorkoutProgram.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final weekData = data['PROGRAM'] as Map<String, dynamic>;

    final weeks = weekData.map((key, value) => MapEntry(key, Week.fromMap(value)));

    return WorkoutProgram(weeks: weeks);
  }

  Map<String, dynamic> toMap() {
    return {
      'PROGRAM': weeks.map((key, value) => MapEntry(key, value.toMap())),
    };
  }
}

class Week {
  final Map<String, Day> days;

  Week({required this.days});

  factory Week.fromMap(Map<String, dynamic> map) {
    final days = map.map((key, value) => MapEntry(key, Day.fromMap(value)));
    return Week(days: days);
  }

  Map<String, dynamic> toMap() {
    return days.map((key, value) => MapEntry(key, value.toMap()));
  }
}

class Day {
  final Map<String, dynamic> exercises;

  Day({required this.exercises});

  factory Day.fromMap(Map<String, dynamic> map) {
    return Day(exercises: map);
  }

  Map<String, dynamic> toMap() {
    return exercises;
  }
}
