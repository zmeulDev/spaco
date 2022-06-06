import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spaco/models/user_model.dart';
import 'package:spaco/pages/appBar.dart';
import 'package:spaco/utils/constant.dart';

class Bookings extends StatefulWidget {
  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: getAppBar('Bookings'),
      body: ListView(
        children: [
          Container(
            width: width,
            height: height * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              color: primaryColor,
            ),
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Icon(
                    Iconsax.calendar_2,
                    size: 128,
                    color: secondaryColor,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  UserModel().username != ''
                      ? Text(
                          UserModel().username,
                          style: style2.copyWith(
                              color: secondaryColor, fontSize: 14),
                        )
                      : Text(
                          ' Name',
                          style: style2.copyWith(
                              color: secondaryColor, fontSize: 14),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
