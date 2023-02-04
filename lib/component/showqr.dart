import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:customer_app/config/colors.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../config/setting.dart';
import '../provider/rootprovider.dart';
import '../utils/localstorage.dart';
import '../utils/toaster.dart';

final base_url = AppSettings.base_url;

class ShowQr extends ConsumerStatefulWidget {
  var billId;
  Function onDone;

  ShowQr({required this.billId, required this.onDone});

  @override
  ConsumerState<ShowQr> createState() => _ShowQrState();
}

class _ShowQrState extends ConsumerState<ShowQr> {
  RootModel? readProvider;
  var client;
  var streamResponse;

  // check order status done
  Future<dynamic> checkOrderStatus() async {
    try {
      var token = await LocalStorage.getLocalStorage('token');
      client = http.Client();
      Map<String, String> qParams = {
        'order_id': widget.billId,
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
          widget.onDone();
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
    checkOrderStatus();
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

    return Container(
      width: widthsize,
      height: heightsize,
      color: AppColors.back_drop,
      child: Center(
          child: Container(
        width: widthsize * 80 / 100,
        height: heightsize * 30 / 100,
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius:
                BorderRadius.all(Radius.circular(widthsize * 1 / 100))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                margin: EdgeInsets.only(bottom: heightsize * 2 / 100),
                child: Text(
                  "Please show the below qr code to the security guard",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: widthsize * 3 / 100,
                      color: AppColors.black_text),
                )),
            QrImage(
              data: widget.billId,
              version: QrVersions.auto,
              size: widthsize * 35 / 100,
            ),
          ],
        ),
      )),
    );
  }
}
