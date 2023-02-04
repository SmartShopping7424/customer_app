import 'package:customer_app/model/shopmodel.dart';
import 'package:flutter/material.dart';
import 'package:customer_app/config/colors.dart';

class ShopCard extends StatefulWidget {
  ShopModel shopValue;

  ShopCard({required this.shopValue});

  @override
  State<ShopCard> createState() => _ShopCardState();
}

class _ShopCardState extends State<ShopCard> {
  @override
  Widget build(BuildContext context) {
    var widthsize = MediaQuery.of(context).size.width;
    var heightsize = MediaQuery.of(context).size.height;
    var e = widget.shopValue;

    return Container(
      width: widthsize,
      padding: EdgeInsets.all(widthsize * 2 / 100),
      margin: EdgeInsets.all(widthsize * 2 / 100),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(Radius.circular(widthsize * 1 / 100)),
        boxShadow: [
          BoxShadow(
            offset: Offset(1, 1),
            blurRadius: 4,
            color: AppColors.shadow,
          ),
        ],
      ),
      child: Row(children: [
        // shop image
        Container(
          width: widthsize * 15 / 100,
          height: widthsize * 15 / 100,
          child: Image.asset("assets/shop.png", fit: BoxFit.scaleDown),
        ),

        // shop name
        Container(
            margin: EdgeInsets.only(left: widthsize * 3 / 100),
            child: Text(
              e.shopName!,
              style: TextStyle(
                  fontSize: widthsize * 3.5 / 100,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black_text),
            )),

        new Spacer(),

        // direction icon
        Container(
          child: Icon(
            Icons.directions,
            size: widthsize * 5 / 100,
            color: AppColors.blue,
          ),
        ),

        // shop distance
        Container(
            margin: EdgeInsets.only(
                right: widthsize * 3 / 100, left: widthsize * 2 / 100),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius:
                  BorderRadius.all(Radius.circular(widthsize * 1 / 100)),
            ),
            child: Text(
              '${e.distance! / 1000}  km',
              style: TextStyle(
                  fontSize: widthsize * 3.5 / 100,
                  color: AppColors.black_text_opacity,
                  fontWeight: FontWeight.w600),
            )),
      ]),
    );
  }
}
