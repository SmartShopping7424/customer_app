import 'package:customer_app/model/billmodel.dart';
import 'package:flutter/material.dart';
import 'package:customer_app/config/colors.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class BillCard extends StatefulWidget {
  BillModel billValue;

  BillCard({required this.billValue});

  @override
  State<BillCard> createState() => _BillCardState();
}

class _BillCardState extends State<BillCard> {
  @override
  Widget build(BuildContext context) {
    var widthsize = MediaQuery.of(context).size.width;
    var heightsize = MediaQuery.of(context).size.height;
    var e = widget.billValue;

    return Container(
      width: widthsize,
      padding: EdgeInsets.all(widthsize * 2 / 100),
      margin: EdgeInsets.only(
        top: widthsize * 2 / 100,
        left: widthsize * 2 / 100,
        right: widthsize * 2 / 100,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.disable, width: 0.3),
        color: AppColors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(widthsize * 1 / 100),
        ),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        // product image
        Container(
          width: widthsize * 12 / 100,
          height: widthsize * 12 / 100,
          padding: EdgeInsets.all(widthsize * 1.5 / 100),
          decoration: BoxDecoration(
            color: AppColors.white,
          ),
          child: OptimizedCacheImage(
            imageUrl: e.productImage.toString(),
            placeholder: (context, url) => Image.asset("assets/loader.png"),
            errorWidget: (context, url, error) =>
                Image.asset("assets/loader.png"),
          ),
        ),

        // product name
        Container(
            margin: EdgeInsets.only(left: widthsize * 3 / 100),
            child: Text(
              e.productName!,
              style: TextStyle(
                  fontSize: widthsize * 3.5 / 100,
                  fontWeight: FontWeight.w600,
                  color: AppColors.disable),
            )),

        // new space
        new Spacer(),

        // product quantity
        Container(
            width: widthsize * 7 / 100,
            height: widthsize * 7 / 100,
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: widthsize * 2 / 100),
            decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.all(
                Radius.circular(widthsize * 1 / 100),
              ),
            ),
            child: Text(
              e.productQuantity.toString(),
              style: TextStyle(
                  fontSize: widthsize * 4 / 100,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white_text),
            )),

        // column (product details name & price)
      ]),
    );
  }
}
