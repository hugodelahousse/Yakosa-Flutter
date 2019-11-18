import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:yakosa/components/login_page/slide_item.dart';

class LoginSlider extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginSliderState();
  }
}

class LoginSliderState extends State<LoginSlider> {
  int _currentSlide = 0;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      CarouselSlider(
        height: 160,
        enlargeCenterPage: true,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 4),
        enableInfiniteScroll: true,
        pauseAutoPlayOnTouch: Duration(seconds: 2),
        items: <Widget>[
          SlideItem("Fill your shopping list",
              "Add your all your products preferences within the app in a few touches"),
          SlideItem("Find near promotions",
              "Your nearly grocery shops will list every promotions related to your shopping list"),
          SlideItem("Follow the guide",
              "YAKOSA provides you with an intelligent shops itinerary for the cheapest basket")
        ],
        onPageChanged: (index) {
          setState(() {
            _currentSlide = index;
          });
        },
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [0, 1, 2].map((i) {
          return Builder(builder: (BuildContext context) {
            return Container(
              width: 15.0,
              height: 15.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentSlide == i
                      ? Color.fromRGBO(255, 255, 255, 1)
                      : Color.fromRGBO(0, 0, 0, 0.8)),
            );
          });
        }).toList(),
      ),
    ]);
  }
}
