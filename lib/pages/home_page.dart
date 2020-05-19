import 'dart:convert';
import 'dart:io';
import 'dart:io' show Platform;

import 'package:coronapp/models/news.dart';
import 'package:coronapp/models/symptom.dart';
import 'package:coronapp/models/user.dart';
import 'package:coronapp/utils/date_utils.dart';
import 'package:coronapp/widgets/circle_checkbox.dart';
import 'package:coronapp/widgets/image_checkbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:shared_preferences_settings/shared_preferences_settings.dart';

class HomePage extends StatefulWidget {
  final User user;
  static final from = DateUtils.dateToString(DateTime.now());
  static final to = DateUtils.dateToString(DateTime.now());
  final newsUrl = "http://newsapi.org/v2/everything?q=coronavirus&language=pt&from=$from&to=$to&apiKey=6c0eff9c37884451993fcf212aebb7e7";

  HomePage({Key key, this.user}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  bool _check = false;
  int total = 0;
  List<bool> checks;

  var newsData;
  List articles;
  List<News> news;
  var refreshNews = GlobalKey<RefreshIndicatorState>();
  List<Symptom> symptoms;


  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  getLocation() async {
    Location location = new Location();

    // verifica se o serviço está ativo
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // verificação da permissão
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
  }

  Future<String> getData() async {
    refreshNews.currentState?.show(atTop: false); // mostra só quando fizer o swipe

    var response = await http.get(
      Uri.encodeFull(widget.newsUrl),
      headers: {
        "Accept": "application/json"
      }
    );

    var symptomsAsset = await DefaultAssetBundle.of(context).loadString("assets/data/symptoms.json");
    var symptomsList = json.decode(symptomsAsset) as List; // cria uma lista dos sintomas

    this.setState(() {
      // decodifica o json retornado pela requisição http
      newsData = jsonDecode(response.body);
      articles = newsData["articles"] as List;
      news = articles.map<News>((json) => News.fromJson(json)).toList(); // retorna as notícias
      symptoms = symptomsList.map<Symptom>((json) => Symptom.fromJson(json)).toList(); // retorna os sintomas
      checks = new List<bool>.generate(symptoms.length, (int index) => false);
    });
    return "OK";
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 100)).then((_) {
      this.getData();
    });
    getLocation();
  }

  // retorna o body conforme o item de tela clicado
  Widget _getBody() {
    switch (_index) {
      case 0: return RefreshIndicator(
          key: refreshNews,
          child: ListView.builder(
          itemCount: news == null ? 0 : news.length,
          itemBuilder: (BuildContext context, int index) {
            return new Card(
              child: Text(
                  '${news[index].title}')
            );
          }),
        onRefresh: getData,
      );
      case 1: return Column(children: <Widget>[
          Text('Teste Rápido de Sintomas'),
          // TODO: usar a latitude e longitude para dizer o nome da cidade
          Text('Localização: ${_locationData.latitude} / ${_locationData.longitude}'),
          Expanded(
              child: ListView.builder(
              itemCount: symptoms == null ? 0 : symptoms.length,
              itemBuilder: (BuildContext context, int index) {
              return new ImageCheckBox(
                value: _check,
                onChanged: (bool val) {
                  setState(() {
                    if (val) total += symptoms[index].weight;
                    else total -= symptoms[index].weight;
                  });
                },
                checkDescription: '${symptoms[index].name}',
            );
          })),
          RaisedButton(
            child: Text('Testar'),
            onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Resultado do Teste'),
                    content: LinearProgressIndicator(value: total.toDouble() / 100,
                      valueColor: total > 50 ?
                    AlwaysStoppedAnimation(Colors.red) :
                    AlwaysStoppedAnimation(Colors.green),),
                    //Text('Resultado: $total', style: TextStyle(fontSize: 40, color: Colors.orange),),
                    actions: <Widget>[
                      new FlatButton(
                        child: Text('Fechar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }
                      )
                    ],
                  );
                }
            );
          },)
      ]);
      break;
      case 2: return Container(height: 500, color: Colors.yellow); break;
    }
  }

  @override
  Widget build(BuildContext context) {

    var bytes = null;
    if (widget.user.photo != null)
      bytes = base64.decode(widget.user.photo);

    return Scaffold(
      appBar: AppBar(
        title: Text('CoronApp')
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(widget.user.name),
              accountEmail: Text(widget.user.email),
              currentAccountPicture: Settings().onBoolChanged(
                settingKey: 'opc_show_photo',
                defaultValue: true,
                childBuilder: (BuildContext context, bool value){
                  return value ? CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.transparent,
                    backgroundImage: bytes != null ? MemoryImage(bytes) : AssetImage('assets/images/nophoto.png'),
                    //AssetImage('assets/images/splash.png'),
                  ) : Text('');
                },)
            ),
            ListTile(
              title: Text('Configuração'),
              leading: Icon(Icons.settings),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.of(context).pushNamed('/SettingsPage');
              }
            ),
            ListTile(
                title: Text('Sair'),
                leading: Icon(Icons.close),
                onTap: () {
                  SystemNavigator.pop();
                  // só executa se a plataforma for android
                  if (Platform.isAndroid) exit(0);
                }),
          ],
        )
      ),
      body: _getBody(), // aciona o método que retorna o widget body
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) => setState(() {
          _index = index;
          debugPrint('$_index');
        }),
        backgroundColor: Colors.lime,
        currentIndex: _index,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.new_releases),
            title: Text('Notícias')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility),
            title: Text('Teste Rápido')
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_late),
            title: Text('Sobre')
          ),
        ]
      ),
    );
  }
}

