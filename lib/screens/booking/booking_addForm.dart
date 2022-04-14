import 'package:awesome_select/awesome_select.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spaco/utils/constant.dart';
import 'package:spaco/utils/rooms.dart';

class BookingAddForm extends StatefulWidget {
  @override
  _BookingAddFormState createState() => _BookingAddFormState();
}

class _BookingAddFormState extends State<BookingAddForm> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  final TextEditingController _nameControl = TextEditingController();
  String _roomControl = "";
  String? _name;
  DateTime selectedFrom = DateTime.now();
  DateTime selectedTo = DateTime.now();

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
                selectedValue: _roomControl.toString(),
                placeholder: 'Select',
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
                title: 'Room:',
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
                choiceItems: options,
                onChange: (selected) =>
                    setState(() => _roomControl = selected.value!),
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
                    hintText: "* Company / Name",
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
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50, top: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 100,
                  width: 300,
                  child: DateTimePicker(
                    type: DateTimePickerType.dateTimeSeparate,
                    dateMask: 'd MMM, yyyy',
                    initialValue: DateTime.now().toString(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: Icon(Icons.timer),
                    dateLabelText: 'Date',
                    timeLabelText: "Hour",
                    selectableDayPredicate: (date) {
                      // Disable weekend days to select from the calendar
                      if (date.weekday == 6 || date.weekday == 7) {
                        return false;
                      }
                      return true;
                    },
                    onChanged: (val) => print(val),
                    validator: (val) {
                      print(val);
                      return null;
                    },
                    onSaved: (val) => selectedFrom = DateTime.tryParse(val!)!,
                  ),
                ),
                Container(
                  height: 80,
                  width: 300,
                  child: DateTimePicker(
                    type: DateTimePickerType.dateTimeSeparate,
                    dateMask: 'd MMM, yyyy',
                    initialValue: DateTime.now().toString(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    icon: Icon(Icons.access_time_outlined),
                    dateLabelText: 'Date',
                    timeLabelText: "Hour",
                    selectableDayPredicate: (date) {
                      // Disable weekend days to select from the calendar
                      if (date.weekday == 6 || date.weekday == 7) {
                        return false;
                      }

                      return true;
                    },
                    onChanged: (val) => print(val),
                    validator: (val) {
                      print(val);
                      return null;
                    },
                    onSaved: (val) => selectedTo = DateTime.tryParse(val!)!,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
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
              label: const Text('Book'),
              onPressed: () {
                _addBooking();
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

  void _addBooking() {
    final String nameTXT = _nameControl.text.trim().toUpperCase();
    final String roomTXT = _roomControl;

    if (nameTXT.isNotEmpty) {
      _formKey.currentState!.save();
      _db.collection("booking_details").add({
        "room": roomTXT,
        "name": nameTXT,
        "book_from": selectedFrom,
        "book_to": selectedTo,
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
                    Navigator.pushNamed(context, "/bookingadd");
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
