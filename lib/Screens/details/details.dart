import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fittrackai/Screens/home_page.dart';
import 'package:fittrackai/componenets/mybutton.dart';
import 'package:flutter/material.dart';
class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});
  @override
  State<DetailsPage> createState() => _DetailsPageState();
}
String goal = 'Weight Loss';
String level = 'Not much(0-1 days/week)';

class _DetailsPageState extends State<DetailsPage> {
  TextEditingController height=TextEditingController();
  TextEditingController weight=TextEditingController();
  TextEditingController medicalCondition=TextEditingController();
  TextEditingController dietaryRestriction=TextEditingController();
  TextEditingController limitedMobility=TextEditingController();


  var goals = [
    'Weight Loss',
    'Weight Gain',
    'Lean Gain',
    'Powerlifting',
    'Bodybuilding',
    'WeightLifting'
    'Strength Gain',
    'Improve Cardio',
  ];
  var activityLevel = [
    'Not much(0-1 days/week)',
    'Moderate(1-3 days/week)',
    'Hard(3-5 days/week)',
    'Intense(5-7 days/week)'
  ];
  void SaveUserData(){
    Map<String,dynamic>data={
      'goal':goal,
      'height':height.text,
      'weight':weight.text,
      'medicalcondition':medicalCondition.text,
      'dietaryrestriction':dietaryRestriction.text,
      'limitedmobility':limitedMobility.text,
      'activity':level
    };
    String uid=FirebaseAuth.instance.currentUser!.uid.toString();
    final ref=FirebaseFirestore.instance.collection('users').doc(uid);
    ref.update(data).whenComplete((){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyHomePage()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 120,),
                const Text('Select Your Goal'),
                const SizedBox(height: 12,),
                DropdownButton(
                  value: goal,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: goals.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      goal = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 50,),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter Weight',
                  ),
                  controller: weight,
                ),
                const SizedBox(height: 50,),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter height',
                  ),
                  controller: height,
                ),
                const SizedBox(height: 50,),
                const Text('How often do you train ?'),
                const SizedBox(height: 12,),
                DropdownButton(
                  value: level,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: activityLevel.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      level = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 50,),
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Enter any limitedMobility',
                  ),
                  controller: limitedMobility,
                ),
                const SizedBox(height: 50,),
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Enter any Medical Condition',
                  ),
                  controller: medicalCondition,
                ),
                const SizedBox(height: 50,),
                TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Enter dietary Restriction',
                  ),
                  controller: dietaryRestriction,
                ),
                const SizedBox(height: 50,),
                MyButton(onTap: SaveUserData, title: 'Next'),
                const SizedBox(height: 50,),
              ],
            ),
          ),
        ),
      )
    );
  }
}
