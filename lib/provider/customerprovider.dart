import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:customer_app/model/customermodel.dart';
import '../utils/localstorage.dart';

final customerProvider = ChangeNotifierProvider((ref) => CustomerProvider());

class CustomerProvider extends ChangeNotifier {
  CustomerModel customerdata = CustomerModel();

  // update customer data
  updateCustomerData() async {
    var data = await LocalStorage.getLocalStorage('customer');
    if (data != null) {
      customerdata = CustomerModel.fromJson(jsonDecode(data));
    }

    notifyListeners();
  }
}
