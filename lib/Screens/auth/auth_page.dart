import 'package:fittrackai/Screens/auth/login.dart';
import 'package:fittrackai/Screens/details/DetailOrHome.dart';
import 'package:fittrackai/Screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return const CheckUserDataPage();
          }
          else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
