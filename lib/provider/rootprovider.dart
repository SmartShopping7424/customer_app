import 'package:customer_app/provider/orderprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'billprovider.dart';
import 'cartprovider.dart';
import 'customerprovider.dart';
import 'shopprovider.dart';

class RootModel {
  CustomerProvider customerProviderRead;
  CustomerProvider customerProviderWatch;
  ShopProvider shopProviderRead;
  ShopProvider shopProviderWatch;
  CartProvider cartProviderRead;
  CartProvider cartProviderWatch;
  BillProvider billProviderRead;
  BillProvider billProviderWatch;
  OrderProvider orderProviderRead;
  OrderProvider orderProviderWatch;

  RootModel({
    required this.customerProviderRead,
    required this.customerProviderWatch,
    required this.shopProviderRead,
    required this.shopProviderWatch,
    required this.cartProviderRead,
    required this.cartProviderWatch,
    required this.billProviderRead,
    required this.billProviderWatch,
    required this.orderProviderRead,
    required this.orderProviderWatch,
  });
}

final rootProvider =
    ChangeNotifierProvider((ref) => RootProvider(rootProviderRef: ref));

class RootProvider extends ChangeNotifier {
  ChangeNotifierProviderRef<RootProvider> rootProviderRef;

  RootProvider({required this.rootProviderRef});

  // get all providers
  RootModel AllProvider() {
    CustomerProvider customerRead = rootProviderRef.read(customerProvider);
    CustomerProvider customerWatch = rootProviderRef.watch(customerProvider);
    ShopProvider shopRead = rootProviderRef.read(shopProvider);
    ShopProvider shopWatch = rootProviderRef.watch(shopProvider);
    CartProvider cartRead = rootProviderRef.read(cartProvider);
    CartProvider cartWatch = rootProviderRef.watch(cartProvider);
    BillProvider billRead = rootProviderRef.read(billProvider);
    BillProvider billWrite = rootProviderRef.watch(billProvider);
    OrderProvider orderRead = rootProviderRef.read(orderProvider);
    OrderProvider orderWatch = rootProviderRef.watch(orderProvider);

    return RootModel(
        customerProviderRead: customerRead,
        customerProviderWatch: customerWatch,
        shopProviderRead: shopRead,
        shopProviderWatch: shopWatch,
        cartProviderRead: cartRead,
        cartProviderWatch: cartWatch,
        billProviderRead: billRead,
        billProviderWatch: billWrite,
        orderProviderRead: orderRead,
        orderProviderWatch: orderWatch);
  }

  // clear every modal on logout
  clearOnLogout() async {
    CustomerProvider customerRead = rootProviderRef.read(customerProvider);
    ShopProvider shopRead = rootProviderRef.read(shopProvider);
    CartProvider cartRead = rootProviderRef.read(cartProvider);
    BillProvider billRead = rootProviderRef.read(billProvider);
    OrderProvider orderRead = rootProviderRef.read(orderProvider);

    customerRead.clearCustomerData();
    shopRead.clearShopData();
    cartRead.clearCartData();
    billRead.clearBillData();
    orderRead.clearOrderData();

    return;
  }
}
