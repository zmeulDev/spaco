import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spaco/utils/constant.dart';
import 'package:spaco/utils/waveClipper.dart';
import 'package:spaco/widgets/appBar.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? openDrawer;

  const HomeScreen({Key? key, this.openDrawer}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<QuerySnapshot>? subscription;
  Future<DocumentSnapshot<Map<String, dynamic>>>? data;
  DocumentSnapshot<Map<String, dynamic>>? docs;

  bool _progressController = true;
  ImageProvider imageProvider = const AssetImage("assets/images/cowork.jpg");

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  getUserInfo() async {
    data = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        docs = value;
        _progressController = false;
      });
      return value;
    });
  }

  authorizeAdmin(BuildContext context) {
    print(docs!.data()!["email"]);
    if (docs!.data()!['role'] == 'Admin') {
      Navigator.pushNamed(
        context,
        "/adminoption",
      );
    } else {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text("Error"),
              content:
                  const Text("You are not allowed to enter in admin section. "),
              actions: <Widget>[
                // ignore: deprecated_member_use
                FlatButton(
                  child: const Text(
                    "Ok",
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            );
          });
    }
    // }
  }

  authorizeBooking(BuildContext context) {
    print(docs!.data()!["email"]);
    // if (docs.docs[0].exists) {
    if (docs!.data()!['role'] == 'Booking') {
      Navigator.pushNamed(
        context,
        "/bookingview",
      );
    } else {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text("Error"),
              content:
                  const Text("You are not allowed to enter in this section. "),
              actions: <Widget>[
                // ignore: deprecated_member_use
                FlatButton(
                  child: const Text(
                    "Ok",
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            );
          });
    }
    // }
  }

  authorizeVisitor(BuildContext context) {
    print(docs!.data()!["email"]);
    // if (docs.docs[0].exists) {
    if (docs!.data()!['role'] == 'Visitor') {
      Navigator.pushNamed(
        context,
        "/visitoroption",
      );
    } else {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text("Error"),
              content:
                  const Text("You are not allowed to enter in this section. "),
              actions: <Widget>[
                // ignore: deprecated_member_use
                FlatButton(
                  child: const Text(
                    "Ok",
                  ),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            );
          });
    }
    // }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var userInfo = docs?.data()!["email"] ?? "";

    return Scaffold(
      appBar: appBar(context),
      body: Container(
        child: Column(
          children: [
            Stack(
              children: <Widget>[
                Opacity(
                  opacity: 0.5,
                  child: ClipPath(
                    clipper: WaveClipper(),
                    child: Container(
                      color: tertiaryColor,
                      height: height * 0.22,
                    ),
                  ),
                ),
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    padding: EdgeInsets.only(bottom: height * 0.1),
                    color: tertiaryColor,
                    height: height * 0.2,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Hello",
                          style: style1.copyWith(
                              fontSize: 28, color: secondaryColor),
                        ),
                        Text(
                          '$userInfo',
                          style: style2.copyWith(color: secondaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height / 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                    color: kashmirColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  // ignore: deprecated_member_use
                  child: GestureDetector(
                    onTap: () {
                      _progressController
                          ? const CircularProgressIndicator()
                          : authorizeAdmin(context);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.admin_panel_settings_outlined,
                          color: secondaryColor,
                          size: 36,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Admin",
                          style: TextStyle(
                            color: secondaryColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                    color: ironColor,
                    borderRadius: BorderRadius.circular(21),
                  ),
                  // ignore: deprecated_member_use
                  child: GestureDetector(
                    onTap: () {
                      _progressController
                          ? const CircularProgressIndicator()
                          : authorizeVisitor(context);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.run_circle_outlined,
                          color: Color(0xff5E5E77),
                          size: 36,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Visitor",
                          style: TextStyle(
                            color: Color(0xff5E5E77),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height / 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                    color: greenColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  // ignore: deprecated_member_use
                  child: GestureDetector(
                    onTap: () {
                      _progressController
                          ? const CircularProgressIndicator()
                          : authorizeBooking(context);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.monitor,
                          color: secondaryColor,
                          size: 36,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Display",
                          style: TextStyle(
                            color: secondaryColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  // ignore: deprecated_member_use
                  child: GestureDetector(
                    onTap: () {
                      _progressController
                          ? const CircularProgressIndicator()
                          : authorizeBooking(context);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.calendar_today_outlined,
                          color: secondaryColor,
                          size: 36,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Soon",
                          style: TextStyle(
                            color: fifthColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
