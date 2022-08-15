import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:spaco/pages/Booking/booking.dart';
import 'package:spaco/pages/Partners/partners.dart';
import 'package:spaco/pages/Spaces/spaces.dart';
import 'package:spaco/pages/home.dart';
import 'package:spaco/pages/profile/profile.dart';
import 'package:spaco/utils/constant.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NavigationBar();
  }
}

class NavigationBar extends State<NavBar> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const Home(),
    const Bookings(),
    const Spaces(),
    const Partners(),
    const Profile(),
  ];
  int backPressCounter = 1;
  int backPressTotal = 2;

  Future<bool> onWillPop() {
    if (backPressCounter < 2) {
      Get.snackbar('Info', 'Tap again to exit.');
      backPressCounter++;
      Future.delayed(const Duration(seconds: 1, milliseconds: 500), () {
        backPressCounter--;
      });
      return Future.value(false);
    } else {
      SystemNavigator.pop();
      return Future.value(true);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: _pages[_currentIndex],
        extendBody: true,
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.all(10.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(12.0),
              ),
              boxShadow: [
                BoxShadow(
                  spreadRadius: -10,
                  blurRadius: 60,
                  color: Colors.orange.withOpacity(.20),
                  offset: const Offset(0, 10),
                )
              ],
            ),
            child: GNav(
                selectedIndex: _currentIndex,
                onTabChange: onTabTapped,
                haptic: true,
                rippleColor: secondaryColor,
                hoverColor: secondaryColor,
                tabBackgroundColor: tertiaryColor,
                color: secondaryColor,
                activeColor: secondaryColor,
                tabBorderRadius: 12,
                gap: 5,
                iconSize: 24,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                duration: const Duration(milliseconds: 300),
                tabs: const [
                  GButton(
                    icon: CupertinoIcons.dot_square,
                    text: 'Home',
                  ),
                  GButton(
                    icon: CupertinoIcons.calendar,
                    text: 'Bookings',
                  ),
                  GButton(
                    icon: CupertinoIcons.collections,
                    text: 'Spaces',
                  ),
                  GButton(
                    icon: CupertinoIcons.person_2_square_stack,
                    text: 'Partners',
                  ),
                  GButton(
                    icon: CupertinoIcons.person,
                    text: 'Profile',
                  )
                ]),
          ),
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
