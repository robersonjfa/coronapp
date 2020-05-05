import 'dart:convert';
import 'dart:io';

import 'package:coronapp/helpers/database_helper.dart';
import 'package:coronapp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  var db = DatabaseHelper();
  String _name = "";
  String _email = "";
  String _password = "";
  File _image;
  final frmRegisterKey =
  new GlobalKey<FormState>(); // serve como identificador do formulário

  void _registerUser() async {
    // capturando o estado atual do formulário
    final form = frmRegisterKey.currentState;

    if (form.validate()) {
      form.save();

      final bytes = await _image.readAsBytes();
      final photo = base64.encode(bytes);

      User user = User(null, _name, _email, _password, photo);
      // pq o erro? faltava o setter
      user.id = await db.saveUser(user);
      // validando usuário e senha
      if (user.id != null && user.id > 0) {
        Navigator.pop(context, true); // saindo da janela
      } else {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  title: Text("Erro de Registro"),
                  content: Text("Erro ao tentar registrar o usuário!"),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))));
            });
      }
    }
  }
  void _pickImage() async {
    final imageSource = await showDialog<ImageSource>(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text("Origem da Foto"),
              actions: <Widget>[
                MaterialButton(
                  child: Text("Câmera"),
                  onPressed: () => Navigator.pop(context, ImageSource.camera),
                ),
                MaterialButton(
                  child: Text("Galeria"),
                  onPressed: () => Navigator.pop(context, ImageSource.gallery),
                )
              ],
            )
    );

    if(imageSource != null) {
      final file = await ImagePicker.pickImage(source: imageSource);
      if(file != null) {
        setState(() => _image = file);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: frmRegisterKey,
        child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Registrar usuário",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.photo),
                            color: Color(0xFF4B9DFE),
                            padding: EdgeInsets.only(
                                left: 38, right: 38, top: 15, bottom: 15),
                            onPressed: _pickImage,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          _image == null
                              ? Text('Sem Foto!')
                              : Image.file(_image, height: 30, width: 30,),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            onSaved: (val) => _name = val,
                            decoration: InputDecoration(
                                labelText: "Nome", hasFloatingPlaceholder: true),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            onSaved: (val) => _email = val,
                            decoration: InputDecoration(
                                labelText: "E-mail", hasFloatingPlaceholder: true),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            obscureText: true,
                            onSaved: (val) => _password = val,
                            decoration: InputDecoration(
                                labelText: "Senha", hasFloatingPlaceholder: true),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "A senha deve conter no mínimo 6 caracteres!",
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Expanded(
                                child: Container(),
                              ),
                              FlatButton(
                                child: Text("Registrar"),
                                color: Color(0xFF4B9DFE),
                                textColor: Colors.white,
                                padding: EdgeInsets.only(
                                    left: 38, right: 38, top: 15, bottom: 15),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                onPressed: _registerUser,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }
}
