import 'dart:convert';
import 'package:customer_app/utils/helper.dart';
import 'package:customer_app/utils/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../services/customer/customerapi.dart';
import '../services/product/productapi.dart';
import 'localstorage.dart';

class Barcode {
  // scan barcode
  static scanBarcodeAndFetchProduct(context, shop_id, mobile) async {
    var barcode;

    // barcode scanner
    try {
      barcode = await FlutterBarcodeScanner.scanBarcode(
          "#FFFFFF", "Cancel", false, ScanMode.DEFAULT);
    } on PlatformException {
      barcode = "-1";
    }

    if (barcode != "-1") {
      // start fullscreen loader
      Helper.fullScreenLoader(context);

      // initialize payload
      var payload = {"shop_id": shop_id, "product_barcode": barcode};

      // call the api
      var res = await ProductAPI.scanProductData(payload);

      // if api response code is 200
      if (res['code'] == 200) {
        var cartData = [];
        var previousCartData = await LocalStorage.getLocalStorage('cart');
        if (previousCartData != null) {
          var decode = jsonDecode(previousCartData);
          for (var i = 0; i < decode.length; i++) {
            cartData.add(decode[i]);
          }
        }
        var element = {...res['data'], "product_quantity": 1};
        cartData.add(element);
        cartData =
            await Helper.makeUniqueArrayOfObject(cartData, 'product_barcode');
        await LocalStorage.setLocalStorage('cart', jsonEncode(cartData));
        var cartPayload = {
          "mobile": mobile,
          "shop_id": shop_id,
          "product_barcode": barcode,
          "product_quantity": 1,
          "mode": "update"
        };
        await CustomerAPI.updateCart(cartPayload);
        Navigator.pop(context);
        Toaster.toastMessage("Item added to the cart.", context);
      }
      // if api response code is not 200
      else {
        Navigator.pop(context);
        Toaster.toastMessage(
            res['message'].length > 0
                ? res['message']
                : "Something went wrong, Please try again later.",
            context);
      }
    }
  }
}
