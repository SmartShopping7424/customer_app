import 'package:customer_app/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../component/emptydata.dart';

class FAQ extends ConsumerStatefulWidget {
  const FAQ({Key? key}) : super(key: key);

  @override
  ConsumerState<FAQ> createState() => _FAQState();
}

class _FAQState extends ConsumerState<FAQ> {
  @override
  Widget build(BuildContext context) {
    var widthsize = MediaQuery.of(context).size.width;
    var heightsize = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        child: Column(
          children: [
            //  header
            Helper.headerWithLeftIcon(widthsize, heightsize, context, "FAQ"),
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
