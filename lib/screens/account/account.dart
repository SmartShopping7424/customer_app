import 'package:customer_app/utils/localstorage.dart';
import 'package:customer_app/utils/toaster.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:customer_app/screens/faq/faq.dart';
import 'package:customer_app/screens/profile/profile.dart';
import 'package:customer_app/screens/support/support.dart';
import '../../config/colors.dart';
import '../../provider/rootprovider.dart';
import '../../utils/helper.dart';
import '../app.dart';
import '../myorder/myorder.dart';

// create account button model
class AccountButtonModel {
  int? id;
  String? title;
  Widget? icon;

  AccountButtonModel({this.id, this.title, this.icon});
}

// create account button model objects
List<AccountButtonModel> accountButtons = [
  AccountButtonModel(
    id: 1,
    title: "My orders",
    icon: Icon(
      Icons.shopping_bag,
      size: 22,
      color: AppColors.black_text,
    ),
  ),
  AccountButtonModel(
    id: 2,
    title: "FAQ",
    icon: Icon(
      Icons.question_answer,
      size: 22,
      color: AppColors.black_text,
    ),
  ),
  AccountButtonModel(
    id: 3,
    title: "Support",
    icon: Icon(
      Icons.contact_support,
      size: 22,
      color: AppColors.black_text,
    ),
  ),
  AccountButtonModel(
    id: 4,
    title: "Logout",
    icon: Icon(
      Icons.logout,
      size: 22,
      color: AppColors.black_text,
    ),
  ),
];

class Account extends ConsumerStatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  ConsumerState<Account> createState() => _AccountState();
}

class _AccountState extends ConsumerState<Account> {
  RootModel? readProvider;

  // on logout
  onLogout() async {
    Navigator.pop(context);
    Helper.fullScreenLoader(context);
    await LocalStorage.setLocalStorage("route_name", "intro");
    await LocalStorage.clearAllLocalStorage();
    await Delay(1000);
    Toaster.toastMessage("Logout successful.", context);
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => App(2)), (_) => false);
  }

  // on button click function
  onButtonClick(e, width) async {
    // my orders
    if (e.id == 1) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyOrder()));
    }
    // faq
    else if (e.id == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => FAQ()));
    }
    // support
    else if (e.id == 3) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Support()));
    }
    // logout
    else if (e.id == 4) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Container(
              width: width * 80 / 100,
              child: Text(
                'Logout',
                style: TextStyle(
                    fontSize: width * 4 / 100,
                    color: AppColors.black_text,
                    fontWeight: FontWeight.w600),
              )),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(
                fontSize: width * 3.5 / 100, color: AppColors.black_text),
          ),
          actions: <Widget>[
            // no button
            Container(
              width: width * 15 / 100,
              child: MaterialButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "No",
                  style: TextStyle(
                      fontSize: width * 3 / 100, color: AppColors.blue),
                ),
              ),
            ),

            // yes button
            Container(
              width: width * 15 / 100,
              child: MaterialButton(
                onPressed: () => onLogout(),
                child: Text(
                  "Yes",
                  style: TextStyle(
                      fontSize: width * 3 / 100, color: AppColors.blue),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    setState(() {
      readProvider = ref.read(rootProvider).AllProvider();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var widthsize = MediaQuery.of(context).size.width;
    var heightsize = MediaQuery.of(context).size.height;
    RootModel watchProvider = ref.watch(rootProvider).AllProvider();

    return Scaffold(
      body: Container(
        width: widthsize,
        height: heightsize,
        child: Column(
          children: [
            // header
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
              ),
              width: widthsize,
              decoration: BoxDecoration(color: AppColors.white, boxShadow: [
                BoxShadow(
                  offset: Offset(1, 1),
                  blurRadius: 4,
                  color: AppColors.shadow,
                ),
              ]),
              child: Row(
                children: [
                  // profile avatar circle
                  Container(
                    margin: EdgeInsets.all(widthsize * 3 / 100),
                    padding: EdgeInsets.all(widthsize * 3 / 100),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.blue,
                    ),
                    child: watchProvider
                                .customerProviderWatch.customerdata.gender ==
                            ''
                        ? Text(
                            "HU",
                            style: TextStyle(
                                fontSize: widthsize * 11 / 100,
                                color: AppColors.white_text),
                          )
                        : Image(
                            image: AssetImage(watchProvider
                                        .customerProviderWatch
                                        .customerdata
                                        .gender ==
                                    'male'
                                ? 'assets/male.png'
                                : 'assets/female.png'),
                            width: widthsize * 12 / 100,
                          ),
                  ),

                  // user name text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child: Center(
                              child: Text(
                        watchProvider.customerProviderWatch.customerdata.name ==
                                ''
                            ? "Hi, User"
                            : 'Hi, ' +
                                (watchProvider.customerProviderWatch
                                            .customerdata.name!.length >
                                        15
                                    ? watchProvider.customerProviderWatch
                                            .customerdata.name!
                                            .substring(0, 14) +
                                        "..."
                                    : watchProvider.customerProviderWatch
                                        .customerdata.name!),
                        style: TextStyle(
                            fontSize: widthsize * 6 / 100,
                            color: AppColors.black_text,
                            fontWeight: FontWeight.w600),
                      ))),
                      Container(
                          child: Center(
                              child: Text(
                        watchProvider.customerProviderWatch.customerdata
                                    .mobile ==
                                ''
                            ? "+91-1234567890"
                            : '+91-' +
                                watchProvider
                                    .customerProviderWatch.customerdata.mobile!,
                        style: TextStyle(
                          fontSize: widthsize * 4 / 100,
                          color: AppColors.black_text,
                        ),
                      ))),
                    ],
                  ),

                  new Spacer(),

                  // edit icon
                  Container(
                    clipBehavior: Clip.hardEdge,
                    height: widthsize * 10 / 100,
                    width: widthsize * 10 / 100,
                    margin: EdgeInsets.only(right: widthsize * 3 / 100),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.all(
                          Radius.circular(widthsize * 20 / 100)),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(1, 1),
                          blurRadius: 4,
                          color: AppColors.shadow,
                        ),
                      ],
                    ),
                    child: MaterialButton(
                      padding: EdgeInsets.all(0),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Profile()));
                      },
                      child: Icon(
                        Icons.edit,
                        color: AppColors.black_text,
                        size: widthsize * 3.5 / 100,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // list of buttons in accounts screen
            Column(
              children: accountButtons.map((e) {
                return Container(
                  clipBehavior: Clip.hardEdge,
                  margin: EdgeInsets.only(
                    top: e.id == 1 ? widthsize * 6 / 100 : widthsize * 4 / 100,
                    left: widthsize * 3 / 100,
                    right: widthsize * 3 / 100,
                  ),
                  width: widthsize,
                  height: heightsize * 5 / 100,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius:
                        BorderRadius.all(Radius.circular(widthsize * 2 / 100)),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(1, 1),
                        blurRadius: 4,
                        color: AppColors.shadow,
                      ),
                    ],
                  ),
                  child: MaterialButton(
                    elevation: 0,
                    height: heightsize * 5 / 100,
                    padding: EdgeInsets.all(widthsize * 2 / 100),
                    onPressed: () => onButtonClick(e, widthsize),
                    child: Row(
                      children: [
                        e.icon!,
                        Container(
                          margin: EdgeInsets.only(left: widthsize * 3 / 100),
                          child: Text(
                            e.title!,
                            style: TextStyle(
                                fontSize: widthsize * 3.8 / 100,
                                fontWeight: FontWeight.w500,
                                color: AppColors.black_text),
                          ),
                        ),
                        new Spacer(),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: widthsize * 2.5 / 100,
                          color: AppColors.black_text,
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
