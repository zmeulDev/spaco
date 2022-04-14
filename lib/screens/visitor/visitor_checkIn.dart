import 'package:flutter/material.dart';
import 'package:spaco/screens/visitor/visitor_checkInForm.dart';

class VisitorCheckIn extends StatefulWidget {
  @override
  _VisitorCheckInState createState() => _VisitorCheckInState();
}

class _VisitorCheckInState extends State<VisitorCheckIn> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.15,
              ),
              const Text(
                "Check-in",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff5E5E77),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              VisitorCheckInForm(),
            ],
          ),
        ),
      ),
    );
  }
}
