import 'package:customer_app/screens/location/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:customer_app/screens/splashscreen/splashscreen.dart';
import 'package:customer_app/screens/intro/intro.dart';
import 'package:customer_app/screens/login/login.dart';
import 'package:customer_app/screens/home/home.dart';

class App extends ConsumerStatefulWidget {
  int option;
  App(this.option);

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  // function for get screen
  Widget getScreens(int option) {
    switch (option) {
      case 0:
        return Splashscreen();

      case 1:
        return Intro();

      case 2:
        return Login();

      case 3:
        return Location();

      case 4:
        return Homescreen();

      default:
        return Splashscreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getScreens(widget.option),
    );
  }
}
