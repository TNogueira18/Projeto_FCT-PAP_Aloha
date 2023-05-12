import 'dart:async';
import 'dart:convert';

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
                        GetTarefas();
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


ListTarefas() async{

}


GetTarefas() async {

  SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
  int? _ID_User = _sharedPreferences.getInt('ID_User');

  var response = await http.get(
    Uri.parse(
      'https://demo.spot4all.com//all-tasks-per-user/$_ID_User',
    )
  );

  Map<String, dynamic> responseData = jsonDecode(response.body);

  final _length = responseData.length;

  for (var counter = 0; counter < _length; counter++){
    print(responseData[counter]['title']);
  }

}

