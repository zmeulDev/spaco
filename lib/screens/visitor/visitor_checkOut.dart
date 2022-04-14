import 'package:flutter/material.dart';
import 'package:spaco/screens/visitor/visitor_checkOutForm.dart';
import 'package:spaco/utils/constant.dart';

class VisitorCheckOut extends StatefulWidget {
  @override
  _VisitorCheckOutState createState() => _VisitorCheckOutState();
}

class _VisitorCheckOutState extends State<VisitorCheckOut> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
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
              Text(
                "Check-out",
                style: style1,
              ),
              VisitorCheckOutForm(),
            ],
          ),
        ),
      ),
    );
  }
}
