import 'package:awesome_select/awesome_select.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaco/utils/companies.dart';
import 'package:spaco/utils/constant.dart';

class VisitorCheckInForm extends StatefulWidget {
  @override
  _VisitorCheckInFormState createState() => _VisitorCheckInFormState();
}

class _VisitorCheckInFormState extends State<VisitorCheckInForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameControl = TextEditingController();
  String _companyControl = "";
  final TextEditingController _numberControl = TextEditingController();
  final TextEditingController _checkInControl = TextEditingController();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  String? _name;
  String? _company;
  String? _number;

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
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MMM/yy HH:mm').format(now);

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
                choiceGrouped: true,
                choiceStyle: const S2ChoiceStyle(
                  outlined: true,
                  showCheckmark: true,
                ),
                choiceActiveStyle: const S2ChoiceStyle(
                  color: tertiaryColor,
                  raised: true,
                ),
                choiceItems: companyOptions,
                title: 'Compania:',
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
          /* remove telephone number form, all logic is still here
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
                  cursorColor: const Color(0xff5E5E77),
                  controller: _numberControl,
                  onSaved: (value) {
                    _number = value;
                    FocusScope.of(context).unfocus();
                    _numberControl.clear();
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Telefon (optional)",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: primaryColor,
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                      ),
                      child: Icon(
                        Icons.call,
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
                  keyboardType: TextInputType.phone,
                ),
              ),
            ),
          ),*/
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
                  controller: _checkInControl,
                  readOnly: true,
                  cursorColor: const Color(0xff5E5E77),
                  onSaved: (value) {},
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: formattedDate,
                    hintStyle: const TextStyle(
                      fontSize: 16,
                      color: primaryColor,
                    ),
                    prefixIcon: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                      ),
                      child: Icon(
                        Icons.calendar_today,
                        color: tertiaryColor,
                        size: 32,
                      ),
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            height: height * 0.08,
            width: width * 0.8,
            child: ElevatedButton.icon(
              icon: const Icon(
                Icons.save,
              ),
              label: const Text('Check in'),
              onPressed: () {
                _storeCheckIn();
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

  void _storeCheckIn() {
    final String nameTXT = _nameControl.text.trim().toUpperCase();
    final String companyTXT = _companyControl;
    final String numberTXT = _numberControl.text.trim();

    if (nameTXT.isNotEmpty && companyTXT.isNotEmpty) {
      _formKey.currentState!.save();
      _db.collection("visitor_details").add({
        "name": nameTXT,
        "company": companyTXT,
        "phone": numberTXT,
        "checkin": DateTime.now(),
        "checkout": '',
        "appuser": _auth.currentUser!.email,
        "uploaded_time": DateTime.now()
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
              content: const Text("Va dorim un timp minunat!"),
              actions: <Widget>[
                // ignore: deprecated_member_use
                FlatButton(
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      color: Color(0xff6C63FF),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/visitoroption");
                  },
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
              title: const Text("Eroare"),
              content: const Text("Va rugam completati toate campurile!"),
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
