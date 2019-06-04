import 'package:flutter/material.dart';
import 'package:yakosa/utils/size_config.dart';

//Screens
import 'package:yakosa/screens/settings_page.dart';
import 'package:yakosa/screens/shopping_lists.dart';

class Layout extends StatefulWidget {
@override
  State<StatefulWidget> createState() {
    return LayoutState();
  }
}

class LayoutState extends State<Layout> {
  final _screens = [
    {"page": ShoppingListsPage(), "icon": Icons.shopping_basket},
    {"page": SettingsPage(), "icon": Icons.settings},
  ];
  int _currentPage = 0;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Color(0xFFFFFFFF),
          body: _screens[_currentPage]["page"],
          bottomNavigationBar: Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFEEEEEE), width: 0.40)),
              ),
              height: 58,
              alignment: Alignment.center,
              child: BottomAppBar(
                elevation: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _screens.asMap().map((index, x) =>
                    MapEntry(index, IconButton(
                      color: _currentPage == index ? Colors.purple : Colors.black,
                      icon: Icon(x["icon"]),
                      onPressed: () {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                    ))
                  ).values.toList()
                ),
              ),
          )
        ),
      ),
    );
  }
}