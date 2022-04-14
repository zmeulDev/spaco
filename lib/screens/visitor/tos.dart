import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spaco/utils/constant.dart';

class Tos extends StatefulWidget {
  static String id = "faqs";
  @override
  _TosState createState() => _TosState();
}

class _TosState extends State<Tos> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: AnimatedOpacity(
        duration: Duration(milliseconds: 1000),
        opacity: 0.8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: height / 20),
              child: FloatingActionButton(
                onPressed: () {
                  _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.fastOutSlowIn);
                },
                child: Icon(
                  Icons.arrow_circle_down,
                  size: 26,
                ),
                backgroundColor: tertiaryColor,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: secondaryColor,
      body: Column(
        children: [
          Container(
            height: height,
            child: DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: tertiaryColor,
                  bottom: TabBar(
                    padding: EdgeInsets.all(5),
                    indicator: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(21), // Creates border
                        color: secondaryColor),
                    tabs: [
                      Tab(
                          icon: Text('Romana',
                              style: style3.copyWith(
                                  fontWeight: FontWeight.bold))),
                      Tab(
                          icon: Text('English',
                              style: style3.copyWith(
                                  fontWeight: FontWeight.bold))),
                    ],
                  ),
                  title: Text(
                    'Check in @ Stables',
                    style: style2.copyWith(color: secondaryColor),
                  ),
                ),
                body: TabBarView(
                  children: [
                    roTos(),
                    engTos(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  roTos() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          InteractiveViewer(
            panEnabled: false, // Set it to false
            boundaryMargin: const EdgeInsets.all(100),
            minScale: 0.5,
            maxScale: 2,
            child: Image.asset(
              'assets/images/stable_tos_1.png',
              fit: BoxFit.cover,
            ),
          ),
          InteractiveViewer(
            panEnabled: false, // Set it to false
            boundaryMargin: const EdgeInsets.all(100),
            minScale: 0.5,
            maxScale: 2,
            child: Image.asset(
              'assets/images/stable_tos_2.png',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Cerem vizitatorilor sa se inregistreze la receptia noastra, utilizand aplicatia Stables, astfel incat sa putem pastra o evidenta a vizitatorilor pentru o perioada scurta de timp, respectiv 30 zile. Datele cu caracter personal nu vor fi prelucrate in niciun fel.',
              textAlign: TextAlign.justify,
              style: styleTos,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Subsemnatul, declar ca am fost instruit si am luat la cunostinta materialul continand instructiunile proprii de securitate si sanatate in munca, la momentul intrarii pe amplasament.',
              textAlign: TextAlign.justify,
              style: styleTos,
            ),
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Container(
                      height: height * 0.05,
                      width: width * 0.3,
                      child: ElevatedButton.icon(
                        icon: const Icon(
                          Icons.cancel,
                        ),
                        label: const Text('Renunta'),
                        onPressed: () => {
                          Navigator.pushNamed(context, "/visitoroption"),
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: tertiaryColor,
                          elevation: 0.0,
                          textStyle: style3,
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
                    Container(
                      height: height * 0.05,
                      width: width * 0.6,
                      child: ElevatedButton.icon(
                        icon: const Icon(
                          Icons.check,
                        ),
                        label: const Text('Am luat la cunostinta.'),
                        onPressed: () {
                          Navigator.pushNamed(context, "/visitorcheckin");
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          elevation: 0.0,
                          textStyle: style3,
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

  engTos() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          InteractiveViewer(
            panEnabled: false, // Set it to false
            boundaryMargin: const EdgeInsets.all(100),
            minScale: 0.5,
            maxScale: 2,
            child: Image.asset(
              'assets/images/stable_tos_eng_1.png',
              fit: BoxFit.cover,
            ),
          ),
          InteractiveViewer(
            panEnabled: false, // Set it to false
            boundaryMargin: const EdgeInsets.all(100),
            minScale: 0.5,
            maxScale: 2,
            child: Image.asset(
              'assets/images/stable_tos_eng_2.png',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'We ask our visitors to register at the reception, using the Stables application, so that we can keep track of the visitors for a short period of time, respectively 30 days. Personal data will not be processed in any way.',
              textAlign: TextAlign.justify,
              style: styleTos,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'I, the undersigned, declare that I have been trained and have read the material containing my own occupational safety and health instructions at the time of entering the site.',
              textAlign: TextAlign.justify,
              style: styleTos,
            ),
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Container(
                      height: height * 0.05,
                      width: width * 0.3,
                      child: ElevatedButton.icon(
                        icon: const Icon(
                          Icons.cancel,
                        ),
                        label: const Text('Cancel'),
                        onPressed: () => {
                          Navigator.pushNamed(context, "/visitoroption"),
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: tertiaryColor,
                          elevation: 0.0,
                          textStyle: style3,
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
                    Container(
                      height: height * 0.05,
                      width: width * 0.6,
                      child: ElevatedButton.icon(
                        icon: const Icon(
                          Icons.check,
                        ),
                        label: const Text('I acknowledge.'),
                        onPressed: () {
                          Navigator.pushNamed(context, "/visitorcheckin");
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.green,
                          elevation: 0.0,
                          textStyle: style3,
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
