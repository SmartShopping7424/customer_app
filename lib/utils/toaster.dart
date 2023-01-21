import 'package:flutter/material.dart';
import '../config/colors.dart';

class Toaster {
  // toast message
  static toastMessage(msg, context) {
    var widthsize = MediaQuery.of(context).size.width;
    var heightsize = MediaQuery.of(context).size.height;

    // snack-bar widget
    final snackBar = SnackBar(
      padding: EdgeInsets.all(widthsize * 3 / 100),
      margin: EdgeInsets.only(
          left: widthsize * 20 / 100,
          right: widthsize * 20 / 100,
          bottom: heightsize * 10 / 100),
      clipBehavior: Clip.hardEdge,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 1500),
      elevation: 0,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColors.black_text_opacity),
          borderRadius:
              BorderRadius.all(Radius.circular(widthsize * 1.5 / 100))),
      content: Text(msg,
          style: TextStyle(
            fontSize: widthsize * 3 / 100,
            color: AppColors.white_text,
          )),
      backgroundColor: AppColors.black_text,
    );

    // show the snack-bar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
