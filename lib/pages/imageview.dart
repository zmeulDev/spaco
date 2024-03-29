import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:spaco/utils/constant.dart';

class ImageViewPage extends StatelessWidget {
  final String img;

  const ImageViewPage({Key? key, required this.img}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(),
      backgroundColor: primaryColor,
      extendBodyBehindAppBar: true,
      body: Center(
        child: PhotoView(
          backgroundDecoration: const BoxDecoration(
            color: primaryColor,
          ),
          imageProvider: NetworkImage(img),
        ),
      ),
    );
  }

  getAppBar() {
    return AppBar(
      backgroundColor: primaryColor,
      elevation: 0.0,
      leading: Center(
          child: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          color: tertiaryColor,
          size: 20,
        ),
      )),
    );
  }
}
