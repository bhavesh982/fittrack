import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fittrackai/Screens/progress/workoutprogresspage.dart'; // Import your progress page

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with AutomaticKeepAliveClientMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    try {
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(uid).get();
      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>;
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _logOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text('Confirm Logout', style: TextStyle(color: Colors.white)),
        content: Text('Are you sure you want to log out?',
            style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Dismiss the dialog
            child: Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Dismiss the dialog
              await _logOut();
            },
            child: Text('Log Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new, color: Colors.white),
            onPressed: _confirmLogout, // Ask for logout confirmation
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: userData == null
          ? Center(child: CircularProgressIndicator()) // Show loading indicator while data is being fetched
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${userData!['name']}',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              SizedBox(height: 8),
              Text('Goal: ${userData!['goal']}',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              SizedBox(height: 8),
              Text('Height: ${userData!['height']} cm',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              SizedBox(height: 8),
              Text('Weight: ${userData!['weight']} kg',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              SizedBox(height: 8),
              // Navigate to Workout Progress Page button
              SingleChildScrollView(
                child: Container(
                  height: 800,
                  child: WorkoutProgressPage(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
