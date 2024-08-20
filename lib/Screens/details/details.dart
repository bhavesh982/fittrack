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
  TextEditingController height = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController medicalCondition = TextEditingController();
  TextEditingController dietaryRestriction = TextEditingController();
  TextEditingController limitedMobility = TextEditingController();

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

  void SaveUserData() {
    Map<String, dynamic> data = {
      'goal': goal,
      'height': height.text,
      'weight': weight.text,
      'medicalcondition': medicalCondition.text,
      'dietaryrestriction': dietaryRestriction.text,
      'limitedmobility': limitedMobility.text,
      'activity': level
    };
    String uid = FirebaseAuth.instance.currentUser!.uid.toString();
    final ref = FirebaseFirestore.instance.collection('users').doc(uid);
    ref.update(data).whenComplete(() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MyHomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 120,),
                const Text(
                  'Select Your Goal',
                  style: TextStyle(color: Colors.white), // Set text color to white
                ),
                const SizedBox(height: 12,),
                DropdownButton(
                  dropdownColor: Colors.black, // Set dropdown background to black
                  value: goal,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white), // Set icon color to white
                  items: goals.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items, style: const TextStyle(color: Colors.white)), // Set item text color to white
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
                  style: const TextStyle(color: Colors.white), // Set input text color to white
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter Weight in kg',
                    hintStyle: TextStyle(color: Colors.white54), // Set hint text color to grayish-white
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Set underline color to white
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Set focused underline color to white
                    ),
                  ),
                  controller: weight,
                ),
                const SizedBox(height: 50,),
                TextFormField(
                  style: const TextStyle(color: Colors.white), // Set input text color to white
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter height in cm',
                    hintStyle: TextStyle(color: Colors.white54), // Set hint text color to grayish-white
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Set underline color to white
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Set focused underline color to white
                    ),
                  ),
                  controller: height,
                ),
                const SizedBox(height: 50,),
                const Text(
                  'How often do you train?',
                  style: TextStyle(color: Colors.white), // Set text color to white
                ),
                const SizedBox(height: 12,),
                DropdownButton(
                  dropdownColor: Colors.black, // Set dropdown background to black
                  value: level,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white), // Set icon color to white
                  items: activityLevel.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items, style: const TextStyle(color: Colors.white)), // Set item text color to white
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      level = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 30,),
                const Text("write none if not",style: TextStyle(color: Colors.white60,fontSize: 17),),
                const SizedBox(height: 30,),
                TextFormField(
                  style: const TextStyle(color: Colors.white), // Set input text color to white
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Enter any limitedMobility',
                    hintStyle: TextStyle(color: Colors.white54), // Set hint text color to grayish-white
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Set underline color to white
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Set focused underline color to white
                    ),
                  ),
                  controller: limitedMobility,
                ),
                const SizedBox(height: 50,),
                TextFormField(
                  style: const TextStyle(color: Colors.white), // Set input text color to white
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Enter any Medical Condition',
                    hintStyle: TextStyle(color: Colors.white54), // Set hint text color to grayish-white
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Set underline color to white
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Set focused underline color to white
                    ),
                  ),
                  controller: medicalCondition,
                ),
                const SizedBox(height: 50,),
                TextFormField(
                  style: const TextStyle(color: Colors.white), // Set input text color to white
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Enter dietary Restriction',
                    hintStyle: TextStyle(color: Colors.white54), // Set hint text color to grayish-white
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Set underline color to white
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white), // Set focused underline color to white
                    ),
                  ),
                  controller: dietaryRestriction,
                ),
                const SizedBox(height: 50,),
                Center(
                  child: ElevatedButton(
                    onPressed: SaveUserData,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.blue, // Set button text color to white
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text("Next"),
                  ),
                ),
                const SizedBox(height: 50,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
