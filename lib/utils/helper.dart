import 'package:customer_app/utils/localstorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../config/colors.dart';

// delay in milliseconds seconds
Delay(ms) async {
  await Future.delayed(Duration(milliseconds: ms));
}

class Helper {
  // full screen loader
  static fullScreenLoader(context) {
    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Container(
          color: Colors.transparent,
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  // make array of object unique by key
  static makeUniqueArrayOfObject(oldArr, key) async {
    var newArr = [];
    oldArr.forEach((item) {
      var i = newArr.indexWhere((x) => x[key] == item[key]);
      if (i <= -1) {
        newArr.add(item);
      }
    });
    return newArr;
  }

  // header with left icon
  static headerWithLeftIcon(width, height, context, title) {
    return Container(
      width: width,
      height: height * 12 / 100,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      decoration: BoxDecoration(color: AppColors.blue, boxShadow: [
        BoxShadow(
          offset: Offset(1, 1),
          blurRadius: 4,
          color: AppColors.shadow,
        ),
      ]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // back icon
          Container(
            padding: EdgeInsets.only(left: width * 3 / 100),
            child: MaterialButton(
              elevation: 0,
              minWidth: 0,
              padding: EdgeInsets.all(width * 2 / 100),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                size: width * 5 / 100,
                color: AppColors.white_text,
              ),
            ),
          ),
          // title
          Text(
            title,
            style: TextStyle(
                fontSize: width * 5 / 100,
                fontWeight: FontWeight.w500,
                color: AppColors.white_text),
          ),
        ],
      ),
    );
  }

  // close app
  static closeApp() async {
    await SystemChannels.platform
        .invokeMethod<void>('SystemNavigator.pop', true);
  }
}
