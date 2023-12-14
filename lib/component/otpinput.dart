import 'package:customer_app/config/colors.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OTPInput extends StatefulWidget {
  var mobile;
  var errorText;
  bool isError;
  Function onComplete;

  OTPInput(
      {required this.mobile,
      required this.errorText,
      required this.isError,
      required this.onComplete});

  @override
  _OTPInputState createState() => _OTPInputState();
}

class _OTPInputState extends State<OTPInput> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  bool showError = false;

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var widthsize = MediaQuery.of(context).size.width;
    var heightsize = MediaQuery.of(context).size.height;
    if (widget.isError) {
      setState(() {
        showError = true;
      });
    }
    var defaultPinTheme = PinTheme(
      width: widthsize * 11 / 100,
      height: widthsize * 11 / 100,
      margin: EdgeInsets.only(
          top: heightsize * 2 / 100, right: widthsize * 5 / 100),
      textStyle: TextStyle(
        fontSize: widthsize * 4 / 100,
        color: AppColors.black_text,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.disable),
      ),
    );

    return Container(
      width: widthsize,
      margin: EdgeInsets.only(
        left: widthsize * 5 / 100,
        right: widthsize * 5 / 100,
        top: heightsize * 3 / 100,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // title
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text:
                              'Enter the verification code we just sent you on your mobile number ',
                          style: TextStyle(
                              fontSize: widthsize * 4.5 / 100,
                              color: AppColors.black_text)),
                      TextSpan(
                          text: widget.mobile.toString(),
                          style: TextStyle(
                              fontSize: widthsize * 4.5 / 100,
                              color: AppColors.blue,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

          // otp input
          Pinput(
            length: 4,
            controller: controller,
            focusNode: focusNode,
            forceErrorState: showError,
            defaultPinTheme: defaultPinTheme,
            onChanged: (pin) {
              setState(() {
                showError = false;
              });
            },
            onCompleted: (pin) {
              if (pin != '1234') {
                setState(() {
                  showError = true;
                });
              } else {
                widget.onComplete(pin);
              }
            },
            errorText:
                widget.errorText == "" ? "Invalid OTP" : widget.errorText,
            focusedPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration!.copyWith(
                border: Border.all(color: AppColors.blue),
              ),
            ),
            errorPinTheme: defaultPinTheme.copyWith(
              decoration: defaultPinTheme.decoration!.copyWith(
                border: Border.all(color: AppColors.error),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
