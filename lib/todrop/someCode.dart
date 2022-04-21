import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

String _controller = "";

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseFirestore _db = FirebaseFirestore.instance;

showRoleDialog(BuildContext context) {
  String? _selectedText;
  showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Select Your Role"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return DropdownButtonHideUnderline(
                child: DropdownButton(
                  icon: const Icon(Icons.keyboard_arrow_down),
                  hint: const Text(
                    "Please choose a role",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                  value: _selectedText,
                  items: ['Admin', 'Visitor', 'Member', 'Booking']
                      .map((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? val) {
                    setState(() {
                      _selectedText = val!;
                      _controller = _selectedText!;
                    });
                  },
                ),
              );
            },
            // child: DropdownButton<String>(
            //   value: _selectedText,
            //   items: <String>['Admin', 'User'].map((String value) {
            //     return DropdownMenuItem<String>(
            //       value: value,
            //       child: Text(value),
            //     );
            //   }).toList(),
            //   onChanged: (String? val) {
            //     setState(() {
            //       _selectedText = val!;
            //       _controller = _selectedText;
            //     });
            //   },
            // ),
          ),
          actions: <Widget>[
            // ignore: deprecated_member_use
            FlatButton(
              child: const Text(
                "OK",
                style: TextStyle(
                  color: Color(0xff6C63FF),
                ),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                _signInUsingGoogle(context);
              },
            ),
          ],
        );
      });
}

void _signInUsingGoogle(context) async {
  print(_controller);
  try {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    final User? user = (await _auth.signInWithCredential(credential)).user;
    print("Signed In " + user!.displayName.toString());

    if (user != null) {
      //Successful signup
      _db.collection("users").doc(user.uid).set({
        "displayName": user.displayName,
        "email": user.email,
        "role": _controller,
        "last_seen": DateTime.now(),
        "signup_method": user.providerData[0].providerId
      });
    }
  } catch (e) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text("Error"),
            content: Text("${e}"),
            actions: <Widget>[
              // ignore: deprecated_member_use
              FlatButton(
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          );
        });
  }
}
