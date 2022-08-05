import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spaco/utils/constant.dart';

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
    return Container(
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
                  widget.saveButtonAction();
                },
                style: ElevatedButton.styleFrom(
                    primary: tertiaryColor,
                    padding: EdgeInsets.all(13),
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
    );
  }
}
