import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
        Navigator.pushNamed(context, "/home");
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
          Navigator.pushNamed(context, "/auth");
        },
      ),
    ],
    actionsIconTheme: const IconThemeData(
      size: 24,
    ),
  );
}
