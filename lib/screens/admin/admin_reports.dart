import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spaco/utils/deleteOldData.dart';
import 'package:spaco/utils/kickOut.dart';
import 'package:spaco/widgets/appBarAdmin.dart';

class AdminReports extends StatefulWidget {
  @override
  _AdminReportsState createState() => _AdminReportsState();
}

class _AdminReportsState extends State<AdminReports> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: height,
        child: StreamBuilder(
            stream: _db
                .collection("visitor_details")
                .where('checkout', isEqualTo: '')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                final _reports = snapshot.data!.size;
                return Scaffold(
                  appBar: appBarAdmin(context),
                  body: Column(
                    children: [
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              deleteOldData();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              height: 160,
                              width: 160,
                              decoration: BoxDecoration(
                                color: const Color(0xffE0E3E4),
                                borderRadius: BorderRadius.circular(21),
                              ),
                              // ignore: deprecated_member_use
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.delete_forever,
                                    color: Color(0xff5E5E77),
                                    size: 36,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Delete data",
                                    style: TextStyle(
                                      color: Color(0xff5E5E77),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              kickOut();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              height: 160,
                              width: 160,
                              decoration: BoxDecoration(
                                color: const Color(0xffC6C7C4).withOpacity(0.4),
                                borderRadius: BorderRadius.circular(21),
                              ),
                              // ignore: deprecated_member_use
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.outbond,
                                    color: Color(0xff5E5E77),
                                    size: 36,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Kick out",
                                    style: TextStyle(
                                      color: Color(0xff5E5E77),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
