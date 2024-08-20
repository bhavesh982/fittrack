import 'package:firebase_auth/firebase_auth.dart';
import 'package:fittrackai/Screens/details/details.dart';
import 'package:fittrackai/Screens/home_page.dart';
import 'package:fittrackai/componenets/alert.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CheckUserDataPage extends StatefulWidget {
  const CheckUserDataPage({Key? key}) : super(key: key);

  @override
  State<CheckUserDataPage> createState() => _CheckUserDataPageState();
}

class _CheckUserDataPageState extends State<CheckUserDataPage> {
  bool _isLoading = true; // Track the loading state

  @override
  void initState() {
    super.initState();
    _checkUserData();
  }

  Future<void> _checkUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid.toString();
    final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final snapshot = await docRef.get();

    if (snapshot.exists && snapshot.data()!.containsKey('name')) {
      // If user data exists, navigate to MyHomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    } else {
      // If user data does not exist, navigate to DetailsPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DetailsPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Spinner color
        )
            : Container(), // Empty container for when loading is done
      ),
    );
  }
}
