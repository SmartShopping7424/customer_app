import 'package:customer_app/model/ordermodal.dart';
import 'package:customer_app/utils/helper.dart';
import 'package:customer_app/utils/toaster.dart';
import 'package:flutter/material.dart';
import 'package:customer_app/config/colors.dart';

class OrderCard extends StatefulWidget {
  OrderModal orderValue;

  OrderCard({required this.orderValue});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    var widthsize = MediaQuery.of(context).size.width;
    var heightsize = MediaQuery.of(context).size.height;
    var e = widget.orderValue;

    return Container(
        width: widthsize,
        clipBehavior: Clip.hardEdge,
        margin: EdgeInsets.only(
            top: widthsize * 5 / 100,
            left: widthsize * 2 / 100,
            right: widthsize * 2 / 100),
        decoration: BoxDecoration(
          border: Border.all(
              color: AppColors.disable, width: widthsize * 0.1 / 100),
          borderRadius: BorderRadius.all(Radius.circular(widthsize * 1 / 100)),
        ),
        child: Column(
          children: [
            // top container
            Container(
              padding: EdgeInsets.all(widthsize * 3 / 100),
              decoration: BoxDecoration(
                color: AppColors.order_bg,
                borderRadius:
                    BorderRadius.all(Radius.circular(widthsize * 1 / 100)),
              ),
              child: Row(
                children: [
                  // order image
                  Container(
                    width: widthsize * 10 / 100,
                    height: widthsize * 10 / 100,
                    child: Image.asset(
                      "assets/order.png",
                      fit: BoxFit.scaleDown,
                    ),
                  ),

                  // order details
                  Container(
                    margin: EdgeInsets.only(left: widthsize * 3 / 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // order id
                        Container(
                            child: Text(
                          e.orderId!,
                          style: TextStyle(
                              fontSize: widthsize * 3 / 100,
                              color: AppColors.black_text),
                        )),

                        // order amount
                        Container(
                            child: Text(
                          "Total Amount   ₹ " + e.totalAmount.toString(),
                          style: TextStyle(
                              fontSize: widthsize * 2.5 / 100,
                              color: AppColors.black_text_opacity),
                        )),
                      ],
                    ),
                  ),

                  new Spacer(),

                  // date
                  Container(
                      child: Text(
                    Helper.dateConverter(e.createdAt!),
                    style: TextStyle(
                        fontSize: widthsize * 2.5 / 100,
                        color: AppColors.black_text_opacity),
                  )),
                ],
              ),
            ),

            // bottom container
            Container(
              padding: EdgeInsets.all(widthsize * 3 / 100),
              child: Row(
                children: [
                  // total items
                  Container(
                      margin: EdgeInsets.only(left: widthsize * 3 / 100),
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: widthsize * 1.5 / 100,
                            color: AppColors.black_text_opacity,
                          ),
                          new SizedBox(
                            width: widthsize * 1 / 100,
                          ),
                          Text(
                            e.totalItem.toString() + " Items",
                            style: TextStyle(
                                fontSize: widthsize * 2.5 / 100,
                                color: AppColors.black_text),
                          ),
                        ],
                      )),

                  // spacer
                  new Spacer(),

                  // view details button
                  Container(
                    height: heightsize * 2 / 100,
                    child: MaterialButton(
                      padding: EdgeInsets.all(0),
                      elevation: 0,
                      minWidth: 0,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onPressed: () {
                        Toaster.toastMessage("Under Development", context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(0),
                        child: Row(
                          children: [
                            Text(
                              "View Details",
                              style: TextStyle(
                                  fontSize: widthsize * 2.5 / 100,
                                  color: AppColors.blue),
                            ),
                            Icon(
                              Icons.arrow_right,
                              size: widthsize * 2.5 / 100,
                              color: AppColors.blue,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
