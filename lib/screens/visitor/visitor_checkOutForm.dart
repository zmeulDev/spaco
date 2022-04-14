import 'package:awesome_select/awesome_select.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spaco/utils/companies.dart';
import 'package:spaco/utils/constant.dart';
import 'package:spaco/utils/kickOut.dart';

class VisitorCheckOutForm extends StatefulWidget {
  @override
  _VisitorCheckOutFormState createState() => _VisitorCheckOutFormState();
}

class _VisitorCheckOutFormState extends State<VisitorCheckOutForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameControl = TextEditingController();
  String _companyControl = "";
  final TextEditingController _checkInControl = TextEditingController();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  String? _name;
  String? _company;

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

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
            ),
            child: Container(
              height: height * 0.07,
              width: width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(21),
                color: const Color(0xffC6C7C4).withOpacity(0.5),
              ),
              child: SmartSelect<String>.single(
                selectedValue: _companyControl.toString(),
                placeholder: 'Selecteza',
                modalType: S2ModalType.bottomSheet,
                modalConfirm: false,
                modalFilter: true,
                modalStyle: const S2ModalStyle(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    ),
                  ),
                ),
                choiceType: S2ChoiceType.chips,
                choiceStyle: const S2ChoiceStyle(
                  outlined: true,
                  showCheckmark: true,
                ),
                choiceActiveStyle: const S2ChoiceStyle(
                  color: tertiaryColor,
                  raised: true,
                ),
                choiceItems: companyOptions,
                choiceGrouped: true,
                title: 'Companie:',
                tileBuilder: (context, state) {
                  return S2Tile.fromState(
                    state,
                    leading: CircleAvatar(
                      backgroundColor: tertiaryColor,
                      child: Text(
                        '${state.selected.toString()[0]}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
                onChange: (selected) =>
                    setState(() => _companyControl = selected.value!),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
            ),
            child: Container(
              height: height * 0.07,
              width: width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(21),
                color: const Color(0xffC6C7C4).withOpacity(0.5),
              ),
              child: Center(
                child: TextFormField(
                  controller: _nameControl,
                  inputFormatters: [UpperCaseTextFormatter()],
                  autocorrect: false,
                  enableSuggestions: false,
                  cursorColor: const Color(0xff5E5E77),
                  onSaved: (value) {
                    _name = value;
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "* Nume",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: primaryColor,
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                      ),
                      child: Icon(
                        Icons.face,
                        color: tertiaryColor,
                        size: 32,
                      ),
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                  textInputAction: TextInputAction.next,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 45,
          ),
          Container(
            height: height * 0.08,
            width: width * 0.8,
            child: ElevatedButton.icon(
              icon: const Icon(
                Icons.save,
              ),
              label: const Text('Check out'),
              onPressed: () {
                _checkOutStore();
                kickOut(); // kick out old visitors
              },
              style: TextButton.styleFrom(
                backgroundColor: primaryColor,
                elevation: 0.0,
                textStyle: style2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(21),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _checkOutStore() async {
    final String nameTXT = _nameControl.text.trim().toUpperCase();
    final String companyTXT = _companyControl;

    var collection = FirebaseFirestore.instance.collection('visitor_details');

    var querySnapshots = await collection
        .where('name', isEqualTo: nameTXT)
        .where('company', isEqualTo: companyTXT)
        .orderBy('checkin', descending: true)
        .limit(1)
        .get();

    if (querySnapshots.docs.isNotEmpty) {
      for (var snapshot in querySnapshots.docs) {
        var documentID = snapshot.id;

        if (nameTXT.isNotEmpty && companyTXT.isNotEmpty) {
          _formKey.currentState!.save();
          _db.collection("visitor_details").doc(documentID).update({
            "checkout": DateTime.now(),
          });

          //Show success alert-dialog
          showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: const Text("Multumim!"),
                  content: const Text(
                      "Va dorim o zi frumoasa in contiunare si va mai asteptam."),
                  actions: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text('Echipa Stables.'),
                        ),
                        FlatButton(
                          child: const Text(
                            "Inchide",
                            style: TextStyle(
                              color: tertiaryColor,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, "/visitoroption");
                          },
                        ),
                      ],
                    ),
                  ],
                );
              });
        } else {
          showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: const Text("Error"),
                  content: const Text("Va rugam verificati datele introduse!"),
                  actions: <Widget>[
                    // ignore: deprecated_member_use
                    FlatButton(
                      child: const Text(
                        "OK",
                        style: TextStyle(
                          color: Color(0xff5E5E77),
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
    } else {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text("Error"),
              content: const Text(
                  "Nu sunteti inregistrat ca si visitator, va rugam verificati datele introduse."),
              actions: <Widget>[
                // ignore: deprecated_member_use
                FlatButton(
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      color: Color(0xff5E5E77),
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
}
