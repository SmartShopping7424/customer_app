import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:customer_app/utils/helper.dart';
import 'package:customer_app/screens/app.dart';

import '../../utils/localstorage.dart';

final introSlider = [
  "Page 1",
  "Page 2",
  "Page 3",
  "Page 4",
];

class Intro extends ConsumerStatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  ConsumerState<Intro> createState() => _IntroState();
}

class _IntroState extends ConsumerState<Intro> {
  final CarouselController _controller = CarouselController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var widthsize = MediaQuery.of(context).size.width;
    var heightsize = MediaQuery.of(context).size.height;
    Helper helper = new Helper();

    return Container(
      height: heightsize,
      width: widthsize,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/intro.jpeg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: heightsize * 10 / 100,
          ),
          Container(
            child: CarouselSlider(
              carouselController: _controller,
              options: CarouselOptions(
                  height: heightsize * 40 / 100,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                  autoPlay: false,
                  onPageChanged: (index, reason) {
                    _currentIndex = index;
                    setState(() {});
                  },
                  enableInfiniteScroll: false),
              items: introSlider
                  .map((item) => Container(
                        child: ClipRRect(
                            child: Stack(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10),
                              height: heightsize,
                              width: widthsize,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Text(item),
                            )
                          ],
                        )),
                      ))
                  .toList(),
            ),
          ),
          Container(
            height: heightsize * 30 / 100,
            width: widthsize,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                color: Colors.greenAccent,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20.0))),
            child: Container(
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("hello"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Visibility(
                              maintainSize: true,
                              maintainAnimation: true,
                              maintainState: true,
                              visible: _currentIndex == 0 ? false : true,
                              child: Container(
                                clipBehavior: Clip.hardEdge,
                                height: widthsize * 10 / 100,
                                width: widthsize * 10 / 100,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(widthsize * 20 / 100))),
                                child: MaterialButton(
                                  padding: EdgeInsets.all(0),
                                  onPressed: () => _controller.previousPage(),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.blue,
                                    size: widthsize * 5 / 100,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: introSlider.map((e) {
                                var index = introSlider.indexOf(e);
                                return Container(
                                  clipBehavior: Clip.hardEdge,
                                  margin: EdgeInsets.only(left: 10),
                                  height: widthsize * 2 / 100,
                                  width: widthsize * 2 / 100,
                                  decoration: BoxDecoration(
                                      color: index == _currentIndex
                                          ? Colors.blue
                                          : Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              widthsize * 20 / 100))),
                                );
                              }).toList(),
                            ),
                            Container(
                              clipBehavior: Clip.hardEdge,
                              height: widthsize * 10 / 100,
                              width: widthsize * 10 / 100,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(widthsize * 20 / 100))),
                              child: MaterialButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () async {
                                  if (_currentIndex == introSlider.length - 1) {
                                    await LocalStorage.setLocalStorage(
                                        "route_name", "intro");
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => App(2)),
                                        (_) => false);
                                  } else {
                                    _controller.nextPage();
                                  }
                                },
                                child: Icon(
                                  _currentIndex == introSlider.length - 1
                                      ? Icons.check
                                      : Icons.arrow_forward,
                                  color: Colors.blue,
                                  size: widthsize * 5 / 100,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )))),
          ),
        ],
      ),
    );
  }
}
