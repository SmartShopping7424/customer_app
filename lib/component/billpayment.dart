import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../provider/rootprovider.dart';

class BillPayment extends StatelessWidget {
  const BillPayment({
    Key? key,
    required this.widthsize,
    required this.heightsize,
    required this.watchProvider,
  }) : super(key: key);

  final double widthsize;
  final double heightsize;
  final RootModel watchProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(widthsize * 2 / 100),
      margin: EdgeInsets.only(
        top: widthsize * 2 / 100,
        left: widthsize * 2 / 100,
        right: widthsize * 2 / 100,
      ),
      child: Column(
        children: [
          Container(
            width: widthsize,
            padding: EdgeInsets.only(bottom: heightsize * 1 / 100),
            margin: EdgeInsets.only(bottom: heightsize * 1 / 100),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.disable, width: 0.5),
              ),
            ),
            child: Text(
              "Payment Details",
              style: TextStyle(
                  fontSize: widthsize * 4 / 100,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black_text),
            ),
          ),

          // mrp
          Row(
            children: [
              Container(
                  child: Text(
                "Product Price",
                style: TextStyle(
                    fontSize: widthsize * 3.2 / 100,
                    color: AppColors.black_text_opacity),
              )),
              new Spacer(),
              Container(
                child: Text(
                  watchProvider.billProviderWatch.billMrpAmount.toString(),
                  style: TextStyle(
                      fontSize: widthsize * 3.2 / 100,
                      color: AppColors.black_text_opacity),
                ),
              ),
            ],
          ),

          // discount
          Row(
            children: [
              Container(
                  child: Text(
                "Product Discount",
                style: TextStyle(
                    fontSize: widthsize * 3.2 / 100,
                    color: AppColors.black_text_opacity),
              )),
              new Spacer(),
              Container(
                child: Text(
                  "- " +
                      (watchProvider.billProviderWatch.billMrpAmount -
                              watchProvider.billProviderWatch.billSellingAmount)
                          .toString(),
                  style: TextStyle(
                      fontSize: widthsize * 3.2 / 100,
                      color: AppColors.blue_opacity),
                ),
              ),
            ],
          ),

          // total
          Row(
            children: [
              Container(
                  child: Text(
                "Total",
                style: TextStyle(
                    fontSize: widthsize * 3.2 / 100,
                    color: AppColors.black_text_opacity),
              )),
              new Spacer(),
              Container(
                child: Text(
                  watchProvider.billProviderWatch.billSellingAmount.toString(),
                  style: TextStyle(
                      fontSize: widthsize * 3.2 / 100,
                      color: AppColors.black_text_opacity),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
