import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spaco/screens/homeScreen.dart';
import 'package:spaco/screens/profile/profilePage.dart';
import 'package:spaco/services/authState.dart';
import 'package:spaco/utils/constant.dart';

appBarAdmin(context) {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  return AppBar(
    backgroundColor: kashmirColor,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(
        Icons.home,
        color: secondaryColor,
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      },
    ),
    actions: [
      IconButton(
        icon: const Icon(
          Icons.person_outline,
          color: secondaryColor,
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditProfile(),
            ),
          );
        },
      ),
      IconButton(
        icon: const Icon(
          Icons.exit_to_app,
          color: secondaryColor,
        ),
        onPressed: () {
          _auth.signOut();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => Auth(),
            ),
          );
        },
      ),
    ],
    actionsIconTheme: const IconThemeData(
      size: 32,
    ),
  );
}
