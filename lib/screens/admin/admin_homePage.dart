import 'package:flutter/material.dart';
import 'package:spaco/utils/constant.dart';
import 'package:spaco/utils/waveClipper.dart';
import 'package:spaco/widgets/appBarAdmin.dart';

class AdminHomePage extends StatefulWidget {
  final VoidCallback? openDrawer;
  final bool? check;

  const AdminHomePage({Key? key, this.openDrawer, this.check})
      : super(key: key);

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
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
                          image: ExactAssetImage('assets/images/admin.jpg'),
                          fit: BoxFit.fill,
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
              "Admin",
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
                      Navigator.pushNamed(context, "/visitorslist");
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.people_alt_outlined,
                          color: Color(0xff5E5E77),
                          size: 36,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Visitors",
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
                    color: const Color(0xffE0E3E4),
                    borderRadius: BorderRadius.circular(21),
                  ),
                  // ignore: deprecated_member_use
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/booking");
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.calendar_today_outlined,
                          color: Color(0xff5E5E77),
                          size: 36,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Booking",
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
                    color: const Color(0xffC6C7C4).withOpacity(0.4),
                    borderRadius: BorderRadius.circular(21),
                  ),
                  // ignore: deprecated_member_use
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/adminreports");
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.bar_chart,
                          color: Color(0xff5E5E77),
                          size: 36,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Reports",
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
