import 'package:fireproject/Medicine_log/screens/med_home_screen.dart';

import 'package:fireproject/Workout/sportScreens/sport_menu_screen.dart';
import 'package:fireproject/food/my_diary/my_diary_screen.dart';
import 'package:flutter/material.dart';
import 'package:fireproject/Main_pages/Screens/homescreen.dart';
import 'package:fireproject/MorePage/MorePage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class NavigationExample extends StatefulWidget {
  const NavigationExample({Key? key}) : super(key: key);

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  final PageController _pageController = PageController();
  final List<Widget> screens = [];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          MyHomePage(
            pageController: _pageController,
          ),
          const MyDiaryScreen(),
          const medScreen(),
          const SportMenuScreen(),
          const MorePage()
        ],
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color.fromARGB(131, 255, 255, 255),
        color: Color.fromARGB(255, 20, 95, 223),
        buttonBackgroundColor: Color.fromARGB(255, 94, 164, 255),
        animationDuration: const Duration(milliseconds: 150),
        height: 60,
        index: currentIndex,
        items: const <Widget>[
          Icon(Icons.space_dashboard,
              size: 30, color: Color.fromARGB(255, 36, 39, 41)),
          Icon(Icons.food_bank_rounded,
              size: 30, color: Color.fromARGB(255, 36, 39, 41)),
          Icon(
            Icons.medication,
            size: 30,
            color: Color.fromARGB(255, 36, 39, 41),
          ),
          Icon(Icons.directions_run,
              size: 30, color: Color.fromARGB(255, 36, 39, 41)),
          Icon(Icons.more_horiz,
              size: 30, color: Color.fromARGB(255, 36, 39, 41)),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
