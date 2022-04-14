import 'package:flutter/material.dart';
import 'package:spaco/screens/booking/booking_addForm.dart';
import 'package:spaco/widgets/appBar.dart';

class BookingAdd extends StatefulWidget {
  @override
  _BookingAddState createState() => _BookingAddState();
}

class _BookingAddState extends State<BookingAdd> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: appBar(context),
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
                "Book a room",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff5E5E77),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              BookingAddForm(),
            ],
          ),
        ),
      ),
    );
  }
}
