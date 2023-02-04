import 'dart:convert';
import 'package:customer_app/services/customer/customerapi.dart';
import 'package:customer_app/utils/localstorage.dart';
import 'package:customer_app/utils/pushNotification.dart';
import 'package:customer_app/utils/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:customer_app/config/colors.dart';
import 'package:customer_app/provider/rootprovider.dart';
import 'package:customer_app/services/login/loginapi.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../utils/helper.dart';
import '../app.dart';

class Login extends ConsumerStatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  RootModel? readProvider;
  TextEditingController mobileController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  var mobileFocusNode = FocusNode();
  var otpFocusNode = FocusNode();
  var mobileError = '';
  var otpError = '';
  var isLoading = false;
  var sendOtp = false;
  var hasFoucs = "";

  // check mobile data
  checkMobileData() async {
    setState(() {
      isLoading = true;
    });
    final value = mobileController.text;
    RegExp regExp = new RegExp(r'(^(?:[+6]9)?[6-9]{1}[0-9]{9}$)');
    if (value.length == 0) {
      setState(() {
        mobileError = 'Please enter mobile number';
        isLoading = false;
      });
    } else if (!regExp.hasMatch(value)) {
      setState(() {
        mobileError = 'Please enter valid mobile number';
        isLoading = false;
      });
    } else {
      setState(() {
        mobileError = '';
      });
      getOtp();
    }
  }

  // get otp
  getOtp() async {
    mobileFocusNode.unfocus();
    var res = await LoginAPI.checkMobile(mobileController.text, "customer");
    await Delay(1000);
    if (res['code'] == 200) {
      Toaster.toastMessage("OTP has been sent successfully.", context);
      setState(() {
        isLoading = false;
        sendOtp = true;
      });
    } else {
      Toaster.toastMessage(res['message'], context);
      setState(() {
        isLoading = false;
      });
    }
  }

  // check otp data
  checkOtpData() {
    setState(() {
      isLoading = true;
    });
    final value = otpController.text;
    if (value != "1234") {
      setState(() {
        otpError = 'Invalid otp';
        isLoading = false;
      });
    } else {
      setState(() {
        otpError = '';
      });
      onLogin();
    }
  }

  // on login
  onLogin() async {
    otpFocusNode.unfocus();
    var res = await LoginAPI.checkOtp(
        mobileController.text, otpController.text, 'customer');
    if (res['code'] == 200) {
      await LocalStorage.setLocalStorage("mobile", mobileController.text);
      await LocalStorage.setLocalStorage("token", res['data']['token']);
      getCustomerData();
    } else {
      Toaster.toastMessage(res['data']['message'], context);
      setState(() {
        isLoading = false;
      });
    }
  }

  // get customer data
  getCustomerData() async {
    var res = await CustomerAPI.getData(mobileController.text);
    var pushNotificationToken =
        await ref.read(pushNotificationProvider).getPushNotificationToken();
    print("Notification Token :::  $pushNotificationToken");
    await Delay(1000);
    if (res['code'] == 200) {
      var customerData = res['data'];
      await LocalStorage.setLocalStorage("route_name", "login");
      await LocalStorage.setLocalStorage('customer', jsonEncode(customerData));
      await readProvider!.customerProviderRead.updateCustomerData();
      Toaster.toastMessage("Login successful.", context);
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => App(3)), (_) => false);
    } else {
      Toaster.toastMessage(
          "Something went wrong. Please try again later.", context);
      mobileController.clear();
      otpController.clear();
      setState(() {
        isLoading = false;
        sendOtp = false;
      });
    }
  }

  // event listener for focus node
  nodeEventListener() async {
    mobileFocusNode.addListener(() {
      if (mobileFocusNode.hasFocus) {
        setState(() {
          hasFoucs = "mobile";
        });
      } else if (!mobileFocusNode.hasFocus && !otpFocusNode.hasFocus) {
        setState(() {
          hasFoucs = "";
        });
      }
    });
    otpFocusNode.addListener(() {
      if (otpFocusNode.hasFocus) {
        setState(() {
          hasFoucs = "otp";
        });
      } else if (!mobileFocusNode.hasFocus && !otpFocusNode.hasFocus) {
        setState(() {
          hasFoucs = "";
        });
      }
    });
  }

  @override
  void initState() {
    setState(() {
      readProvider = ref.read(rootProvider).AllProvider();
    });
    nodeEventListener();
    super.initState();
  }

  @override
  void dispose() {
    mobileFocusNode.dispose();
    otpFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var widthsize = MediaQuery.of(context).size.width;
    var heightsize = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () => {mobileFocusNode.unfocus(), otpFocusNode.unfocus()},
      child: Scaffold(
        body: Container(
            width: widthsize,
            child: Column(
              children: [
                // image
                Container(
                  width: widthsize * 60 / 100,
                  height: widthsize * 60 / 100,
                  margin: EdgeInsets.only(top: heightsize * 6 / 100),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            sendOtp ? "assets/otp.png" : "assets/login.png")),
                  ),
                ),
                InputBox(heightsize, widthsize),
                Button(widthsize, heightsize)
              ],
            )),
      ),
    );
  }

  Container InputBox(double heightsize, double widthsize) {
    return Container(
      margin: EdgeInsets.only(top: heightsize * 3 / 100),
      padding: EdgeInsets.only(
          left: widthsize * 5 / 100, right: widthsize * 5 / 100),
      child: TextField(
        enabled: !isLoading,
        onChanged: (text) {
          setState(() {
            mobileError = '';
            otpError = '';
          });
        },
        focusNode: sendOtp ? otpFocusNode : mobileFocusNode,
        controller: sendOtp ? otpController : mobileController,
        keyboardType: TextInputType.number,
        maxLength: sendOtp ? 4 : 10,
        cursorColor: AppColors.blue,
        style: TextStyle(
            fontSize: widthsize * 4 / 100, color: AppColors.black_text),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          prefix: !sendOtp
              ? Container(
                  width: widthsize * 7 / 100,
                  child: Text(
                    "+91- ",
                    style: TextStyle(
                        fontSize: widthsize * 4 / 100,
                        color: AppColors.black_text),
                  ))
              : null,
          counterText: '',
          contentPadding: EdgeInsets.all(widthsize * 3 / 100),
          floatingLabelStyle: TextStyle(
            color: sendOtp
                ? (otpError.length > 0
                    ? AppColors.error
                    : hasFoucs == 'otp' && !isLoading
                        ? AppColors.blue
                        : AppColors.disable)
                : (mobileError.length > 0
                    ? AppColors.error
                    : hasFoucs == 'mobile' && !isLoading
                        ? AppColors.blue
                        : AppColors.disable),
          ),
          labelStyle: TextStyle(
              color: sendOtp
                  ? (otpError.length > 0 ? AppColors.error : AppColors.disable)
                  : (mobileError.length > 0
                      ? AppColors.error
                      : AppColors.disable)),
          labelText: sendOtp ? "Enter OTP" : "Mobile Number",
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.disable)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: AppColors.blue)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.error)),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.error)),
          errorStyle:
              TextStyle(fontSize: widthsize * 3 / 100, color: AppColors.error),
          errorText: sendOtp
              ? (otpError.length > 0 ? otpError : null)
              : (mobileError.length > 0 ? mobileError : null),
        ),
      ),
    );
  }

  Container Button(double widthsize, double heightsize) {
    return Container(
      width: widthsize,
      height: heightsize * 5 / 100,
      margin: EdgeInsets.only(top: heightsize * 3 / 100),
      padding: EdgeInsets.only(
          left: widthsize * 5 / 100, right: widthsize * 5 / 100),
      child: MaterialButton(
        elevation: 0,
        color: AppColors.blue,
        onPressed: () {
          sendOtp ? checkOtpData() : checkMobileData();
        },
        child: isLoading
            ? Container(
                child: SpinKitRing(
                  color: Colors.white,
                  size: widthsize * 5 / 100,
                  lineWidth: 2,
                  duration: Duration(milliseconds: 1000),
                ),
              )
            : Text(
                sendOtp ? "Login" : "Get OTP",
                style: TextStyle(
                    fontSize: widthsize * 4 / 100, color: AppColors.white_text),
              ),
      ),
    );
  }
}
