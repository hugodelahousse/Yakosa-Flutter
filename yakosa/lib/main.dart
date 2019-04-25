import 'package:flutter/material.dart';

import './pages/login_page.dart';
import './pages/home_page.dart';

void main() => runApp(new MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => LoginPage(),
    '/home': (context) => HomePage(),
  },
));
