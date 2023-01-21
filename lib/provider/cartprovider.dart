import 'dart:convert';
import 'package:customer_app/services/customer/customerapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:customer_app/model/cartmodel.dart';
import 'package:customer_app/utils/localstorage.dart';

final cartProvider = ChangeNotifierProvider((ref) => CartProvider());

class CartProvider extends ChangeNotifier {
  List<CartModel> carts = [];
  double totalMrpAmount = 0.0;
  double totalSellingAmount = 0.0;

  // update cart data
  updateCartData() async {
    carts.clear();
    var cartData = await LocalStorage.getLocalStorage('cart');
    if (cartData != null) {
      var decode = jsonDecode(cartData);
      for (var i = 0; i < decode.length; i++) {
        carts.add(CartModel.fromJson(decode[i]));
      }
    }
    iterateThroughCart();
  }

  // update cart data action
  updateCartDataAction(index, action, mobile, shopId) async {
    var e = carts[index];

    // plus action
    if (action == 'plus') {
      e.productQuantity = e.productQuantity! + 1;
    }

    // minus action
    else if (action == 'minus') {
      e.productQuantity = e.productQuantity! - 1;
    }

    // remove action
    else if (action == "remove") {
      carts.removeAt(index);
    }

    iterateThroughCart();
    await updateCartDB(e, action, mobile, shopId);
    await LocalStorage.setLocalStorage('cart', jsonEncode(carts));
  }

  // iterate through cart
  iterateThroughCart() {
    double mrp = 0.0;
    double sa = 0.0;

    carts.forEach((e) {
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

    totalMrpAmount = mrp;
    totalSellingAmount = sa;
    notifyListeners();
  }

  // update cart in db action
  updateCartDB(CartModel e, type, mobile, shopId) async {
    // payload
    var payload = {
      "mobile": mobile,
      "shop_id": shopId,
      "product_barcode": e.productBarcode,
      "product_quantity": e.productQuantity,
    };

    // if type is remove
    if (type == 'remove') {
      payload = {...payload, "mode": "remove"};
    }

    // if type is not remove
    else {
      payload = {...payload, "mode": "update"};
    }

    await CustomerAPI.updateCart(payload);
  }
}
