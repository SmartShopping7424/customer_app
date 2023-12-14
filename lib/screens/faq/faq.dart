import 'package:customer_app/config/colors.dart';
import 'package:customer_app/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:customer_app/config/faqData.dart';

class FAQ extends ConsumerStatefulWidget {
  const FAQ({Key? key}) : super(key: key);

  @override
  ConsumerState<FAQ> createState() => _FAQState();
}

class _FAQState extends ConsumerState<FAQ> {
  var selectedIndex = -1;

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
            Expanded(
              flex: 1,
              child: ListView.builder(
                padding: EdgeInsets.all(widthsize * 3 / 100),
                key: Key('selected $selectedIndex'),
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.only(
                        left: widthsize * 3 / 100, right: widthsize * 3 / 100),
                    margin: EdgeInsets.only(top: widthsize * 3 / 100),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.all(
                          Radius.circular(widthsize * 2 / 100)),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(1, 1),
                          blurRadius: 4,
                          color: AppColors.shadow,
                        ),
                      ],
                    ),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        key: Key(index.toString()),
                        tilePadding: EdgeInsets.all(0),
                        childrenPadding: EdgeInsets.all(0),
                        collapsedBackgroundColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        collapsedIconColor: AppColors.black_text,
                        collapsedTextColor: AppColors.black_text,
                        iconColor: AppColors.blue,
                        textColor: AppColors.blue,
                        initiallyExpanded: index == selectedIndex,
                        title: Container(
                            child: Text(
                                FaqData.data[index]['question'].toString())),
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            padding:
                                EdgeInsets.only(bottom: widthsize * 3 / 100),
                            child:
                                Text(FaqData.data[index]['answer'].toString()),
                          )
                        ],
                        onExpansionChanged: (isOpen) {
                          if (isOpen) {
                            setState(() {
                              selectedIndex = index;
                            });
                          }
                        },
                      ),
                    ),
                  );
                },
                itemCount: FaqData.data.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
