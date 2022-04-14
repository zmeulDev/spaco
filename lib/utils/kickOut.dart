import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
User? user;

Future<void> kickOut() async {
  _db.collection('visitor_details').get().then((snapshot) {
    List<DocumentSnapshot> allDocs = snapshot.docs;
    List<DocumentSnapshot> filteredDocs = allDocs
        .where((document) => document['checkout'] == '')
        .where((document) =>
            DateFormat('dd/MMM/yy').format(document['checkin'].toDate()) !=
            DateFormat('dd/MMM/yy').format(DateTime.now()))
        .toList();
    for (DocumentSnapshot ds in filteredDocs) {
      DateTime _nd = ds['checkin'].toDate();
      var _msg = '';
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

      ds.reference.update(
          {"checkout": _newCheckOutDate, "appuser": _auth.currentUser!.email});
    }
  });
}
