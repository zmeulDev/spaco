import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spaco/screens/homeScreen.dart';
import 'package:spaco/services/authState.dart';
import 'package:spaco/utils/constant.dart';

appBar(context) {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(
        Icons.home_outlined,
        color: primaryColor,
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
          Icons.exit_to_app_outlined,
          color: primaryColor,
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
      size: 24,
    ),
  );
}
