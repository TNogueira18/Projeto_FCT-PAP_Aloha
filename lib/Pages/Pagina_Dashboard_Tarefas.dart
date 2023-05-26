import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:main/Pages/Pagina_Login.dart';

class Pagina_Dashboard extends StatefulWidget {
  const Pagina_Dashboard({super.key});

  @override
  State<Pagina_Dashboard> createState() => _PaginaDasboardState();
}



class _PaginaDasboardState extends State<Pagina_Dashboard> {

  final _formkey = GlobalKey<FormState>();
  List<Widget> _Lista_Tarefas = [];
  ScrollController _scrollController = ScrollController();

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
        centerTitle: true,
        backgroundColor: Color(
            0xFF2c55ca
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            setState(() {
              Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => const Pagina_Login()));
            });
          },
        ),
      ),
      body: ListView(
        children: [
          Container(
            child: RawScrollbar(
              thickness: 5,
              thumbColor: Colors.indigo,
              radius: Radius.circular(15),
              child: SingleChildScrollView(
                controller: _scrollController,
                  child: Column(
                    children: _Lista_Tarefas,
                  ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget containerWidget = Padding(
      padding: EdgeInsets.all(
        15
      ),
    child: Container(
      height: 150,
      color: Colors.blue,
    ),
  );

  getTarefas() async {

    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    int? _ID_User = _sharedPreferences.getInt('id_user');
    String? _token = _sharedPreferences.getString('login_token');
    String _url = 'https://demo.spot4all.com/all-tasks-per-user/$_ID_User';
    Map <String, String> _headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization':'Bearer $_token',
    };


    try {
      final response = await http.get(Uri.parse(_url), headers: _headers);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        print(responseData[0].title);
      } else {
        print('Failed to fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch data: $e');
    }
  }

}