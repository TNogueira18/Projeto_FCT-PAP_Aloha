import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:main/Pages/Pagina_Login.dart';

class Pagina_Dashboard extends StatefulWidget {
  const Pagina_Dashboard({Key? key}) : super(key: key);

  @override
  State<Pagina_Dashboard> createState() => _PaginaDasboardState();
}

class _PaginaDasboardState extends State<Pagina_Dashboard> {
  final _formkey = GlobalKey<FormState>();
  //ScrollController _scrollController = ScrollController();
  List<Widget> _Lista_Widgets = [];

  @override
  void initState() {
    super.initState();
    _initializeListaWidgets();
  }

  Future<void> _initializeListaWidgets() async {
    List<Widget> listaWidgets = await getTarefas();
    setState(() {
      _Lista_Widgets = listaWidgets;
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
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            setState(() {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Pagina_Login()));
            });
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

  Future<List<Widget>> getTarefas() async{
    List<Widget> _Lista_Widget_Tarefas = [];
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    String? _token = _sharedPreferences.getString('login_token');
    int? _id = _sharedPreferences.getInt('id_user');

    try {
      String _url = 'https://demo.spot4all.com/all-tasks-per-user/$_id';
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
              Widget containerWidget = Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  height: 200,
                  color: Color(0xFF2c55ca),
                  child: Text(''),
                ),
              );
              _Lista_Widget_Tarefas.add(containerWidget);
            }
          };
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
}
