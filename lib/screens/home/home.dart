import 'package:customer_app/component/badgeicon.dart';
import 'package:customer_app/component/shopcard.dart';
import 'package:customer_app/config/colors.dart';
import 'package:customer_app/provider/rootprovider.dart';
import 'package:customer_app/screens/account/account.dart';
import 'package:customer_app/screens/cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/helper.dart';

class Homescreen extends ConsumerStatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  ConsumerState<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends ConsumerState<Homescreen> {
  int _selectedIndex = 0;
  RootModel? readProvider;

  // get bottom tab screen on the basis of index
  Widget getBottomTabScreens(int index) {
    switch (index) {
      case 0:
        return Home();

      case 1:
        return Cart();

      case 2:
        return Account();

      default:
        return Home();
    }
  }

  // on back press function
  Future<bool> _onBackPressed() async {
    if (_selectedIndex == 0) {
      return true;
    } else {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
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

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Center(
          child: getBottomTabScreens(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: widthsize * 6 / 100),
              label: 'Home',
            ),
            BottomNavigationBarItem(
                icon: BadgeIcon(
                  icon: Icon(Icons.shopping_cart, size: widthsize * 6 / 100),
                  badgeCount: watchProvider!.cartProviderWatch.carts.length,
                ),
                label: 'Cart'),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle, size: widthsize * 6 / 100),
              label: 'Account',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.blue,
          unselectedItemColor: AppColors.disable,
          unselectedFontSize: widthsize * 3 / 100,
          selectedFontSize: widthsize * 3 / 100,
          onTap: (index) => {
            setState(() {
              _selectedIndex = index;
            })
          },
        ),
      ),
    );
  }
}

// home widget
class Home extends ConsumerStatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  Helper helper = new Helper();
  RootModel? readProvider;

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

    return Container(
      width: widthsize,
      height: heightsize,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header
          Container(
            width: widthsize,
            height: heightsize * 10 / 100,
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: BoxDecoration(color: AppColors.blue, boxShadow: [
              BoxShadow(
                offset: Offset(1, 1),
                blurRadius: 4,
                color: AppColors.shadow,
              ),
            ]),
            child: Row(
              children: [
                Container(
                    margin: EdgeInsets.only(left: widthsize * 4 / 100),
                    child: Icon(
                      Icons.location_pin,
                      color: AppColors.white_text,
                    )),
                Container(
                  margin: EdgeInsets.only(left: widthsize * 2 / 100),
                  child: Text(
                    watchProvider!.shopProviderWatch.insideShop
                        ? watchProvider!.shopProviderWatch.shops[0].shopName!
                        : "Unnamed Road",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: widthsize * 5 / 100,
                        color: AppColors.white_text),
                  ),
                )
              ],
            ),
          ),

          // nearby shops title
          Container(
              margin: EdgeInsets.only(
                  top: widthsize * 3 / 100, left: widthsize * 3 / 100),
              child: Text(
                "Nearby Shops",
                style: TextStyle(
                    fontSize: widthsize * 4.5 / 100,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black_text),
              )),

          // shop details container
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: heightsize * 5 / 100),
              scrollDirection: Axis.vertical,
              child: Column(
                children: watchProvider!.shopProviderWatch.insideShop
                    ? watchProvider!.shopProviderWatch.shops.skip(1).map((e) {
                        return ShopCard(shopValue: e);
                      }).toList()
                    : watchProvider!.shopProviderWatch.shops.map((e) {
                        return ShopCard(shopValue: e);
                      }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
