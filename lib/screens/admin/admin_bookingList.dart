import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:spaco/utils/constant.dart';
import 'package:spaco/widgets/showBookingsAdmin.dart';

class BookingList extends StatefulWidget {
  @override
  _BookingListState createState() => _BookingListState();
}

class _BookingListState extends State<BookingList> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  @override
  void initState() {
    getUid();
    //getList();
    super.initState();
  }

  /*
  getList() async {
    List item = [];
    await _db
        .collection("users")
        .doc(user!.uid)
        .collection("visitor_details")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        item.add(element.data());
      });
    });
  }
  */

  void getUid() {
    User? u = _auth.currentUser;
    setState(() {
      user = u;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: height,
        child: StreamBuilder(
            stream: _db.collection("booking_details").snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return DefaultTabController(
                  length: 3,
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: greenColor,
                      bottom: TabBar(
                        indicatorColor: secondaryColor,
                        tabs: [
                          Tab(icon: Text('Today')),
                          Tab(icon: Text('Upcoming')),
                          Tab(icon: Text('All')),
                        ],
                      ),
                      title: const Text('Bookings'),
                    ),
                    body: TabBarView(
                      children: [
                        showBookingsAdmin(context, bookingToday),
                        showBookingsAdmin(context, bookingUpcoming),
                        showBookingsAdmin(context, allbookings),
                      ],
                    ),
                  ),
                );
              } else {
                return Center(
                    child: Lottie.asset('assets/animation/nothing.json'));
              }
            }),
      ),
    );
  }
}
