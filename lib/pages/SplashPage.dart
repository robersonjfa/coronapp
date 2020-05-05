import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
with SingleTickerProviderStateMixin {

  final Tween<double> turnsTween = Tween<double>(
    begin: 1,
    end: 10
  );

  // nós vamos utilizar um controller de animação
  AnimationController _controller;

  // método para chamar a tela de Login
  void navegarTelaLogin() {
    Navigator.pushReplacementNamed(context, '/LoginPage');
  }

  iniciarSplash() async {
    var _duracao = Duration(seconds: 5);
    _controller.forward(); // direção do giro
    return new Timer(_duracao, navegarTelaLogin);
  }

  @override
  void initState() {
    super.initState();
    // criar o objeto do controlador de animação
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5)
    );

    iniciarSplash();
  }

  @override
  Widget build(BuildContext context) {
    // colocar a tela de splash em tela cheia(fullscreen
    SystemChrome.setEnabledSystemUIOverlays([]);

    return Container(
        color: Colors.greenAccent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // adiciona o widget RotationTransition
            RotationTransition (
                turns: turnsTween.animate(_controller),
                child: Image.asset('assets/images/splash.png')
            ),
            Text('Carregando ...', style: TextStyle(fontSize: 35))
          ],
        ));
  }
}
