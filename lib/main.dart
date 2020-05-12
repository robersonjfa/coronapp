import 'package:coronapp/pages/HomePage.dart';
import 'package:coronapp/pages/LoginPage.dart';
import 'package:coronapp/pages/SplashPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:internationalization/internationalization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Internationalization.loadConfigurations();
  // estamos fixando a posição de todas as telas da aplicação
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_)
    {
      runApp(CoronApp());
    }
  );
}

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
      supportedLocales: suportedLocales,
      localizationsDelegates: [
        Internationalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
    );
  }
}
