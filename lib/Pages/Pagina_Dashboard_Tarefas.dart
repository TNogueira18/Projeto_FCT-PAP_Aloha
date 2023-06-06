import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:main/Pages/Pagina_Login.dart';

class Pagina_Dashboard extends StatefulWidget {
  const Pagina_Dashboard({Key? key}) : super(key: key);

  @override
  State<Pagina_Dashboard> createState() => _PaginaDasboardState();
}

String _Path = 'Todas';

class Constants {
  static const String FirstItem = 'Todas';
  static const String SecondItem = 'Dia';
  static const String ThirdItem = 'Pendentes';
  static const String FourthItem = 'Futuras';
  static const String FifthItem = 'Logout';

  static const List<String> choices = <String>[
    FirstItem,
    SecondItem,
    ThirdItem,
    FourthItem,
    FifthItem,
  ];
}

class _PaginaDasboardState extends State<Pagina_Dashboard> {
  //final _formkey = GlobalKey<FormState>();
  List<Widget> _Lista_Widgets = [];
  List<Widget> _list_widgets = [];

  @override
  void initState() {
    super.initState();
    todasTarefas();
  }

  Future<void> _initializeListaWidgets() async {
        List<Widget> listaWidgets = await getTarefas(_Path);
        setState(() {
          _Lista_Widgets = listaWidgets;
    });
  }

  Future<void> _initializeListaWidgets_todas() async {
    List<Widget> listaWidgets = await getTarefas(_Path);
    setState(() {
      _list_widgets.addAll(listaWidgets);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tarefas',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF2c55ca),
        leading: PopupMenuButton<String>(
          icon: Icon(Icons.menu),
          onSelected: choiceAction,
          itemBuilder: (BuildContext context) {
            return Constants.choices.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(
                  choice,
                ),
              );
            }).toList();
          },
        ),
      ),
      body: ListView.builder(
        itemCount: _Lista_Widgets.length,
        itemBuilder: (context, index) {
          return _Lista_Widgets[index];
        },
      ),
    );
  }

  //Modificar função para funcionar por as 3 tipos de tarefas, futuras, pendentes e diárias

  Future<List<Widget>> getTarefas(String path) async {
    List<Widget> _Lista_Widget_Tarefas = [];
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    String? _token = _sharedPreferences.getString('login_token');
    int? _id = _sharedPreferences.getInt('id_user');

    var _BC = 5;

    if (path == 'todas-tarefas-pendentes') {
      _BC = 0xFFf2c4c4;
    } else if (path == 'todas-tarefas-dia') {
      _BC = 0xFFf5e8b3;
    } else if (path == 'todas-tarefas-futuras') {
      _BC = 0xFF9db5f6;
    } else {
      print('Error');
    }

    try {
      String _url = 'https://demo.spot4all.com/$path/$_id';
      Map<String, String> _headers = {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $_token',
      };
      try {
        final response = await http.get(Uri.parse(_url), headers: _headers);
        if (response.statusCode == 200) {
          List<dynamic> _Lista_Mapas = jsonDecode(response.body);
          for (int counter = 0; counter < _Lista_Mapas.length; counter++) {
            Map<String, dynamic> _Lista_Tarefas = _Lista_Mapas[counter];
            if (_Lista_Tarefas['status_tarefa'] == 1) {
              String _id_contactos = 'id:' +
                  _Lista_Tarefas['id'].toString() +
                  ' - ' +
                  _Lista_Tarefas['name'].toString() +
                  ' - (' +
                  _Lista_Tarefas['nickname'].toString() +
                  ')';
              String _title_status = _Lista_Tarefas['title'] +
                  ' - ' +
                  _Lista_Tarefas['status'].toString();
              String _subject = _Lista_Tarefas['subject'];
              String _description = _Lista_Tarefas['description'];
              String _dataend_assigned =
                  _Lista_Tarefas['data_evento_end'].toString() +
                      ' - ' +
                      _Lista_Tarefas['consultor'].toString();
              String _creator =
                  'Criado por: ' + _Lista_Tarefas['criador'].toString();
              Widget containerWidget = Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                    padding: EdgeInsets.all(20),
                    height: 250,
                    color: Color(_BC),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _id_contactos,
                              style: TextStyle(color: Colors.black, fontSize: 15),
                            ),
                            Text(
                              _title_status,
                              style: TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _subject,
                              style: TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            Text(
                              _description,
                              style: TextStyle(color: Colors.black, fontSize: 12),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _dataend_assigned,
                              style: TextStyle(color: Colors.black, fontSize: 15),
                            ),
                            Text(
                              _creator,
                              style: TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          ],
                        ),
                      ],
                    )),
              );
              _Lista_Widget_Tarefas.add(containerWidget);
            }
          }
          ;
        } else {
          print('Failed to fetch data: ${response.statusCode}');
        }
      } catch (e) {
        print('Failed to fetch data: $e');
      }
      return _Lista_Widget_Tarefas;
    } catch (e) {
      print('Failed to get data: $e');
      return _Lista_Widget_Tarefas;
    }
  }

  Future<void> todasTarefas() async {
    _list_widgets = [];
    int counter = 0;
    while (counter < 3) {
      if (counter == 0) {
        _Path = 'todas-tarefas-pendentes';
      } else if (counter == 1) {
        _Path = 'todas-tarefas-dia';
      } else if (counter == 2) {
        _Path = 'todas-tarefas-futuras';
      } else {
        break;
      }
      await _initializeListaWidgets_todas();
      counter+=1;
    }
    _Lista_Widgets = _list_widgets;
  }

  void choiceAction(String choice) {
    if (choice == Constants.FirstItem) {
      //todas
      todasTarefas();
    } else if (choice == Constants.SecondItem) {
      //dia
      _Path = 'todas-tarefas-dia';
      _initializeListaWidgets();
    } else if (choice == Constants.ThirdItem) {
      //pendentes
      _Path = 'todas-tarefas-pendentes';
      _initializeListaWidgets();
    } else if (choice == Constants.FourthItem) {
      //futuras
      _Path = 'todas-tarefas-futuras';
      _initializeListaWidgets();
    } else if (choice == Constants.FifthItem) {
      //logout
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const Pagina_Login()));
    }
  }
}
