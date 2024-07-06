import 'package:fittrackai/Screens/home_page.dart';
import 'package:fittrackai/componenets/mybutton.dart';
import 'package:fittrackai/componenets/textField.dart';
import 'package:fittrackai/google/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'SignupPage.dart';
import 'package:fittrackai/componenets/alert.dart';
class LoginPage extends StatefulWidget {

   LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController=TextEditingController();
  final passwordController=TextEditingController();

  // sign user in method
  void signUserIn() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // pop the loading circle
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const MyHomePage()));
    } on FirebaseAuthException catch (e) {
      // pop the loading circle
      Navigator.pop(context);
      // WRONG EMAIL
     wrongEmailMessage(e.code);
    }
  }

  // wrong email message popup
  void wrongEmailMessage(String msg) {
   Commons().AlertMe(msg,context);
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
                const SizedBox(height: 10,),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children:[
                    Text("Forgot password?",
                    style: TextStyle(color: Colors.grey),),
                    ]),
                ),
                const SizedBox(height: 25,),
                MyButton(
                  title:'Sign In',
                  onTap: signUserIn,
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
                  onTap: (){
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
                    Text('Not a member ?'),
                    SizedBox(width: 4,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> SignupPage()));
                      },
                      child: const Text('Register Now',
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
