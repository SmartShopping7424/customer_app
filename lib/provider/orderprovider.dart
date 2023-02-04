import 'package:customer_app/model/ordermodal.dart';
import 'package:customer_app/services/customer/customerapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final orderProvider = ChangeNotifierProvider((ref) => OrderProvider());

class OrderProvider extends ChangeNotifier {
  List<OrderModal> orders = [];

  // update order data
  updateOrderData({required String mobile, int? page}) async {
    if (page == null) {
      orders.clear();
    }
    var res = await CustomerAPI.getOrder(mobile);
    if (res['code'] == 200) {
      var orderData = res['data'];
      for (var i = 0; i < orderData.length; i++) {
        orders.add(OrderModal.fromJson(orderData[i]));
      }
    }
    notifyListeners();
  }

  // clear order data
  clearOrderData() {
    orders.clear();
    return;
  }
}
