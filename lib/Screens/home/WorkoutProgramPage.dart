import 'package:flutter/material.dart';

class WorkoutProgramPage extends StatelessWidget {
  final Map<String, dynamic> program;

  // Constructor with named parameter
  const WorkoutProgramPage({Key? key, required this.program}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(program['name'] ?? 'Workout Program'),
      ),
      body: Center(
        child: Text('Details for ${program['name']}'),
      ),
    );
  }
}
