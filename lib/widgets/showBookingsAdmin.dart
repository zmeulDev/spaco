import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:spaco/utils/constant.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;

DateTime _now = DateTime.now();
DateTime _start = DateTime(_now.year, _now.month, _now.day, 0, 0);
DateTime _end = DateTime(_now.year, _now.month, _now.day, 23, 59, 59);

var allbookings = _db
    .collection("booking_details")
    .orderBy('uploaded_time', descending: true)
    .snapshots();

var bookingToday = _db
    .collection("booking_details")
    .where('book_from', isGreaterThanOrEqualTo: _start)
    .where('book_from', isLessThanOrEqualTo: _end)
    .snapshots();

var bookingUpcoming = _db
    .collection("booking_details")
    .where('book_from', isGreaterThan: _end)
    .snapshots();

showBookingsAdmin(context, query) {
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;

  return SingleChildScrollView(
    child: Container(
      height: height,
      child: StreamBuilder(
        stream: query,
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.docs.isNotEmpty) {
              return ListView(
                children: snapshot.data!.docs.map((snap) {
                  // get date from firebase
                  final checkInSnap = snap["book_from"].toDate();
                  final checkOutSnap = snap["book_to"].toString().isNotEmpty
                      ? snap["book_to"].toDate()
                      : snap["book_from"].toDate();

                  // convert date to friendly view
                  final checkIn =
                      DateFormat('dd/MMM/yy HH:mm').format(checkInSnap);
                  final checkOut =
                      DateFormat('dd/MMM/yy HH:mm').format(checkOutSnap);

                  // find difference in Minutes
                  final minutesIn =
                      checkOutSnap.difference(checkInSnap).inMinutes;

                  final hoursIn = checkOutSnap.difference(checkInSnap).inHours;

                  return GestureDetector(
                    onLongPress: () {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              title: const Text("Delete"),
                              content: const Text("Are you sure!"),
                              actions: <Widget>[
                                // ignore: deprecated_member_use
                                FlatButton(
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(
                                      color: Color(0xff5E5E77),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                ),
                                FlatButton(
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(
                                      color: tertiaryColor,
                                    ),
                                  ),
                                  onPressed: () {
                                    _delete(snap.id);
                                    Navigator.of(ctx).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      elevation: 3,
                      child: Column(
                        children: [
                          ListTile(
                              leading: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                  maxWidth: 42,
                                  maxHeight: 42,
                                ),
                                child: Container(
                                  height: 45,
                                  width: 45,
                                  decoration: const BoxDecoration(
                                    color: tertiaryColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      snap["room"]
                                          .toString()
                                          .split('@')
                                          .first
                                          .toUpperCase(),
                                      style: style2.copyWith(
                                          color: secondaryColor, fontSize: 14),
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(snap["name"]),
                              subtitle: Text(
                                snap["name"],
                                style: style3,
                              ),
                              trailing: snap["book_to"].toString().isNotEmpty
                                  ? Container(
                                      height: 35,
                                      width: 35,
                                      decoration: const BoxDecoration(
                                        color: fifthColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      child: Center(
                                        child: minutesIn <= 59
                                            ? Text('$minutesIn' + '\'')
                                            : Text('$hoursIn' + 'h'),
                                      ),
                                    )
                                  : Container(
                                      height: 35,
                                      width: 35,
                                      decoration: const BoxDecoration(
                                          color: fifthColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Center(
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.login_outlined,
                                            size: 16,
                                          ),
                                          onPressed: () {
                                            _checkOutUpdate(
                                                snap.id, snap["book_from"]);
                                          },
                                        ),
                                      ),
                                    )),
                          ButtonBar(
                            alignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  children: [
                                    const Icon(Icons.lock_clock_outlined),
                                    Text(' ' + checkIn),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  snap["book_to"].toString().isNotEmpty
                                      ? Row(
                                          children: [
                                            const Icon(
                                                Icons.lock_clock_outlined),
                                            Text(' ' + checkOut),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            const Icon(
                                              Icons.lock_clock_outlined,
                                              color: tertiaryColor,
                                            ),
                                            Text(
                                              'Inside',
                                              style: styleVisitorsInside,
                                            ),
                                          ],
                                        )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            } else {
              CircularProgressIndicator();
            }
          }
          return Center(child: Lottie.asset('assets/animation/nothing.json'));
        },
      ),
    ),
  );
}

Future<void> _checkOutUpdate(uid, Timestamp checkin) async {
  var _query = _db.collection("booking_details").doc(uid);
  DateTime _nd = checkin.toDate();
  var _newCheckOutDate = new DateTime(
    _nd.year,
    _nd.month,
    _nd.day,
    21,
    _nd.minute,
    _nd.second,
    _nd.millisecond,
    _nd.microsecond,
  );

  if (DateTime.now().isBefore(_newCheckOutDate)) {
    _query.update({"checkout": DateTime.now(), "appuser": "admin@cos.com"});
  } else {
    _query.update({"checkout": _newCheckOutDate, "appuser": "admin@cos.com"});
  }
}

Future<void> _delete(uid) async {
  _db.collection("booking_details").doc(uid).delete();
}
