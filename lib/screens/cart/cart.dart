import 'package:customer_app/component/cartcard.dart';
import 'package:customer_app/component/emptydata.dart';
import 'package:customer_app/component/selectpaymentoption.dart';
import 'package:customer_app/config/colors.dart';
import 'package:customer_app/provider/rootprovider.dart';
import 'package:customer_app/screens/payatcounter/payatcounter.dart';
import 'package:customer_app/screens/payment/payment.dart';
import 'package:customer_app/utils/barcode.dart';
import 'package:customer_app/utils/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/customer/customerapi.dart';
import '../../utils/helper.dart';
import '../../utils/localstorage.dart';

class Cart extends ConsumerStatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  ConsumerState<Cart> createState() => _CartState();
}

class _CartState extends ConsumerState<Cart> {
  RootModel? readProvider;
  var mobile = '';
  var shopId = '';
  bool insideShop = false;
  Helper helper = new Helper();

  // scan product
  scanProduct() async {
    if (insideShop) {
      await Barcode.scanBarcodeAndFetchProduct(context, shopId, mobile);
      await readProvider!.cartProviderRead.updateCartData();
    } else {
      Toaster.toastMessage(
          "You are not in the shop. Please explore nearby shops.", context);
    }
  }

  // on minus
  onMinus(e, type) {
    // if type is minus
    if (type == "minus") {
      readProvider!.cartProviderRead.updateCartDataAction(
          readProvider!.cartProviderRead.carts.indexOf(e),
          type,
          mobile,
          shopId);
    }

    // if type is remove
    if (type == "remove") {
      readProvider!.cartProviderRead.updateCartDataAction(
          readProvider!.cartProviderRead.carts.indexOf(e),
          type,
          mobile,
          shopId);
    }
  }

  // on plus
  onPlus(e, type) {
    readProvider!.cartProviderRead.updateCartDataAction(
        readProvider!.cartProviderRead.carts.indexOf(e), type, mobile, shopId);
  }

  // on checkout
  onCheckout() {
    Helper.showPaymentOptionAlert(
        context,
        SelectPaymentOptions(
          onPayAtCounter: () => payAtCounter(),
          onPayOnline: () => payOnline(),
        ));
  }

  // update state
  updateState() {
    setState(() {
      mobile = readProvider!.customerProviderRead.customerdata.mobile!;
      shopId = readProvider!.shopProviderRead.shops[0].shopId!;
      insideShop = readProvider!.shopProviderRead.insideShop;
    });
  }

  // show payment options
  payAtCounter() async {
    Navigator.pop(context);
    Helper.fullScreenLoader(context);

    // define payload
    var payload = {
      "mobile": mobile,
      "shop_id": shopId,
      "amount": readProvider!.cartProviderRead.totalSellingAmount
    };

    // call the api
    var res = await CustomerAPI.createPayAtCounter(payload);
    if (res['code'] == 200) {
      LocalStorage.setLocalStorage("payment_id", res['data']['payment_id']);
      LocalStorage.setLocalStorage(
          "payment_amount", readProvider!.cartProviderRead.totalSellingAmount.toString());
      await Delay(2000);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => PayAtCounterScreen()));
    } else {
      Toaster.toastMessage(res['message'], context);
      Navigator.pop(context);
    }
  }

  // pay online
  payOnline() {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context) => Payment()));
  }

  @override
  void initState() {
    setState(() {
      readProvider = ref.read(rootProvider).AllProvider();
    });
    updateState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var widthsize = MediaQuery.of(context).size.width;
    var heightsize = MediaQuery.of(context).size.height;
    RootModel watchProvider = ref.watch(rootProvider).AllProvider();

    return Scaffold(
        body: Container(
            width: widthsize,
            height: heightsize,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header container
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
                          "My Cart",
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
                watchProvider.cartProviderWatch.carts.length > 0
                    ? Expanded(
                        flex: 1,
                        child: SingleChildScrollView(
                          padding:
                              EdgeInsets.only(bottom: heightsize * 5 / 100),
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children:
                                watchProvider.cartProviderWatch.carts.map((e) {
                              return CartCard(
                                  cartValue: e,
                                  onMinus: onMinus,
                                  onPlus: onPlus);
                            }).toList(),
                          ),
                        ),
                      )
                    : Flexible(
                        child: EmptyData("Your cart is empty", "Scan Product",
                            () => {scanProduct()}),
                      ),

                // bottom checkout button container
                watchProvider.cartProviderWatch.totalSellingAmount > 0
                    ? Container(
                        height: heightsize * 5 / 100,
                        clipBehavior: Clip.hardEdge,
                        margin: EdgeInsets.only(
                            left: widthsize * 3 / 100,
                            right: widthsize * 3 / 100,
                            bottom: heightsize * 2 / 100),
                        decoration: BoxDecoration(
                            color: AppColors.blue,
                            borderRadius: BorderRadius.all(
                                Radius.circular(widthsize * 2 / 100))),
                        child: Row(
                          children: [
                            // scan more container
                            Container(
                              height: heightsize * 5 / 100,
                              child: MaterialButton(
                                elevation: 0,
                                color: AppColors.green,
                                padding: EdgeInsets.all(widthsize * 2 / 100),
                                onPressed: () => {scanProduct()},
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.qr_code,
                                      size: widthsize * 3.5 / 100,
                                      color: AppColors.white_text,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 10),
                                      child: Text(
                                        "Scan More",
                                        style: TextStyle(
                                            fontSize: widthsize * 3.5 / 100,
                                            color: AppColors.white_text,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // checkout detail container
                            Container(
                              width: widthsize * 70 / 100,
                              height: heightsize * 5 / 100,
                              child: MaterialButton(
                                elevation: 0,
                                padding: EdgeInsets.all(widthsize * 2.5 / 100),
                                onPressed: () {
                                  onCheckout();
                                },
                                child: Row(
                                  children: [
                                    // counts of items
                                    Container(
                                      child: Text(
                                        '${watchProvider.cartProviderWatch.carts.length} items',
                                        style: TextStyle(
                                          fontSize: widthsize * 3 / 100,
                                          color: AppColors.white_text,
                                        ),
                                      ),
                                    ),

                                    // total price
                                    Container(
                                        margin: EdgeInsets.only(
                                            left: widthsize * 3 / 100),
                                        child: Text(
                                          '\u{20B9}${watchProvider.cartProviderWatch.totalSellingAmount.toStringAsFixed(2)}',
                                          style: TextStyle(
                                              fontSize: widthsize * 5 / 100,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.white_text),
                                        )),

                                    // discounted price
                                    watchProvider.cartProviderWatch
                                                .totalSellingAmount <
                                            watchProvider.cartProviderWatch
                                                .totalMrpAmount
                                        ? Container(
                                            margin: EdgeInsets.only(
                                                left: widthsize * 2 / 100),
                                            child: Text(
                                              '\u{20B9}${watchProvider.cartProviderWatch.totalMrpAmount.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                  fontSize: widthsize * 4 / 100,
                                                  fontWeight: FontWeight.w600,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  color: AppColors
                                                      .white_text_opacity),
                                            ))
                                        : Container(),

                                    // space
                                    new Spacer(),

                                    // checkout
                                    Container(
                                      margin: EdgeInsets.only(
                                          right: widthsize * 2 / 100),
                                      child: Text(
                                        "Checkout",
                                        style: TextStyle(
                                            fontSize: widthsize * 3.5 / 100,
                                            color: AppColors.white_text,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: widthsize * 3.5 / 100,
                                      color: AppColors.white_text,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container()
              ],
            )));
  }
}
