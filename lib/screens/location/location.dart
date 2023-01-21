import 'dart:convert';
import '../app.dart';
import 'package:customer_app/provider/rootprovider.dart';
import 'package:customer_app/utils/getlocation.dart';
import 'package:customer_app/utils/localstorage.dart';
import 'package:customer_app/utils/toaster.dart';
import 'package:flutter/material.dart';
import 'package:customer_app/services/customer/customerapi.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:customer_app/config/colors.dart';
import 'package:customer_app/utils/helper.dart';
import '../../component/rippleanimation.dart';

class Location extends ConsumerStatefulWidget {
  const Location({Key? key}) : super(key: key);

  @override
  ConsumerState<Location> createState() => _LocationState();
}

class _LocationState extends ConsumerState<Location> {
  RootModel? readProvider;
  var shop_found = false;
  var mobile;
  var raduis;

  // fetch customer location
  fetchCustomerLocation() async {
    // update mobile and radius value
    setState(() {
      mobile = readProvider!.customerProviderRead.customerdata.mobile;
      raduis = readProvider!.shopProviderRead.radius;
    });

    try {
      var location = await Getlocation.getCurrentPosition(context);

      // define latitude and longitude
      double latitude = location.latitude;
      double longitude = location.longitude;

      // define payload
      var payload = {
        'latitude': latitude.toStringAsPrecision(6),
        'longitude': longitude.toStringAsPrecision(6)
      };

      // call the api
      var res = await CustomerAPI.fetchShop(payload);
      if (res['code'] == 200) {
        var allShops = res['data'];
        await LocalStorage.setLocalStorage('shops', jsonEncode(allShops));
        await readProvider!.shopProviderRead.updateAllShops();

        // if distance is less than defined radius
        if (allShops[0]['distance'] < raduis) {
          setState(() {
            shop_found = true;
          });
          await readProvider!.shopProviderRead.updateInsideShop();
          getCustomerCartData(mobile, allShops[0]['shop_id']);
        }

        // if distance is greater than defined radius
        else {
          getCustomerCartData(mobile, "");
        }
      } else {
        print('Error found in fetch shop api ::: ${res}');
        Toaster.toastMessage(
            "Something went wrong. Please try again later.", context);
        await Delay(1000);
        Helper.closeApp();
      }
    } catch (e) {
      print('Error found in fetch location function ::: ${e}');
      Toaster.toastMessage(
          "Something went wrong. Please try again later.", context);
      await Delay(1000);
      Helper.closeApp();
    }
  }

  // get customer cart data
  getCustomerCartData(mobile, shop_id) async {
    // call the api
    var res = await CustomerAPI.fetchCart(mobile, shop_id);
    if (res['code'] == 200) {
      var cartData = res['data'];
      cartData =
          await Helper.makeUniqueArrayOfObject(cartData, 'product_barcode');
      await LocalStorage.setLocalStorage('cart', jsonEncode(cartData));
      await readProvider!.cartProviderRead.updateCartData();
      await Delay(1000);
      // if customer not in the shop
      if (shop_id == "") {
        Toaster.toastMessage(
            "You are not in the shop. Please explore nearby shops.", context);
      }
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => App(4)), (_) => false);
    } else {
      print('Error found in fetch cart api ::: ${res}');
      Toaster.toastMessage(
          "Something went wrong. Please try again later.", context);
      await Delay(1000);
      Helper.closeApp();
    }
  }

  @override
  void initState() {
    setState(() {
      readProvider = ref.read(rootProvider).AllProvider();
    });
    fetchCustomerLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var widthsize = MediaQuery.of(context).size.width;
    var heightsize = MediaQuery.of(context).size.height;
    RootModel watchProvider = ref.watch(rootProvider).AllProvider();

    return Scaffold(
      body: shop_found
          ? Container(
              width: widthsize,
              height: heightsize,
              child: Column(
                children: [
                  // image
                  Container(
                    width: widthsize * 70 / 100,
                    height: widthsize * 70 / 100,
                    margin: EdgeInsets.only(top: heightsize * 15 / 100),
                    decoration: BoxDecoration(
                      image:
                          DecorationImage(image: AssetImage("assets/shop.png")),
                    ),
                  ),
                  Container(
                      width: widthsize * 70 / 100,
                      child: Text(
                        'Welcome\nto\n${watchProvider!.shopProviderWatch.shops[0].shopName}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: widthsize * 6 / 100,
                            color: AppColors.black_text,
                            fontWeight: FontWeight.w600),
                      )),
                ],
              ),
            )
          : Container(
              width: widthsize,
              height: heightsize,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RipplesAnimation(
                    child: Icon(
                      Icons.location_pin,
                      size: widthsize * 10 / 100,
                      color: AppColors.white,
                    ),
                    color: AppColors.blue_opacity,
                    size: widthsize * 20 / 100,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: heightsize * 2 / 100),
                    child: Text(
                      "Fetching Location...",
                      style: TextStyle(
                          fontSize: widthsize * 6 / 100,
                          color: AppColors.black_text,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              )),
    );
  }
}
