import 'package:flutter/material.dart';

import './map_page.dart';
import './scanner_page.dart';

class HomePage extends StatefulWidget {
@override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    MapPage(),
    ScannerPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text('Map'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            title: Text('Scanner'),
          ),
          /*new BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('List'),
          ),*/
        ],
        
        fixedColor: Colors.deepPurpleAccent,
      ),
    );
  }

  void _onTabTapped(int index) {
    this.setState(() {
      _currentIndex = index;
    });
  }
}