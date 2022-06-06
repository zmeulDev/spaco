import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:spaco/models/partner_model.dart';
import 'package:spaco/pages/appBar.dart';
import 'package:spaco/services/partner_services.dart';
import 'package:spaco/utils/constant.dart';
import 'package:spaco/utils/inputwidget.dart';

class Partners extends StatefulWidget {
  @override
  State<Partners> createState() => _PartnersState();
}

class _PartnersState extends State<Partners> {
  bool isLoading = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: getAppBar('Partners'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
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
                      Iconsax.layer,
                      size: 128,
                      color: secondaryColor,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    PartnerModel().partnerName != ''
                        ? Text(
                            PartnerModel().partnerName,
                            style: style2.copyWith(
                                color: fourthColor, fontSize: 18),
                          )
                        : Text('No Partners',
                            style: style2.copyWith(
                                color: fourthColor, fontSize: 18))
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            partnerDetailsContainer(height, width),
            Container(
              width: width * 0.5,
              height: height * 0.13,
              child: ElevatedButton(
                  onPressed: () {
                    addPartner(height, width);
                  },
                  child: Text('pushMe')),
            )
          ],
        ),
      ),
    );
  }

  addPartner(height, width) {
    return Get.bottomSheet(
      Container(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            spacoInput('Type partner name', 'Name', TextInputType.text,
                Iconsax.text, nameController),
            spacoInput('Type email', 'Email', TextInputType.emailAddress,
                Iconsax.message4, emailController),
            Container(
              margin: EdgeInsets.only(top: height * 0.08),
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 52,
                    width: 80,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: isLoading == true
                            ? () {}
                            : () {
                                Get.back();
                              },
                        style: ElevatedButton.styleFrom(
                            primary: secondaryColor,
                            padding: const EdgeInsets.all(13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                        child: Text(
                          'Cancel',
                          style: style2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    height: 52,
                    width: 80,
                    child: Center(
                      child: ElevatedButton(
                        onPressed: () {
                          PartnerServices.uploadPartnerDataToFirestore(
                                  partnerName: nameController.text,
                                  email: emailController.text)
                              .then(
                            (value) => Get.snackbar(
                              'Success',
                              'data stored',
                              icon: Icon(Iconsax.save_add),
                              backgroundColor: successColor,
                            ),
                          );
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                            primary: secondaryColor,
                            padding: const EdgeInsets.all(13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            )),
                        child: Text(
                          'Save',
                          style: style2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: primaryColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  partnerDetailsContainer(height, width) {
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
