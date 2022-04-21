import 'package:flutter/material.dart';
import 'package:spaco/utils/constant.dart';

Widget buildNavigationBar(onTabTapped, _currentIndex) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(15), topLeft: Radius.circular(15)),
      boxShadow: [
        BoxShadow(color: tertiaryColor, spreadRadius: 0, blurRadius: 1),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15.0),
        topRight: Radius.circular(15.0),
      ),
      child: BottomNavigationBar(
        onTap: onTabTapped,
        type: BottomNavigationBarType.shifting,
        selectedItemColor: primaryColor,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _currentIndex == 0 ? primaryColor : Colors.black54,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.lock,
                color: _currentIndex == 1 ? primaryColor : Colors.black54,
              ),
              label: 'Garage'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.bar_chart,
                color: _currentIndex == 2 ? primaryColor : Colors.black54,
              ),
              label: 'Task')
        ],
      ),
    ),
  );
}
