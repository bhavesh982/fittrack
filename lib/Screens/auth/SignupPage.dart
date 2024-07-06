import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fittrackai/Screens/auth/login.dart';
import 'package:fittrackai/Screens/details/DetailOrHome.dart';
import 'package:fittrackai/Screens/details/details.dart';
import 'package:fittrackai/componenets/mybutton.dart';
import 'package:fittrackai/componenets/textField.dart';
import 'package:fittrackai/google/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class SignupPage extends StatefulWidget {

  SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameController=TextEditingController();
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  final passwordController2=TextEditingController();
  // sign user in method
  void signUserup() async {
    // show loading circle
    if(passwordController.text!=passwordController2.text){
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            backgroundColor: Colors.black,
            title: Center(
              child: Text(
                'Passwords don\'t match',
                style: TextStyle(color: Colors.red,fontSize: 13),
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
    // try sign in
    Map<String,dynamic>data={
      'name':nameController.text,
      'email':emailController.text,
    };
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email:emailController.text,
          password: passwordController.text,
      ).whenComplete(() async {
        String uid=FirebaseAuth.instance.currentUser!.uid.toString();
        final ref=FirebaseFirestore.instance.collection('users').doc(uid);
        await ref.set(data);
      });
      // pop the loading circle
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context)=> const DetailsPage()));
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      // WRONG EMAIL
      wrongEmailMessage(e.code);
    }
  }

  // wrong email message popup
  void wrongEmailMessage(String msg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black12,
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
      backgroundColor: Color.fromARGB(220, 250, 250, 250),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                const SizedBox(height: 40,),
                const Icon(Icons.lock,
                  size: 100,),
                const SizedBox(height: 30,),
                const Text("Ready to Change your life",
                  style: TextStyle(color: Colors.grey,
                      fontSize: 16
                  ),),
                const SizedBox(height: 15,),
                MyTextField(
                  controller: nameController,
                  hintText: 'Name',
                  obscureText: false,
                ),
                const SizedBox(height: 25,),
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 25,),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 25,),
                MyTextField(
                  controller: passwordController2,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
                const SizedBox(height: 25,),
                MyButton(
                  title: 'Sign Up',
                  onTap: signUserup,
                ),
                const SizedBox(height: 40,),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey,
                        ),
                      ),
                      Text("Or Continue with",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20,),
                GestureDetector(
                  onTap:(){
                    AuthService().signInWithGoogle();
                  },
                  child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white),
                          color: Colors.white60
                      ),
                      child: Image.asset('lib/assets/images/google.png',height: 40,)),
                ),
                const SizedBox(height: 50,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account ?'),
                    SizedBox(width: 4,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage()));
                      },
                      child: const Text('Login Now',
                        style: TextStyle(
                            color: Colors.blue
                        ),),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
