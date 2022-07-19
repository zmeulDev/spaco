import 'package:avatar_view/avatar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:spaco/pages/appBar.dart';
import 'package:spaco/services/booking_service.dart';
import 'package:spaco/utils/constant.dart';
import 'package:spaco/utils/getImages.dart';
import 'package:spaco/utils/spacoInputWidget.dart';
import 'package:spaco/utils/loading.dart';

class Bookings extends StatefulWidget {
  @override
  State<Bookings> createState() => _BookingsState();
}

class _BookingsState extends State<Bookings> {
  bool isLoading = false;
  bool isChecked = false;

  TextEditingController bookingContactController = TextEditingController();
  TextEditingController bookingNameController = TextEditingController();
  TextEditingController bookingEmailController = TextEditingController();
  TextEditingController bookingPhoneController = TextEditingController();

  bookingStore() async {
    BookingServices.uploadBookingDataToFirestore(
            uid: BookingServices.bookingRef.doc().id,
            bookingContact: bookingContactController.text,
            bookingName: bookingNameController.text,
            bookingEmail: bookingEmailController.text,
            bookingPhone: bookingPhoneController.text)
        .whenComplete(() {
      Get.back();
      Get.snackbar('Info', 'Room added.');
    });
  }

  bookingUpdate(detail) async {
    var bookingContactUpdate = bookingContactController.text.isEmpty
        ? detail['bookingcontact']
        : bookingContactController.text;

    var bookingNameUpdate = bookingNameController.text.isEmpty
        ? detail['bookingname']
        : bookingNameController.text;

    var bookingEmailUpdate = bookingEmailController.text.isEmpty
        ? detail['bookingemail']
        : bookingEmailController.text;

    var bookingPhoneUpdate = bookingPhoneController.text.isEmpty
        ? detail['bookingphone']
        : bookingPhoneController.text;

    BookingServices.updateBookingDataInFirestore(
            detail.reference.id,
            bookingContactUpdate,
            bookingNameUpdate,
            bookingEmailUpdate,
            bookingPhoneUpdate)
        .whenComplete(() {
      Get.back();
      Get.snackbar('Info', 'Room updated.');
    });
  }

  bookingDelete(detail) async {
    // delete booking from firebase and related image storage
    BookingServices.deleteBooking(detail.id);
    detail['profileurl'] != ''
        ? BookingServices.deleteBookingImage(detail['profileurl'])
        : null;
    Get.back();
    Get.snackbar('Delete', 'booking deleted');
  }

  bookingTopHeader() {
    return Container(
      width: Get.width,
      height: Get.height * 0.20,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(1.0),
        child: Column(
          children: [
            Container(
                height: Get.height * 0.18,
                child: SvgPicture.asset('assets/svg/booking.svg')),
          ],
        ),
      ),
    );
  }

  bookingAddWidget() {
    return Container(
      height: Get.height * 0.05,
      width: Get.width * 0.933,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        color: secondaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.all(2),
            height: Get.height * 0.2,
            width: Get.width * 0.30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: tertiaryColor,
            ),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  bookingAddSheet();
                },
                child: Text(
                  'Add room',
                  style: style2.copyWith(color: secondaryColor),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  bookingBody() {
    CollectionReference roomsCollection =
        FirebaseFirestore.instance.collection('bookings');

    return StreamBuilder(
        stream: roomsCollection.snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loading(),
            );
          } else {
            List<DocumentSnapshot> bookingList = snapshot.data.docs;
            if (bookingList.isEmpty) {
              return Container(
                  height: Get.height * 0.4,
                  padding: EdgeInsets.all(20),
                  child: SvgPicture.asset('assets/svg/nothing.svg'));
            } else {
              return Container(
                padding: EdgeInsets.all(12),
                child: GridView.builder(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 2 / 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10),
                    itemCount: bookingList.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return GestureDetector(
                        onTap: () {
                          bookingDetailSheet(bookingList[index]['uid']);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: sixthColor,
                            image: DecorationImage(
                              image: AssetImage('assets/card_bck.jpeg'),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                  fourthColor, BlendMode.modulate),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 5, left: 10, right: 5, bottom: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    bookingList[index]['profileurl'] == ''
                                        ? Icon(
                                            FeatherIcons.coffee,
                                            color: secondaryColor,
                                            size: 44,
                                          )
                                        : GetImage(
                                            imagePath: bookingList[index]
                                                ['profileurl'],
                                            width: 45,
                                            height: 45,
                                            radius: 12,
                                          ),
                                    SizedBox(
                                      width: Get.width * 0.05,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          bookingList[index]['bookingname'],
                                          style: style2.copyWith(
                                              color: secondaryColor),
                                        ),
                                        Text(
                                          bookingList[index]['bookingcontact'],
                                          style: style2.copyWith(
                                              color: secondaryColor),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              );
            }
          }
        });
  }

  bookingAddSheet() {
    return Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: sixthColor,
          image: DecorationImage(
            image: AssetImage('assets/card_bck.jpeg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(fourthColor, BlendMode.modulate),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        height: Get.height * 0.6,
        margin: EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(
                'Add new booking',
                style: style1,
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: spacoInput(
                        'booking name',
                        'Name',
                        TextInputType.text,
                        FeatherIcons.file,
                        bookingNameController),
                  ),
                  Expanded(
                    child: spacoInput(
                        'booking email',
                        'Email',
                        TextInputType.emailAddress,
                        FeatherIcons.mail,
                        bookingEmailController),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: spacoInput(
                        'booking contact',
                        'Contact',
                        TextInputType.text,
                        FeatherIcons.user,
                        bookingContactController),
                  ),
                  Expanded(
                    child: spacoInput(
                        'booking phone',
                        'Phone',
                        TextInputType.phone,
                        FeatherIcons.phone,
                        bookingPhoneController),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: Get.height * 0.04),
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
                            style: style2.copyWith(color: primaryColor),
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
                            bookingStore();
                          },
                          style: ElevatedButton.styleFrom(
                              primary: tertiaryColor,
                              padding: const EdgeInsets.all(13),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              )),
                          child: Text(
                            'Save',
                            style: style2.copyWith(color: secondaryColor),
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
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      isScrollControlled: true,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  bookingDetailSheet(uid) {
    CollectionReference bookingsDetailCollection =
        FirebaseFirestore.instance.collection('bookings');

    return Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: sixthColor,
            image: DecorationImage(
              image: AssetImage('assets/card_bck.jpeg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(fourthColor, BlendMode.modulate),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          height: Get.height * 0.85,
          child: StreamBuilder<QuerySnapshot>(
            stream: bookingsDetailCollection
                .where('uid', isEqualTo: uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot detail = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Text(
                              'Booking details',
                              style: style1.copyWith(color: secondaryColor),
                            ),
                            SizedBox(
                              height: Get.height * 0.02,
                            ),
                            Stack(
                              children: [
                                Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        offset: Offset(
                                            1, 1), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: AvatarView(
                                    radius: 75,
                                    borderColor: secondaryColor,
                                    avatarType: AvatarType.CIRCLE,
                                    backgroundColor: primaryColor,
                                    imagePath: detail['profileurl'] == ''
                                        ? 'assets/user.png'
                                        : detail['profileurl'],
                                    placeHolder: Container(
                                      color: secondaryColor,
                                      child: Icon(
                                        FeatherIcons.user,
                                        size: 36,
                                      ),
                                    ),
                                    errorWidget: Container(
                                      color: fourthColor,
                                      child: Icon(
                                        FeatherIcons.user,
                                        size: 36,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: CircleAvatar(
                                      backgroundColor: fourthColor,
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.edit_outlined,
                                          size: 20,
                                          color: secondaryColor,
                                        ),
                                        splashRadius: 5.0,
                                        splashColor: Colors.grey,
                                      ),
                                    ))
                              ],
                            ),
                            SizedBox(
                              height: Get.height * 0.02,
                            ),
                          ],
                        ),
                      );
                    });
              } else {
                return Text("No data");
              }
            },
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      isScrollControlled: true,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar('Bookings', context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            bookingTopHeader(),
            bookingAddWidget(),
            bookingBody(),
          ],
        ),
      ),
    );
  }
}
