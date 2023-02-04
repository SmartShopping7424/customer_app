import 'package:customer_app/config/colors.dart';
import 'package:flutter/material.dart';

class EmptyData extends StatefulWidget {
  String? message;
  String? buttonText;
  Function? buttonPress;

  EmptyData(this.message, this.buttonText, this.buttonPress);

  @override
  State<EmptyData> createState() => _EmptyDataState();
}

class _EmptyDataState extends State<EmptyData> {
  @override
  Widget build(BuildContext context) {
    var widthsize = MediaQuery.of(context).size.width;

    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
                fit: BoxFit.scaleDown,
                width: widthsize * 60 / 100,
                image: AssetImage("assets/nodata.png")),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.message!.length > 0
                    ? Container(
                        child: Text(
                          widget.message!,
                          style: TextStyle(
                            fontSize: widthsize * 3.5 / 100,
                          ),
                        ),
                      )
                    : Container(),
                widget.buttonText!.length > 0
                    ? Container(
                        child: MaterialButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          padding: EdgeInsets.only(left: widthsize * 1 / 100),
                          onPressed: () {
                            widget.buttonPress!();
                          },
                          child: Container(
                            child: Text(
                              "Scan Product",
                              style: TextStyle(
                                  fontSize: widthsize * 3.5 / 100,
                                  color: AppColors.blue),
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
