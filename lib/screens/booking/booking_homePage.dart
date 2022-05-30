import 'package:flutter/material.dart';
import 'package:spaco/utils/constant.dart';
import 'package:spaco/utils/waveClipper.dart';
import 'package:spaco/widgets/appBarAdmin.dart';

class BookingHomePage extends StatefulWidget {
  final VoidCallback? openDrawer;
  final bool? check;

  const BookingHomePage({Key? key, this.openDrawer, this.check})
      : super(key: key);

  @override
  _BookingHomePageState createState() => _BookingHomePageState();
}

class _BookingHomePageState extends State<BookingHomePage> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: appBarAdmin(context),
      body: Container(
        child: Column(
          children: [
            Stack(
              children: <Widget>[
                Opacity(
                  opacity: 0.7,
                  child: ClipPath(
                    clipper: WaveClipper(),
                    child: Container(
                      color: tertiaryColor,
                      height: height * 0.32,
                    ),
                  ),
                ),
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 50),
                    color: kashmirColor,
                    height: height * 0.3,
                    alignment: Alignment.center,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 130),
                      width: 150.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: ExactAssetImage('assets/images/booking.jpg'),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: height / 80,
            ),
            Text(
              "Booking",
              style: style1.copyWith(fontSize: 28),
            ),
            SizedBox(
              height: height / 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                    color: const Color(0xffE0E3E4),
                    borderRadius: BorderRadius.circular(21),
                  ),
                  // ignore: deprecated_member_use
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/bookinglist");
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.table_rows_outlined,
                          color: Color(0xff5E5E77),
                          size: 36,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "View",
                          style: TextStyle(
                            color: Color(0xff5E5E77),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                    color: const Color(0xffC6C7C4).withOpacity(0.4),
                    borderRadius: BorderRadius.circular(21),
                  ),
                  // ignore: deprecated_member_use
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/bookingadd");
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.add_box_outlined,
                          color: Color(0xff5E5E77),
                          size: 36,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Add",
                          style: TextStyle(
                            color: Color(0xff5E5E77),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
