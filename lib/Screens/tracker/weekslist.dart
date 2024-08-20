import 'package:fittrackai/Screens/home/ExerciseScreen.dart';
import 'package:fittrackai/Screens/tracker/dayslist.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WeeksListPage extends StatefulWidget {
  @override
  _WeeksListPageState createState() => _WeeksListPageState();
}

class _WeeksListPageState extends State<WeeksListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  late Map<String, dynamic> workoutData;
  List<String> weeks = [];
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _loadWeeksData();
  }

  Future<void> _loadWeeksData() async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        setState(() {
          workoutData = userDoc.get('workoutProgram');
          weeks = (workoutData['PROGRAM'] as Map<String, dynamic>)
              .keys
              .toList();
          weeks.sort();
          isLoading = false; // Data loading complete
        });
      }
    } catch (e) {
      print('Error loading weeks data: $e');
      setState(() {
        isLoading = false; // Data loading complete, even if failed
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weeks List', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ExerciseScreen(),
            ),
          );
        },
        backgroundColor: Colors.blue, // Background color of the button
        child: const Icon(
          Icons.add, // + symbol
          color: Colors.white, // Color of the symbol
        ),
      )
      ,
      backgroundColor: Colors.black, // Set the Scaffold background color to black
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loader while data is loading
          : weeks.isEmpty
          ? Center(child: Text('Start workout by selecting a program', style: TextStyle(color: Colors.white)))
          : ListView(
        padding: EdgeInsets.all(10),
        children: weeks.map((week) {
          final weekData = workoutData['PROGRAM'][week];
          final isCompleted = weekData['completed'] ?? false;
          return Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            child: ListTile(
              tileColor: isCompleted ? Colors.green : Colors.grey, // Set the box color based on completion status
              title: Text(
                week,
                style: TextStyle(color: Colors.white), // Set text color to white
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DaysListPage(weekKey: week),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
