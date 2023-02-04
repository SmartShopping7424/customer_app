import 'package:customer_app/config/colors.dart';
import 'package:customer_app/model/billmodel.dart';
import 'package:customer_app/provider/rootprovider.dart';
import 'package:customer_app/screens/bill/bill.dart';
import 'package:customer_app/utils/helper.dart';
import 'package:customer_app/utils/localstorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../services/customer/customerapi.dart';
import '../../utils/toaster.dart';

class Payment extends ConsumerStatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  ConsumerState<Payment> createState() => _PaymentState();
}

class _PaymentState extends ConsumerState<Payment> {
  RootModel? readProvider;
  var success = false;
  var mobile = "";
  var shopId = "";
  List<BillModel> orders = [];

  // update all data
  updateData() async {
    await readProvider!.billProviderRead.updateBillData();
    setState(() {
      mobile = readProvider!.customerProviderRead.customerdata.mobile!;
      shopId = readProvider!.shopProviderRead.shops[0].shopId!;
      orders = readProvider!.billProviderRead.bills;
    });
    createOrder();
  }

  // create customer order
  createOrder() async {
    // define payload
    var payload = {
      "mobile": mobile,
      "shop_id": shopId,
      "orders": orders,
      "total_item": orders.length,
      "total_mrp": readProvider!.billProviderRead.billMrpAmount,
      "total_amount": readProvider!.billProviderRead.billSellingAmount
    };

    // call the api
    var res = await CustomerAPI.createOrder(payload);
    if (res['code'] == 200) {
      LocalStorage.setLocalStorage("bill_id", res['data']['order_id']);
      await readProvider!.billProviderRead.updateBillId();
      await readProvider!.cartProviderRead.clearCartData();
      await Delay(2000);
      setState(() {
        success = true;
      });
      await Delay(1000);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Bill()));
    } else {
      Toaster.toastMessage(res['message'], context);
    }
  }

  @override
  void initState() {
    setState(() {
      readProvider = ref.read(rootProvider).AllProvider();
    });
    updateData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var widthsize = MediaQuery.of(context).size.width;
    var heightsize = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
            width: widthsize,
            height: heightsize,
            child: Column(
              children: [
                Container(
                  width: widthsize,
                  height: heightsize * 30 / 100,
                  margin: EdgeInsets.only(top: heightsize * 10 / 100),
                  child: success
                      ? Icon(
                          Icons.check_circle,
                          color: AppColors.blue,
                          size: widthsize * 50 / 100,
                        )
                      : Center(
                          child: SizedBox(
                            child: SpinKitRing(
                              color: AppColors.blue,
                              size: widthsize * 45 / 100,
                              lineWidth: 7,
                              duration: Duration(milliseconds: 1000),
                            ),
                          ),
                        ),
                ),
                Container(
                  child: Text(
                    success
                        ? "Payment successful"
                        : "Checking payment status\nPlease do not press back",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: widthsize * 4.5 / 100,
                        color: AppColors.black_text,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
