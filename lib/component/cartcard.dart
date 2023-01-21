import 'package:flutter/material.dart';
import 'package:customer_app/config/colors.dart';
import 'package:customer_app/model/cartmodel.dart';
import 'package:optimized_cached_image/optimized_cached_image.dart';

class CartCard extends StatefulWidget {
  CartModel cartValue;
  Function onMinus;
  Function onPlus;

  CartCard(
      {required this.cartValue, required this.onMinus, required this.onPlus});

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  @override
  Widget build(BuildContext context) {
    var widthsize = MediaQuery.of(context).size.width;
    var heightsize = MediaQuery.of(context).size.height;
    var e = widget.cartValue;

    return Container(
      width: widthsize,
      padding: EdgeInsets.all(widthsize * 2 / 100),
      margin: EdgeInsets.only(
        top: widthsize * 2 / 100,
        left: widthsize * 2 / 100,
        right: widthsize * 2 / 100,
      ),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // product image
          Container(
            width: widthsize * 12 / 100,
            height: widthsize * 12 / 100,
            padding: EdgeInsets.all(widthsize * 1.5 / 100),
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius:
                    BorderRadius.all(Radius.circular(widthsize * 1 / 100)),
                border: Border.all(color: AppColors.disable)),
            child: OptimizedCacheImage(
              imageUrl: e.productImage.toString(),
              placeholder: (context, url) => Image.asset("assets/loader.png"),
              errorWidget: (context, url, error) =>
                  Image.asset("assets/loader.png"),
            ),
          ),

          // column (product details name & price)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // name of the product
              Container(
                  margin: EdgeInsets.only(left: widthsize * 3 / 100),
                  child: Text(
                    e.productName!,
                    style: TextStyle(
                        fontSize: widthsize * 3.5 / 100,
                        fontWeight: FontWeight.w600,
                        color: AppColors.disable),
                  )),

              // space between widgets
              SizedBox(height: 5),

              // price of the product
              Container(
                  margin: EdgeInsets.only(left: widthsize * 3 / 100),
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: widthsize * 3 / 100),
                        child: Text(
                          '\u{20B9}${e.productSellingPrice}',
                          style: TextStyle(
                              fontSize: widthsize * 4.5 / 100,
                              fontWeight: FontWeight.w700,
                              color: AppColors.black_text),
                        ),
                      ),
                      e.productSellingPrice! < e.productMrp!
                          ? Text(
                              '\u{20B9}${e.productMrp}',
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: widthsize * 3.5 / 100,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black_text_opacity),
                            )
                          : Container(),

                      // discount
                      e.productOffer == 1 && e.productOfferType == 0
                          ? Text(
                              '${e.productDiscount}% off',
                              style: TextStyle(
                                  fontSize: widthsize * 3 / 100,
                                  color: AppColors.green),
                            )
                          : Container(),
                    ],
                  )),
            ],
          ),

          // space between button
          new Spacer(),

          // + - button
          Container(
            width: widthsize * 18 / 100,
            height: heightsize * 3 / 100,
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.only(
                top: heightsize * 3 / 100, right: widthsize * 3 / 100),
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius:
                    BorderRadius.all(Radius.circular(widthsize * 1 / 100)),
                border: Border.all(color: AppColors.blue_opacity)),
            child: Row(
              children: [
                Container(
                  width: widthsize * 6 / 100,
                  height: heightsize * 3 / 100,
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(color: AppColors.blue_opacity))),
                  child: MaterialButton(
                    elevation: 0,
                    padding: EdgeInsets.all(0),
                    minWidth: widthsize * 7 / 100,
                    height: heightsize * 3 / 100,
                    onPressed: () => {
                      if (e.productQuantity == 1)
                        {widget.onMinus(e, "remove")}
                      else
                        {widget.onMinus(e, "minus")}
                    },
                    child: Text(
                      "-",
                      style: TextStyle(
                          fontSize: widthsize * 5 / 100,
                          color: AppColors.blue,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Container(
                  width: widthsize * 5.5 / 100,
                  height: heightsize * 3 / 100,
                  child: Center(
                    child: Text(
                      e.productQuantity.toString(),
                      style: TextStyle(
                          fontSize: widthsize * 4 / 100,
                          color: AppColors.black_text,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Container(
                  width: widthsize * 6 / 100,
                  decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(color: AppColors.blue_opacity))),
                  child: MaterialButton(
                    elevation: 0,
                    padding: EdgeInsets.all(0),
                    minWidth: widthsize * 7 / 100,
                    height: heightsize * 3 / 100,
                    onPressed: () => {
                      {widget.onPlus(e, "plus")}
                    },
                    child: Text(
                      "+",
                      style: TextStyle(
                          fontSize: widthsize * 5 / 100,
                          color: AppColors.blue,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
