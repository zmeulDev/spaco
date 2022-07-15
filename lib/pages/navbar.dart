import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:spaco/pages/Booking/booking.dart';
import 'package:spaco/pages/Partners/partners.dart';
import 'package:spaco/pages/Rooms/rooms.dart';
import 'package:spaco/pages/home.dart';
import 'package:spaco/pages/profile/profile.dart';
import 'package:spaco/utils/constant.dart';

class NavBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NavigationBar();
  }
}

class NavigationBar extends State<NavBar> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    Home(),
    Bookings(),
    Rooms(),
    Partners(),
    Profile(),
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
          minimum: EdgeInsets.all(10.0),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.all(
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
                tabBorderRadius: 10,
                gap: 5,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                duration: Duration(milliseconds: 300),
                tabs: [
                  GButton(
                    icon: FeatherIcons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: FeatherIcons.calendar,
                    text: 'Bookings',
                  ),
                  GButton(
                    icon: FeatherIcons.airplay,
                    text: 'Rooms',
                  ),
                  GButton(
                    icon: FeatherIcons.hexagon,
                    text: 'Partners',
                  ),
                  GButton(
                    icon: FeatherIcons.user,
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
