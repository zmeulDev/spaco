import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:spaco/screens/admin/admin_homePage.dart';
import 'package:spaco/screens/booking/booking_view.dart';
import 'package:spaco/screens/visitor/visitor_homePage.dart';
import 'package:spaco/utils/constant.dart';
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
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AdminHomePage(check: true),
        ),
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
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BookingView(),
        ),
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
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VisitorOption(check: true),
        ),
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
    var userInfo = docs?.data()!["email"] ?? "";

    return Scaffold(
      backgroundColor: appBckColor,
      appBar: appBar(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: EdgeInsets.only(top: getScreenHeight(context) * 0.1)),
          Text(
            "Hello",
            style: style1.copyWith(fontSize: 28, color: primaryColor),
          ),
          Text(
            '$userInfo',
            style: style2.copyWith(color: fourthColor),
            textAlign: TextAlign.left,
          ),
          SizedBox(
            height: getScreenHeight(context) / 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              PhysicalModel(
                elevation: 1,
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 90,
                  width: 150,
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  // ignore: deprecated_member_use
                  child: GestureDetector(
                    onTap: () {
                      _progressController
                          ? CircularProgressIndicator()
                          : authorizeAdmin(context);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.admin_panel_settings_outlined,
                          color: tertiaryColor,
                          size: 32,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Admin",
                          style: TextStyle(
                            color: tertiaryColor,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              PhysicalModel(
                elevation: 1,
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: 90,
                  width: 150,
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  // ignore: deprecated_member_use
                  child: GestureDetector(
                    onTap: () {
                      _progressController
                          ? CircularProgressIndicator()
                          : authorizeVisitor(context);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.run_circle_outlined,
                          color: tertiaryColor,
                          size: 36,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Visitor",
                          style: TextStyle(
                            color: tertiaryColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: getScreenHeight(context) / 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                height: 90,
                width: 150,
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
                        Icons.monitor,
                        color: tertiaryColor,
                        size: 36,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Display",
                        style: TextStyle(
                          color: tertiaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                height: 90,
                width: 150,
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
                        color: tertiaryColor,
                        size: 36,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Soon",
                        style: TextStyle(
                          color: tertiaryColor,
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
    );
  }
}
