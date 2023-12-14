import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:customer_app/config/colors.dart';

class SelectPaymentOptions extends ConsumerStatefulWidget {
  Function onPayAtCounter;
  Function onPayOnline;

  SelectPaymentOptions(
      {required this.onPayAtCounter, required this.onPayOnline});

  @override
  ConsumerState<SelectPaymentOptions> createState() =>
      _SelectPaymentOptionsState();
}

class _SelectPaymentOptionsState extends ConsumerState<SelectPaymentOptions> {
  @override
  Widget build(BuildContext context) {
    var widthsize = MediaQuery.of(context).size.width;
    var heightsize = MediaQuery.of(context).size.height;

    return Container(
      width: widthsize * 80 / 100,
      height: heightsize * 18 / 100,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(widthsize * 5 / 100),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.all(Radius.circular(widthsize * 1 / 100))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              child: Text(
            "Select payment option",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: widthsize * 4.4 / 100,
                color: AppColors.black_text,
                fontWeight: FontWeight.bold),
          )),

          //  pay online
          Container(
            width: widthsize * 80 / 100,
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: heightsize * 1 / 100),
            child: MaterialButton(
              onPressed: () => {widget.onPayOnline()},
              minWidth: 0,
              padding: EdgeInsets.all(0),
              child: Container(
                width: widthsize * 50 / 100,
                child: Text(
                  "Pay Online",
                  style: TextStyle(
                      fontSize: widthsize * 3.8 / 100,
                      fontWeight: FontWeight.w500,
                      color: AppColors.black_text),
                ),
              ),
            ),
          ),

          // pay at counter
          Container(
              width: widthsize * 80 / 100,
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(top: heightsize * 1 / 100),
              child: MaterialButton(
                onPressed: () => {widget.onPayAtCounter()},
                minWidth: 0,
                padding: EdgeInsets.all(0),
                child: Container(
                  width: widthsize * 50 / 100,
                  child: Text(
                    "Pay At Counter",
                    style: TextStyle(
                        fontSize: widthsize * 3.8 / 100,
                        fontWeight: FontWeight.w500,
                        color: AppColors.black_text),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
