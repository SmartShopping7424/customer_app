import 'package:customer_app/component/ordercard.dart';
import 'package:customer_app/provider/rootprovider.dart';
import 'package:customer_app/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../component/emptydata.dart';
import '../../config/colors.dart';

class MyOrder extends ConsumerStatefulWidget {
  const MyOrder({Key? key}) : super(key: key);

  @override
  ConsumerState<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends ConsumerState<MyOrder> {
  RootModel? readProvider;
  var render = false;

  // get order data
  getOrderData() async {
    await readProvider!.orderProviderRead.updateOrderData(
        mobile: readProvider!.customerProviderRead.customerdata.mobile!);
    await Delay(1000);
    setState(() {
      render = true;
    });
  }

  @override
  void initState() {
    setState(() {
      readProvider = ref.read(rootProvider).AllProvider();
    });
    getOrderData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var widthsize = MediaQuery.of(context).size.width;
    var heightsize = MediaQuery.of(context).size.height;
    var watchProvider = ref.watch(rootProvider).AllProvider();

    return Scaffold(
      body: Container(
        color: AppColors.white,
        child: Column(
          children: [
            //  header
            Helper.headerWithLeftIcon(
                widthsize, heightsize, context, "My Orders"),

            // rest
            render
                ? watchProvider.orderProviderWatch.orders.length > 0
                    ? Expanded(
                        flex: 1,
                        child: SingleChildScrollView(
                          padding:
                              EdgeInsets.only(bottom: heightsize * 2 / 100),
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: watchProvider.orderProviderWatch.orders
                                .map((e) {
                              return OrderCard(orderValue: e);
                            }).toList(),
                          ),
                        ),
                      )
                    : Flexible(child: EmptyData("", "", () => null))
                : Helper.contentLoader(context),
          ],
        ),
      ),
    );
  }
}
