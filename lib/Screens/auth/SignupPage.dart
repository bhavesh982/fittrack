import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fittrackai/Screens/auth/login.dart';
import 'package:fittrackai/Screens/details/details.dart';
import 'package:fittrackai/google/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordController2 = TextEditingController();

  // Sign user up method
  void signUserup() async {
    // Show loading circle
    if (passwordController.text != passwordController2.text) {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            backgroundColor: Colors.black,
            title: Center(
              child: Text(
                'Passwords don\'t match',
                style: TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),
          );
        },
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // Try sign up
    Map<String, dynamic> data = {
      'name': nameController.text,
      'email': emailController.text,
    };
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      ).whenComplete(() async {
        String uid = FirebaseAuth.instance.currentUser!.uid.toString();
        final ref = FirebaseFirestore.instance.collection('users').doc(uid);
        await ref.set(data);
      });
      // Pop the loading circle
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const DetailsPage()));
    } on FirebaseAuthException catch (e) {
      // Pop the loading circle
      Navigator.pop(context);
      // Show wrong email message
      wrongEmailMessage(e.code);
    }
  }

  // Wrong email message popup
  void wrongEmailMessage(String msg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Center(
            child: Text(
              'Error : $msg',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background to black
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const Icon(
                  Icons.lock,
                  size: 100,
                  color: Colors.white, // Set icon color to white
                ),
                const SizedBox(height: 30),
                const Text(
                  "Ready to Change your life",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: nameController,
                  style: TextStyle(color: Colors.white), // Set text color to white
                  decoration: InputDecoration(
                    hintText: 'Name',
                    hintStyle: TextStyle(color: Colors.white60), // Set hint text color to slightly gray
                    filled: true,
                    fillColor: Colors.black, // Set background to black
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: emailController,
                  style: TextStyle(color: Colors.white), // Set text color to white
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Colors.white60), // Set hint text color to slightly gray
                    filled: true,
                    fillColor: Colors.black, // Set background to black
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: TextStyle(color: Colors.white), // Set text color to white
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Colors.white60), // Set hint text color to slightly gray
                    filled: true,
                    fillColor: Colors.black, // Set background to black
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: passwordController2,
                  obscureText: true,
                  style: TextStyle(color: Colors.white), // Set text color to white
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    hintStyle: TextStyle(color: Colors.white60), // Set hint text color to slightly gray
                    filled: true,
                    fillColor: Colors.black, // Set background to black
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: signUserup,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blue, // Set button text color to white
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text("Sign Up"),
                ),
                const SizedBox(height: 40),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.white60, // Set divider color to slightly gray
                        ),
                      ),
                      Text(
                        "Or Continue with",
                        style: TextStyle(color: Colors.white),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.white60, // Set divider color to slightly gray
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    AuthService().signInWithGoogle();
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white),
                      color: Colors.black, // Set container background to black
                    ),
                    child: Image.asset(
                      'lib/assets/images/google.png',
                      height: 40,
                      color: Colors.white, // Set image color to white
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account?',
                      style: TextStyle(color: Colors.white), // Set text color to white
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: const Text(
                        'Login Now',
                        style: TextStyle(color: Colors.blue),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
