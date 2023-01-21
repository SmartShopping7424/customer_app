import 'package:customer_app/component/emptydata.dart';
import 'package:customer_app/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyOrder extends ConsumerStatefulWidget {
  const MyOrder({Key? key}) : super(key: key);

  @override
  ConsumerState<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends ConsumerState<MyOrder> {
  @override
  Widget build(BuildContext context) {
    var widthsize = MediaQuery.of(context).size.width;
    var heightsize = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        child: Column(
          children: [
            //  header
            Helper.headerWithLeftIcon(
                widthsize, heightsize, context, "My Orders"),
            // rest
            Container(
              width: widthsize,
              height: heightsize * 88 / 100,
              child: Center(child: EmptyData("", "", () => null)),
            )
          ],
        ),
      ),
    );
  }
}
