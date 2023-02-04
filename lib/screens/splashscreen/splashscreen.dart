import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:customer_app/provider/rootprovider.dart';
import 'package:customer_app/config/colors.dart';
import '../../utils/helper.dart';
import '../../utils/localstorage.dart';
import '../app.dart';

class Splashscreen extends ConsumerStatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  ConsumerState<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends ConsumerState<Splashscreen> {
  RootModel? readProvider;

  getRouteName() async {
    await readProvider!.customerProviderRead.updateCustomerData();
    await readProvider!.billProviderRead.updateBillId();
    var route_name = await LocalStorage.getLocalStorage("route_name");

    // if intro has been done
    if (route_name == "intro") {
      await Delay(1000);
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => App(2)), (_) => false);
    }

    // if login has been done
    else if (route_name == "login") {
      await Delay(1000);
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => App(3)), (_) => false);
    }

    // if nothing has been done
    else {
      await Delay(1000);
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => App(1)), (_) => false);
    }
  }

  @override
  void initState() {
    setState(() {
      readProvider = ref.read(rootProvider).AllProvider();
    });
    getRouteName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var widthsize = MediaQuery.of(context).size.width;
    var heightsize = MediaQuery.of(context).size.height;

    return Container(
      width: widthsize,
      height: heightsize,
      decoration: BoxDecoration(color: AppColors.blue),
      child: Center(
        child: Text(
          "This is splash screen",
          style: TextStyle(
              color: AppColors.white_text, fontSize: widthsize * 5 / 100),
        ),
      ),
    );
  }
}
