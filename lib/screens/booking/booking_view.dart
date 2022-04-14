import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:spaco/utils/constant.dart';
import 'package:spaco/utils/waveClipper.dart';
import 'package:spaco/widgets/showBookingByRoom.dart';

class BookingView extends StatefulWidget {
  final VoidCallback? openDrawer;

  const BookingView({Key? key, this.openDrawer}) : super(key: key);
  @override
  State<BookingView> createState() => _BookingViewState();
}

class _BookingViewState extends State<BookingView> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<QuerySnapshot>? subscription;
  Future<DocumentSnapshot<Map<String, dynamic>>>? data;
  DocumentSnapshot<Map<String, dynamic>>? docs;
  bool _progressController = true;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 240)).then(
      (_) => Navigator.popAndPushNamed(context, '/bookingview'),
    );
    super.initState();
    getUserInfo();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _layoutDetails());
  }

  Widget _layoutDetails() {
    Orientation orientation = MediaQuery.of(context).orientation;

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    var userInfo = docs?.data()!["email"] ?? "";

    if (orientation == Orientation.portrait) {
      return SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: <Widget>[
                Opacity(
                  opacity: 0.5,
                  child: ClipPath(
                    clipper: WaveClipper(),
                    child: Container(
                      color: greenColor,
                      height: height * 0.32,
                    ),
                  ),
                ),
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 50),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [greenColor, blueColor])),
                    height: height * 0.3,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        userInfo.toString().isNotEmpty
                            ? Text(
                                userInfo
                                    .toString()
                                    .substring(0, 3)
                                    .toUpperCase(),
                                style: style1.copyWith(
                                    color: secondaryColor, fontSize: 36),
                              )
                            : Text(''),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 130),
                      width: 150.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: ExactAssetImage('assets/images/booking.jpg'),
                          fit: BoxFit.fill,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: height / 50,
            ),
            showBookingByRoom(db: _db, userInfo: userInfo, height: height),
          ],
        ),
      );
    } else {
      return Row(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [greenColor, blueColor])),
            width: width * 0.3,
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                userInfo.toString().isNotEmpty
                    ? Text(
                        userInfo.toString().substring(0, 3).toUpperCase(),
                        style: style1.copyWith(
                            color: secondaryColor, fontSize: 36),
                      )
                    : Text(''),
                Lottie.asset('assets/animation/booking.json'),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'For booking please contact front desk.',
                    style: style3.copyWith(color: secondaryColor),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: width * 0.7,
            height: height,
            child:
                showBookingByRoom(db: _db, userInfo: userInfo, height: height),
          )
        ],
      );
    }
  }
}
