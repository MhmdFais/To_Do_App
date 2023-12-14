import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:to_do/components/colors.dart';
import 'package:to_do/pages/addTask_page.dart';
import 'package:to_do/pages/home_page.dart';
import 'package:to_do/pages/Remainder.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentIndex = 0;

  List<Widget> pages = [const Home(), const AddTask(), const Remainder()];

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: GNav(
          backgroundColor: Colours().primary,
          mainAxisAlignment: MainAxisAlignment.center,
          iconSize: 26,
          gap: 6,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          tabActiveBorder: Border.all(
            color: Colours().borderColor,
            width: 1,
          ),
          tabs: [
            GButton(
              icon: Icons.home_outlined,
              text: 'Home',
              iconColor: Colours().borderColor,
              //textColor: Colours().unSelectedText,
            ),
            GButton(
              icon: Icons.add,
              text: 'Add Task',
              iconColor: Colours().borderColor,
              //textColor: Colours().unSelectedText,
            ),
            GButton(
              icon: Icons.calendar_month_outlined,
              text: 'Plan',
              iconColor: Colours().borderColor,
              //textColor: Colours().unSelectedText,
            ),
          ],
          selectedIndex: currentIndex,
          onTabChange: onTap,
        ),
      ),
    );
  }
}
