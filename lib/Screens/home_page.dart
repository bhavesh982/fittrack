import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fittrackai/Screens/auth/SignupPage.dart';
import 'package:fittrackai/Screens/auth/login.dart';
import 'package:fittrackai/Screens/details/details.dart';
import 'package:fittrackai/Screens/home/ExerciseScreen.dart';
import 'package:fittrackai/Screens/home/HomeScreen.dart';
import 'package:fittrackai/Screens/home/UserProfile.dart';
import 'package:fittrackai/componenets/alert.dart';
import 'package:flutter/material.dart';
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex=0;
  final PageController _controller=PageController();
  final List<Widget>screens=[
    HomeScreen(),
    ExerciseScreen(),
    UserProfile()
  ];
  final iconList =<Icon>[
    Icon(Icons.home),
    Icon(Icons.favorite),
    Icon(Icons.person),
  ];
  void onTap(int index){
    if (_selectedIndex != index) {
      _controller.jumpToPage(index);
      setState(() {
        _selectedIndex = index;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.black,
          animationDuration: const Duration(milliseconds: 300),
          onTap: onTap,
          items: iconList,
      ),
      body: PageView(
        controller: _controller,
        onPageChanged: onTap,
        children: screens,
      ),
    );
  }
}
