import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spaco/utils/constant.dart';

// TODO see if can be implemented everywhere

class SpacoButtonsAction extends StatefulWidget {
  final saveButtonAction;

  const SpacoButtonsAction({Key? key, this.saveButtonAction}) : super(key: key);

  @override
  State<SpacoButtonsAction> createState() => _SpacoButtonsActionState();
}

class _SpacoButtonsActionState extends State<SpacoButtonsAction> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: Get.height * 0.04,
            width: Get.width * 0.2,
            child: ElevatedButton(
              onPressed: isLoading == true
                  ? () {}
                  : () {
                      Get.back();
                    },
              style: ElevatedButton.styleFrom(
                  primary: secondaryColor,
                  padding: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
              child: Text(
                'Cancel',
                style: style3.copyWith(color: primaryColor),
              ),
            ),
          ),
          SizedBox(
            width: Get.width * 0.05,
          ),
          SizedBox(
            height: Get.height * 0.04,
            width: Get.width * 0.2,
            child: ElevatedButton(
              onPressed: () {
                widget.saveButtonAction();
              },
              style: ElevatedButton.styleFrom(
                  primary: tertiaryColor,
                  padding: const EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  )),
              child: Text(
                'Save',
                style: style3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
