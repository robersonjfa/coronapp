import 'dart:convert';

import 'package:coronapp/models/news.dart';
import 'package:coronapp/models/symptom.dart';
import 'package:coronapp/models/user.dart';
import 'package:coronapp/utils/date_utils.dart';
import 'package:coronapp/widgets/circlecheckbox.dart';
import 'package:coronapp/widgets/imagecheckbox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    this.getData();
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
          Expanded(
              child: ListView.builder(
              itemCount: symptoms == null ? 0 : symptoms.length,
              itemBuilder: (BuildContext context, int index) {
              return new ImageCheckBox(
                value: checks[index],
                onChanged: (bool val) {
                  setState(() {
                   if (val) total += symptoms[index].weight; // solução com variável
                   else  total -= symptoms[index].weight;
                   checks[index] = val; // solução então com list/vetor
                  });
                },
                checkDescription: '${symptoms[index].name}',
            );
          })),
          RaisedButton(child: Text('Testar'), onPressed: null,)
      ]);
      break;
      case 2: return Container(height: 500, color: Colors.yellow); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bytes = base64.decode(widget.user.photo);
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
              currentAccountPicture: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.transparent,
                backgroundImage: MemoryImage(bytes),
                //AssetImage('assets/images/splash.png'),
              ),
            ),
            ListTile(
              title: Text('Item de menu 1'),
              subtitle: Text('Subitem de menu 1'),
              leading: Icon(Icons.stars),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                debugPrint('Clicou no menu 1');
              }
            ),
            ListTile(
                title: Text('Item de menu 2'),
                subtitle: Text('Subitem de menu 2'),
                leading: Icon(Icons.account_circle),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  debugPrint('Clicou no menu 2');
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

