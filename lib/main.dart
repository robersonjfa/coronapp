import 'package:coronapp/pages/HomePage.dart';
import 'package:coronapp/pages/LoginPage.dart';
import 'package:coronapp/pages/SplashPage.dart';
import 'package:flutter/material.dart';

void main() => runApp(CoronApp());

class CoronApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CoronApp',
      theme: ThemeData(
        primarySwatch: Colors.green
      ),
      home: SplashPage(),
      routes: <String, WidgetBuilder> {
        '/LoginPage': (BuildContext context) => LoginPage(),
        '/HomePage': (BuildContext context) => HomePage()
      },
    );
  }
}