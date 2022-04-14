import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:spaco/utils/constant.dart';

class showBookingByRoom extends StatelessWidget {
  const showBookingByRoom({
    Key? key,
    required FirebaseFirestore db,
    required this.userInfo,
    required this.height,
  })  : _db = db,
        super(key: key);

  final FirebaseFirestore _db;
  final userInfo;
  final double height;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _db
            .collection("booking_details")
            .where('room', isEqualTo: userInfo)
            .where('book_to', isGreaterThanOrEqualTo: Timestamp.now())
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return Container(
              height: height,
              child: ListView(
                children: snapshot.data!.docs.map((snap) {
                  final bookFromSnap = snap["book_from"].toDate();
                  final bookFrom =
                      DateFormat('dd/MMM/yy HH:mm').format(bookFromSnap);

                  final bookToSnap = snap["book_to"].toDate();
                  final bookTo =
                      DateFormat('dd/MMM/yy HH:mm').format(bookToSnap);

                  var statusRoom = '';

                  if (DateTime.now().isBefore(bookToSnap) &&
                      DateTime.now().isAfter(bookFromSnap)) {
                    statusRoom = 'In progress';
                  } else {
                    statusRoom = 'Upcoming';
                  }

                  return Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 2.0,
                        margin: new EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: statusRoom == 'Upcoming'
                                ? greenColor
                                : tertiaryColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 10.0),
                            leading: Container(
                              decoration: BoxDecoration(
                                  color: secondaryColor,
                                  borderRadius: BorderRadius.circular(15)),
                              padding: EdgeInsets.only(
                                  left: 13, right: 13, bottom: 3, top: 2),
                              child: statusRoom == 'Upcoming'
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        statusRoom == 'Upcoming'
                                            ? Text(
                                                bookFrom.substring(0, 2),
                                                style: style1.copyWith(
                                                    color: greenColor),
                                              )
                                            : Icon(
                                                Icons.timelapse_rounded,
                                                color: tertiaryColor,
                                              ),
                                        Text(
                                          bookFrom.substring(3, 6),
                                          style: style3.copyWith(
                                              color: greenColor),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(
                                          Icons.update,
                                          color: tertiaryColor,
                                          size: 32,
                                        ),
                                      ],
                                    ),
                            ),
                            title: Row(
                              children: [
                                Icon(
                                  Icons.arrow_forward_outlined,
                                  size: 18,
                                  color: secondaryColor,
                                ),
                                Text(
                                  bookFrom.substring(10, 15),
                                  style: style2.copyWith(color: secondaryColor),
                                ),
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                Icon(
                                  Icons.double_arrow_outlined,
                                  color: secondaryColor,
                                ),
                                Text(
                                  bookTo.substring(10, 15),
                                  style: style1.copyWith(color: secondaryColor),
                                ),
                              ],
                            ),
                            trailing: Text(
                              snap['name'],
                              style: style2.copyWith(color: fifthColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    padding: EdgeInsets.only(top: height * 0.1),
                    child: Text(
                      'For booking please contact front desk.',
                      style: style2,
                    )),
                Container(
                    height: height * 0.7,
                    child: Lottie.asset('assets/animation/comunication.json')),
              ],
            );
          }
        });
  }
}
