import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spaco/utils/constant.dart';

appBar(context) {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  return AppBar(
    backgroundColor: tertiaryColor,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(
        Icons.home,
        color: secondaryColor,
      ),
      onPressed: () {
        Navigator.pushNamed(context, "/home");
      },
    ),
    actions: [
      IconButton(
        icon: const Icon(
          Icons.exit_to_app,
          color: secondaryColor,
        ),
        onPressed: () {
          _auth.signOut();
          Navigator.pushNamed(context, "/auth");
        },
      ),
    ],
    actionsIconTheme: const IconThemeData(
      size: 32,
    ),
  );
}
