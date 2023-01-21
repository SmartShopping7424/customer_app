import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  RootModel(
      {required this.customerProviderRead,
      required this.customerProviderWatch,
      required this.shopProviderRead,
      required this.shopProviderWatch,
      required this.cartProviderRead,
      required this.cartProviderWatch});
}

final rootProvider =
    ChangeNotifierProvider((ref) => RootProvider(rootProviderRef: ref));

class RootProvider extends ChangeNotifier {
  ChangeNotifierProviderRef<RootProvider> rootProviderRef;

  RootProvider({required this.rootProviderRef});

  RootModel AllProvider() {
    CustomerProvider customerRead = rootProviderRef.read(customerProvider);
    CustomerProvider customerWatch = rootProviderRef.watch(customerProvider);
    ShopProvider shopRead = rootProviderRef.read(shopProvider);
    ShopProvider shopWatch = rootProviderRef.watch(shopProvider);
    CartProvider cartRead = rootProviderRef.read(cartProvider);
    CartProvider cartWatch = rootProviderRef.watch(cartProvider);

    // return the data
    return RootModel(
        customerProviderRead: customerRead,
        customerProviderWatch: customerWatch,
        shopProviderRead: shopRead,
        shopProviderWatch: shopWatch,
        cartProviderRead: cartRead,
        cartProviderWatch: cartWatch);
  }
}
