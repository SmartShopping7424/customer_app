import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:customer_app/config/colors.dart';
import '../../config/setting.dart';
import '../../provider/rootprovider.dart';
import '../../utils/localstorage.dart';
import '../../utils/toaster.dart';
import '../payment/payment.dart';

final base_url = AppSettings.base_url;

class PayAtCounterScreen extends ConsumerStatefulWidget {
  const PayAtCounterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PayAtCounterScreen> createState() => _PayAtCounterScreenState();
}

class _PayAtCounterScreenState extends ConsumerState<PayAtCounterScreen> {
  var paymentId;
  var amount;
  var client;
  var streamResponse;

  // update data
  updateData() async {
    var payment_id = await LocalStorage.getLocalStorage("payment_id");
    var payment_amount = await LocalStorage.getLocalStorage("payment_amount");
    setState(() {
      paymentId = payment_id;
      amount = payment_amount;
    });
    checkPayAtCounterStatus();
  }

  // check order status done
  Future<dynamic> checkPayAtCounterStatus() async {
    try {
      var token = await LocalStorage.getLocalStorage('token');
      client = http.Client();
      Map<String, String> qParams = {
        'payment_id': paymentId,
      };
      var headers = {
        "Authorization": 'Bearer ' + token,
        'Content-Type': 'application/json; charset=UTF-8',
      };
      final url = Uri.parse(base_url + "/customer/pay_at_counter")
          .replace(queryParameters: qParams);
      final req = http.Request('GET', url);
      req.headers.addAll(headers);
      final res = await client.send(req);
      streamResponse = res.stream.toStringStream().listen((value) {
        var data = jsonDecode(value);
        if (data['verified'] == 1) {
          LocalStorage.clearLocalStorage('payment_id');
          LocalStorage.clearLocalStorage('payment_amount');
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) => Payment()), (_) => false);
        }
      });
    } catch (e) {
      print(
          'Something went wrong while fetching pay at counter status ::: ${e}');
    }
  }

  // on back press function
  Future<bool> _onBackPressed() async {
    Toaster.toastMessage(
        "Please do not press back as we are checking payment status.", context);
    return false;
  }

  @override
  void initState() {
    updateData();
    super.initState();
  }

  @override
  void dispose() {
    if (streamResponse != null) streamResponse.cancel();
    if (client != null) client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var widthsize = MediaQuery.of(context).size.width;
    var heightsize = MediaQuery.of(context).size.height;

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          body: Container(
              width: widthsize,
              height: heightsize,
              child: Column(
                children: [
                  // header
                  Container(
                    width: widthsize,
                    height: heightsize * 10 / 100,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    margin: EdgeInsets.only(bottom: heightsize * 2 / 100),
                    decoration:
                        BoxDecoration(color: AppColors.blue, boxShadow: [
                      BoxShadow(
                        offset: Offset(1, 1),
                        blurRadius: 4,
                        color: AppColors.shadow,
                      ),
                    ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: widthsize * 4 / 100),
                          child: Text(
                            "Payment Details",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: widthsize * 5 / 100,
                                color: AppColors.white_text),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // rest container
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: heightsize * 5 / 100),
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          // image container
                          Container(
                            width: widthsize * 60 / 100,
                            height: widthsize * 60 / 100,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/payatcounter.png")),
                            ),
                          ),

                          // payment id container
                          Container(
                            child: Text(
                              paymentId.toString(),
                              style: TextStyle(
                                  fontSize: widthsize * 6 / 100,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black_text),
                            ),
                          ),

                          // info container
                          Container(
                            margin: EdgeInsets.only(top: heightsize * 2 / 100),
                            child: Text(
                              "Please pay the below amount at the counter",
                              style: TextStyle(
                                  fontSize: widthsize * 3.5 / 100,
                                  color: AppColors.black_text),
                            ),
                          ),

                          // amount container
                          Container(
                            width: widthsize * 20 / 100,
                            height: widthsize * 20 / 100,
                            margin: EdgeInsets.only(top: heightsize * 2 / 100),
                            decoration: BoxDecoration(
                                color: AppColors.white,
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 4,
                                    color: AppColors.shadow,
                                  ),
                                ],
                                borderRadius: BorderRadius.all(
                                    Radius.circular(widthsize * 10 / 100))),
                            alignment: Alignment.center,
                            child: Text(
                              "₹ " + amount.toString(),
                              style: TextStyle(
                                  fontSize: widthsize * 5 / 100,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.black_text),
                            ),
                          ),

                          // or text container
                          Container(
                            margin: EdgeInsets.only(top: heightsize * 2 / 100),
                            child: Text(
                              "OR",
                              style: TextStyle(
                                  fontSize: widthsize * 3.5 / 100,
                                  color: AppColors.black_text),
                            ),
                          ),

                          // pay online
                          Container(
                            margin: EdgeInsets.only(top: heightsize * 2 / 100),
                            child: MaterialButton(
                              onPressed: () => {Toaster.toastMessage("Under development", context)},
                              minWidth: 0,
                              padding: EdgeInsets.all(0),
                              child: Container(
                                width: widthsize * 30 / 100,
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(widthsize * 3 / 100),
                                decoration: BoxDecoration(
                                    color: AppColors.blue,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(widthsize * 2 / 100))),
                                child: Text(
                                  "Pay Online",
                                  style: TextStyle(
                                      fontSize: widthsize * 3.8 / 100,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ));
  }
}
