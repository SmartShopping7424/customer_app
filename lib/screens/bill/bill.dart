import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:customer_app/component/billcard.dart';
import 'package:customer_app/config/colors.dart';
import 'package:customer_app/screens/app.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../component/billpayment.dart';
import '../../config/setting.dart';
import '../../provider/rootprovider.dart';
import '../../utils/localstorage.dart';
import '../../utils/toaster.dart';

final base_url = AppSettings.base_url;

class Bill extends ConsumerStatefulWidget {
  const Bill({Key? key}) : super(key: key);

  @override
  ConsumerState<Bill> createState() => _BillState();
}

class _BillState extends ConsumerState<Bill> {
  RootModel? readProvider;
  var billId = "";
  var client;
  var streamResponse;

  // update data
  updateData() {
    setState(() {
      billId = readProvider!.billProviderRead.billId;
    });
    checkOrderStatus();
  }

  // check order status done
  Future<dynamic> checkOrderStatus() async {
    try {
      var token = await LocalStorage.getLocalStorage('token');
      client = http.Client();
      Map<String, String> qParams = {
        'order_id': billId,
      };
      var headers = {
        "Authorization": 'Bearer ' + token,
        'Content-Type': 'application/json; charset=UTF-8',
      };
      final url = Uri.parse(base_url + "/customer/order_status")
          .replace(queryParameters: qParams);
      final req = http.Request('GET', url);
      req.headers.addAll(headers);
      final res = await client.send(req);
      streamResponse = res.stream.toStringStream().listen((value) {
        var data = jsonDecode(value);
        if (data['verified'] == 1) {
          readProvider!.billProviderRead.clearBillData();
          Toaster.toastMessage("Verified successful.", context);
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (context) => App(4)), (_) => false);
        }
      });
    } catch (e) {
      print('Something went wrong while fetching order status ::: ${e}');
    }
  }

  @override
  void initState() {
    setState(() {
      readProvider = ref.read(rootProvider).AllProvider();
    });
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
    RootModel watchProvider = ref.watch(rootProvider).AllProvider();

    return WillPopScope(
      onWillPop: () async => false,
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
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  margin: EdgeInsets.only(bottom: heightsize * 2 / 100),
                  decoration: BoxDecoration(color: AppColors.blue, boxShadow: [
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
                          "Order Details",
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
                        // bill card
                        Container(
                            child: Column(
                          children:
                              watchProvider.billProviderWatch.bills.map((e) {
                            return BillCard(billValue: e);
                          }).toList(),
                        )),

                        // payment details
                        BillPayment(
                            widthsize: widthsize,
                            heightsize: heightsize,
                            watchProvider: watchProvider),

                        // qr code
                        Container(
                          margin: EdgeInsets.only(
                            top: heightsize * 5 / 100,
                          ),
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    bottom: heightsize * 1 / 100),
                                child: Text(
                                  "Please show the below qr code to the security guard",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: widthsize * 3 / 100,
                                      color: AppColors.black_text),
                                ),
                              ),
                              QrImage(
                                data: billId,
                                version: QrVersions.auto,
                                size: widthsize * 40 / 100,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
