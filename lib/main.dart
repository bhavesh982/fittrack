import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:fittrackai/Screens/auth/auth_page.dart';
import 'package:fittrackai/Screens/details/following.dart';
import 'package:fittrackai/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';


Future<void> main() async {
  Gemini.init(apiKey: KeyStore().getKey());
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final apiKey = Platform.environment['API_KEY'];
  if (apiKey == null) {
    print('No \$API_KEY environment variable');
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Montserrat'),
      home: AuthPage(),
    );
  }
}
