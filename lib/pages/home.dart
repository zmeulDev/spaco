import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spaco/models/user_model.dart';
import 'package:spaco/pages/appBar.dart';
import 'package:spaco/utils/constant.dart';
import 'package:spaco/utils/getImages.dart';
import 'package:spaco/utils/loading.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CollectionReference qrCollection =
      FirebaseFirestore.instance.collection('codes');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: getAppBar('spaco'),
      body: getBody(height, width),
    );
  }

  getBody(height, width) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            child: Column(
              children: [
                homeInfoContainer(height, width),
                SizedBox(
                  height: height * 0.02,
                ),
                homeDetailsContainer(height, width),
              ],
            ),
          ),
        ],
      ),
    );
  }

  homeInfoContainer(height, width) {
    return Container(
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserModel().username != ''
                        ? Text(
                            UserModel().username,
                            style: style2.copyWith(
                                color: secondaryColor, fontSize: 18),
                          )
                        : Text('Hello!',
                            style: style2.copyWith(
                                color: secondaryColor, fontSize: 18)),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: height * 0.03,
            ),
            StreamBuilder(
                stream: qrCollection
                    .where('uid', isEqualTo: UserModel().uid)
                    .where('isMain', isEqualTo: '1')
                    .limit(1)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: loading(),
                    );
                  } else {
                    List<DocumentSnapshot> list = snapshot.data.docs;
                    if (list.isEmpty) {
                      return Container(
                        height: height * 0.1,
                        child: Icon(
                          Iconsax.hierarchy_square,
                          color: secondaryColor,
                          size: 64,
                        ),
                      );
                    } else {
                      return Container(
                        height: height * 0.35,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: list.length,
                          itemBuilder: (BuildContext context, int index) =>
                              Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: GetImage(
                              imagePath: list[index]['qrUrl'],
                              width: 45,
                              height: 45,
                            ),
                          ),
                        ),
                      );
                    }
                  }
                }),
          ],
        ),
      ),
    );
  }

  homeDetailsContainer(height, width) {
    return Container(
      width: width * 0.5,
      height: height * 0.13,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: primaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(
                  Iconsax.hierarchy_square,
                  color: secondaryColor,
                  size: 44,
                ),
                SizedBox(
                  width: width * 0.05,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hello!',
                        style: style2.copyWith(
                            color: secondaryColor, fontSize: 18)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
