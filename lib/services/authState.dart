import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spaco/screens/auth/login.dart';
import 'package:spaco/screens/homeScreen.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _auth.authStateChanges(),
        builder: (ctx, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) {
            User user = snapshot.data!;
            if (user != null) {
              return HomeScreen();
              //return DrawerMain();

            } else {
              return LoginScreen();
            }
          }
          return LoginScreen();
        },
      ),
    );
  }
}
