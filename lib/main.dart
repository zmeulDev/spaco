import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spaco/screens/admin/admin_bookingList.dart';
import 'package:spaco/screens/admin/admin_homePage.dart';
import 'package:spaco/screens/admin/admin_reports.dart';
import 'package:spaco/screens/admin/admin_visitorsList.dart';
import 'package:spaco/screens/auth/login.dart';
import 'package:spaco/screens/auth/signUp.dart';
import 'package:spaco/screens/booking/booking_add.dart';
import 'package:spaco/screens/booking/booking_homePage.dart';
import 'package:spaco/screens/booking/booking_view.dart';
import 'package:spaco/screens/homeScreen.dart';
import 'package:spaco/screens/profile/profilePage.dart';
import 'package:spaco/screens/visitor/tos.dart';
import 'package:spaco/screens/visitor/visitor_checkIn.dart';
import 'package:spaco/screens/visitor/visitor_checkOut.dart';
import 'package:spaco/screens/visitor/visitor_homePage.dart';
import 'package:spaco/services/authState.dart';
import 'package:spaco/utils/constant.dart';
import 'package:spaco/utils/splashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  Widget buildError(BuildContext context, FlutterErrorDetails error) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/Error.png",
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage("assets/images/welcome.png"), context);
    precacheImage(const AssetImage("assets/images/no_data.jpeg"), context);

    return MaterialApp(
      title: 'Stables',
      theme: ThemeData(
        fontFamily: GoogleFonts.nunito().fontFamily,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: primaryColor,
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        }),
      ),
      builder: (BuildContext context, Widget? widget) {
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return buildError(context, errorDetails);
        };
        return widget!;
      },
      home: SplashScreenPage(),
      routes: {
        "/home": (context) => HomeScreen(),
        "/login": (context) => LoginScreen(),
        "/signup": (context) => SignUpScreen(),
        "/auth": (context) => Auth(),
        "/profile": (context) => EditProfile(),
        "/tos": (context) => Tos(),

        // visitors section
        "/visitoroption": (context) => VisitorOption(check: true),
        "/visitorcheckin": (context) => VisitorCheckIn(),
        "/visitorcheckout": (context) => VisitorCheckOut(),

        // booking section
        "/booking": (context) => BookingHomePage(check: true),
        "/bookingadd": (context) => BookingAdd(),
        "/bookingview": (context) => BookingView(),

        // admin section
        "/adminoption": (context) {
          return AdminHomePage(check: true);
        },
        "/visitorslist": (context) => VisitorsList(),
        "/bookinglist": (context) => BookingList(),
        "/adminreports": (context) => AdminReports(),
      },
    );
  }
}