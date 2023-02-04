import 'dart:convert';
import 'package:customer_app/model/billmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:customer_app/utils/localstorage.dart';

final billProvider = ChangeNotifierProvider((ref) => BillProvider());

class BillProvider extends ChangeNotifier {
  List<BillModel> bills = [];
  double billMrpAmount = 0.0;
  double billSellingAmount = 0.0;
  var billId = "";

  // update bill data
  updateBillData() async {
    bills.clear();
    var billData = await LocalStorage.getLocalStorage('cart');
    if (billData != null) {
      var decode = jsonDecode(billData);
      for (var i = 0; i < decode.length; i++) {
        bills.add(BillModel.fromJson(decode[i]));
      }
    }

    double mrp = 0.0;
    double sa = 0.0;

    bills.forEach((e) {
      // if there is offer available and offer type is pack
      if (e.productOffer == 1 && e.productOfferType == 1) {
        var divide = e.productQuantity! / e.productPackCount!;
        var mod = e.productQuantity! % e.productPackCount!;
        mrp += e.productQuantity! * e.productMrp!;
        sa += (divide.toInt()) * e.productPackPrice! +
            mod * e.productSellingPrice!;
      }

      // if there is offer available and offer type is discount
      else if (e.productOffer == 1 && e.productOfferType == 0) {
        mrp += e.productQuantity! * e.productMrp!;
        sa += e.productQuantity! * e.productMrp! -
            (e.productQuantity! *
                    e.productMrp! *
                    int.parse(e.productDiscount!)) /
                100;
      }

      // if there is no offer available
      else {
        mrp += e.productQuantity! * e.productMrp!;
        sa += e.productQuantity! * e.productSellingPrice!;
      }
    });

    billMrpAmount = mrp;
    billSellingAmount = sa;
    notifyListeners();
  }

  // update bill id
  updateBillId() async {
    var id = await LocalStorage.getLocalStorage("bill_id");
    if (id != null) {
      billId = id;
    } else {
      billId = "";
    }
    return;
  }

  // clear bill data
  clearBillData() {
    bills.clear();
    billMrpAmount = 0.0;
    billSellingAmount = 0.0;
    billId = "";
    LocalStorage.clearLocalStorage('bill_id');
    return;
  }
}
