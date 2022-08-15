// ignore_for_file: file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spaco/utils/constant.dart';

import 'spacoLoading.dart';

// ignore: must_be_immutable
class SpacoShowImage extends StatelessWidget {
  String imagePath;
  final double width;
  final double height;
  final BoxFit fit;
  final double radius;
  final bool isAssets;
  final bool isSvg;
  final loadingColor;

  SpacoShowImage(
      {Key? key,
      this.imagePath = 'assets/logo/spaco_logo_green_512.png',
      required this.width,
      required this.height,
      this.fit = BoxFit.cover,
      this.radius = 0.0,
      this.isAssets = false,
      this.isSvg = false,
      this.loadingColor = tertiaryColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: this is not working
    if (imagePath == '') {
      imagePath = 'assets/logo/spaco_logo_green_512.png';
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: isAssets
          ? SizedBox(
              height: height,
              width: width,
              child: Image.asset(
                imagePath,
                color: primaryColor,
                width: width,
                height: height,
              ),
            )
          : CachedNetworkImage(
              imageUrl: imagePath,
              imageBuilder: (context, imageProvider) => Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  border: Border.all(width: 0, color: Colors.transparent),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: fit,
                  ),
                ),
              ),
              placeholder: (context, url) => SizedBox(
                height: height,
                width: width,
                child: spacoLoading(),
              ),
              errorWidget: (context, url, error) =>
                  const Icon(CupertinoIcons.alarm),
            ),
    );
  }
}
