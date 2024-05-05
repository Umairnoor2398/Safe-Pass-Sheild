import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

import 'package:safe_pass_sheild/Constants/my_router.dart';

class MyBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  const MyBottomNavBar({
    Key? key,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  State<MyBottomNavBar> createState() => _MyBottomNavBarState();
}

class _MyBottomNavBarState extends State<MyBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return SlidingClippedNavBar(
        backgroundColor: Colors.white,
        iconSize: 30,
        barItems: [
          BarItem(icon: Icons.password, title: 'Passwords'),
          BarItem(icon: Icons.apps, title: 'Apps'),
        ],
        selectedIndex: widget.selectedIndex,
        onButtonPressed: (index) {
          // setState(() {
          //   widget.selectedIndex = index;
          // });
          if (index == 0) {
            context.goNamed(MyScreens.home.toShortString());
          } else {
            context.goNamed(MyScreens.authenticator.toShortString());
          }
        },
        activeColor: Colors.deepPurple);
  }
}
