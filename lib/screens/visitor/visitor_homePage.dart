import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:spaco/utils/constant.dart';
import 'package:spaco/widgets/appBarVisitors.dart';

class VisitorOption extends StatefulWidget {
  final VoidCallback? openDrawer;
  final bool? check;
  const VisitorOption({Key? key, this.openDrawer, this.check})
      : super(key: key);

  @override
  _VisitorOptionState createState() => _VisitorOptionState();
}

class _VisitorOptionState extends State<VisitorOption> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd MMM yyyy').format(now);

    return Scaffold(
      appBar: appBarVisitors(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Bun venit la Stables!",
            style: style1,
          ),
          const SizedBox(
            height: 5,
          ),
          Text("Astazi este " + formattedDate),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: width * 0.5,
              child: Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.07,
                      width: width * 0.4,
                      child: ElevatedButton.icon(
                        icon: const Icon(
                          Icons.login_outlined,
                        ),
                        label: const Text('Check in'),
                        onPressed: () => {
                          Navigator.pushNamed(context, "/tos"),
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
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.07,
                      width: width * 0.4,
                      child: ElevatedButton.icon(
                        icon: const Icon(
                          Icons.logout_outlined,
                        ),
                        label: const Text('Check out'),
                        onPressed: () {
                          Navigator.pushNamed(context, "/visitorcheckout");
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
