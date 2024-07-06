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
  bool _hasData = false;
  @override
  void initState() {
    super.initState();
    _checkUserData();
  }

  Future<void> _checkUserData() async {
    final uid= await FirebaseAuth.instance.currentUser!.uid.toString();
    final docRef = await FirebaseFirestore.instance.collection('users').doc(uid);
    final snapshot = await docRef.get();
    if(snapshot.exists && snapshot.data()!.containsKey('name')){
     Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyHomePage()));
    }
    else{
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const DetailsPage()));
    }
  }
  @override
  Widget build(BuildContext context) {
   return _hasData?MyHomePage():DetailsPage();
  }
}
