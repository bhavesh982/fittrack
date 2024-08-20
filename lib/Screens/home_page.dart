import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fittrackai/Screens/home/HomeScreen.dart';
import 'package:fittrackai/Screens/home/UserProfile.dart';
import 'package:fittrackai/Screens/tracker/weekslist.dart';
import 'package:fittrackai/chatpage/chatScreen.dart';
import 'package:flutter/material.dart';
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final PageController _controller = PageController();
  final List<Widget> screens = [
    HomeScreen(),
    WeeksListPage(),
    UserProfile()
  ];
  final iconList = <Icon>[
    Icon(Icons.home),
    Icon(Icons.favorite),
    Icon(Icons.person),
  ];
  void onTap(int index) {
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
        physics: const NeverScrollableScrollPhysics(), // Disable swipe
        children: screens,
      ),
    );
  }
}
