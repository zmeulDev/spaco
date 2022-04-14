import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;

Future<void> deleteOldData() async {
  _db.collection('visitor_details').get().then((snapshot) {
    List<DocumentSnapshot> allDocs = snapshot.docs;
    List<DocumentSnapshot> filteredDocs = allDocs
        .where((document) =>
            DateFormat('dd/MMM/yy').format(document['checkin'].toDate()) !=
            DateFormat('dd/MMM/yy').format(DateTime.now()))
        .where((document) => document['appuser'] == 'reports@cos.com')
        .toList();
    for (DocumentSnapshot ds in filteredDocs) {
      ds.reference.delete();
    }
  });
}
