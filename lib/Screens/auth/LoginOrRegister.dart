import 'package:fittrackai/Screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'SignupPage.dart';
class Loginorregister extends StatefulWidget {
  const Loginorregister({super.key});

  @override
  State<Loginorregister> createState() => _LoginorregisterState();
}

class _LoginorregisterState extends State<Loginorregister> {
  bool showLoginPage = true;

  void togglePages(){
    setState(() {
      showLoginPage=!showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showLoginPage) {
      return LoginPage();
    } else {
      return SignupPage();
    }
  }
}
