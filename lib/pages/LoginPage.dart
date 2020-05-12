import 'package:coronapp/helpers/database_helper.dart';
import 'package:coronapp/models/user.dart';
import 'package:coronapp/pages/HomePage.dart';
import 'package:coronapp/pages/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:internationalization/internationalization.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Login();
  }
}

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextStyle style = TextStyle(fontSize: 20); // estilo geral
  // a ideia hoje é usar o conceito de formulário do flutter - widget form
  String _usuario = "";
  String _senha = "";
  final frmLoginKey = new GlobalKey<FormState>(); // serve como identificador do formulário
  var db = DatabaseHelper();

  void _validarLogin() async {
    // capturando o estado atual do formulário
    final form = frmLoginKey.currentState;

    if (form.validate()) {
      form.save();

      User user = await db.validateLogin(_usuario, _senha);

      // validando usuário e senha
      if (user != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => HomePage(user: user)));
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Erro Login"),
              content: Text("Usuário e/ou senha inválidos!"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))
              )
            );
          }
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // campo usuario
    final usuarioField = TextFormField(
      style: style,
      onSaved: (valor) => _usuario = valor,
      validator: (valor) {
        return valor.length < 15 ? "Usuário deve ter no mínimo 15 caracteres!" : null;
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: Strings.of(context).valueOf("wg_email"),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32))
      ),
    );

    final senhaField = TextFormField(
      obscureText: true,
      style: style,
      onSaved: (valor) => _senha = valor,
      validator: (valor) {
        return valor.length < 6 ? Strings.of(context).valueOf("msg_password") : null;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: Strings.of(context).valueOf("wg_password"),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32))
      ),
    );

    // TODO: Melhorar visualmente os TextFields e o RaisedButton
    // TODO: Resolver o overflow de tela
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
       child: Container(
         height: MediaQuery.of(context).size.height,
         color: Colors.greenAccent,
         child: Padding(
          padding: const EdgeInsets.all(36),
          child: Form(
            key: frmLoginKey,
            child: Column (
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 155,
                child: Image.asset('assets/images/splash.png')
              ),
              SizedBox(height: 45,),
              usuarioField,
              SizedBox(height: 25,),
              senhaField,
              SizedBox(height: 35,),
              RaisedButton(
                color: Colors.blue,
                elevation: 5.0,
                child: Text(Strings.of(context).valueOf("wg_login"), style: style),
                onPressed: _validarLogin
              ),
              SizedBox(height: 15,),
              FlatButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => RegisterForm()
                ),
                child: Text(Strings.of(context).valueOf("wg_register"),
                    style: TextStyle(fontSize: 25, color: Colors.orange)
                )
              )
            ],
          )
         )
       )
      )
    )));
    // TODO: Corrigir problema da faixa branca ao final da tela(toda tela com cor padrão)
  }
}