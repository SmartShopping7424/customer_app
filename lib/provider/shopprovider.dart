import 'dart:convert';
import 'package:customer_app/utils/localstorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:customer_app/model/shopmodel.dart';

final shopProvider = ChangeNotifierProvider((ref) => ShopProvider());

class ShopProvider extends ChangeNotifier {
  List<ShopModel> shops = [];
  int radius = 20;
  bool insideShop = false;

  // update all shops
  updateAllShops() async {
    var shopData = await LocalStorage.getLocalStorage('shops');
    if (shopData != null) {
      var decode = jsonDecode(shopData);
      for (var i = 0; i < decode.length; i++) {
        shops.add(ShopModel.fromJson(decode[i]));
      }
    }
    notifyListeners();
  }

  // update inside shop
  updateInsideShop() {
    insideShop = true;
    notifyListeners();
  }

  // clear shop data
  clearShopData() {
    shops.clear();
    radius = 20;
    insideShop = false;
    LocalStorage.clearLocalStorage('shops');
    return;
  }
}
