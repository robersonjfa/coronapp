import 'package:coronapp/pages/home_page.dart';
import 'package:coronapp/pages/login_page.dart';
import 'package:coronapp/pages/settings_page.dart';
import 'package:flutter/material.dart';

final routes = {
  '/LoginPage': (BuildContext context) => LoginPage(),
  '/HomePage': (BuildContext context) => HomePage(),
  '/SettingsPage': (BuildContext context) => SettingsPage()
};