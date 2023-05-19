import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Pagina_Dashboard extends StatefulWidget {
  const Pagina_Dashboard({super.key});

  @override
  State<Pagina_Dashboard> createState() => _PaginaDasboardState();
}

final _tamanho_Lista_Tarefas = [];

class _PaginaDasboardState extends State<Pagina_Dashboard> {

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tarefas',
          style: TextStyle(
              color: Colors.white
          ),
        ),
        backgroundColor: Color(
            0xFF2c55ca
        ),
        leading: Icon(
          Icons.menu,
        ),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Atrasadas',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  )
              )
          ),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Dia',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  )
              )
          ),
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Futuras',
                    style: TextStyle(
                        color: Colors.white
                    ),
                  )
              )
          ),
        ],
      ),
      body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        try {
                          getTarefas();
                        } catch(_){
                          print(
                            'error'
                          );
                        }
                      },
                    child: Text(
                      'Teste'
                    ),
                  )
                ],
              ),
            ),
          ),
      ),
    );
  }
}

Future getTarefas() async {

  SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
  int? _ID_User = _sharedPreferences.getInt('id_user');
  String? _token = _sharedPreferences.getString('login_token');
  String _url = 'https://demo.spot4all.com/all-tasks-per-user/$_ID_User/';
  Map <String, String> _headers = {
    'Content-Type': 'application/json; charset=utf-8',
    'Accept': 'application/json',
  'Authorization': 'Bearer $_token'
  };

  try {
    final response = await http.get(Uri.parse(_url), headers: _headers);
    print(response);
    print(response.headers['content-type']);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData;
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to fetch data: $e');
  }
}

