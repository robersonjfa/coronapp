import 'package:coronapp/pages/home_page.dart';
import 'package:coronapp/pages/login_page.dart';
import 'package:coronapp/pages/splash_page.dart';
import 'package:coronapp/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:internationalization/internationalization.dart';
import 'package:shared_preferences_settings/shared_preferences_settings.dart';

var _color;

void loadConfiguration() async {
  _color = await Settings().getString(
    'opc_primary_color',
    '0xff2196f3',
  );
  // carregar outras configurações - poderia ser usado um map
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Internationalization.loadConfigurations();
  loadConfiguration(); // carregar as configurações
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
        // primarySwatch:
        primaryColor: Color(int.parse(_color))
      ),
      home: SplashPage(),
      routes: routes,
      supportedLocales: suportedLocales,
      localizationsDelegates: [
        Internationalization.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
    );
  }
}
