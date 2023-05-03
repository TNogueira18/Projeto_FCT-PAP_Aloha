import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:main/Pages/Pagina_Dashboard_Tarefas.dart';
import 'package:shared_preferences/shared_preferences.dart';


// Declarar um album
class Album {
  final int id;
  final String title;

  const Album({required this.id, required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      title: json['title'],
    );
  }
}


// Declarar a Página do login
class Pagina_Login extends StatefulWidget {
  const Pagina_Login({Key? key}) : super(key: key);

  @override
  State<Pagina_Login> createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<Pagina_Login> {

  // Declaração de variáveis
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _verPassword = false;

  @override
  Widget build(BuildContext context) {

    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: _height,
        width: _width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color(0xFF1D3B8C),
                  Color(0xFF000000),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight
            )
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                      'lib/Imagens/logoS4A.png',
                    width: (_width*3)/2,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      label: Text('e-mail'),
                      hintText: 'nom@gmail.com',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    validator: (email) {
                      if (email == null || email.isEmpty) {
                        return 'Introduza o seu e-mail';
                      }
                      return null;
                    }, //Verificar se o email é válido
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: !_verPassword,
                    decoration: InputDecoration(
                      label: Text('password'),
                      hintText: 'Introduza a sua palavra-passe',
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        icon: Icon(_verPassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined),
                        onPressed: () {
                          setState(() {
                            _verPassword = !_verPassword;
                          }); //Colocar o butão para visualizar a palavra-passe
                        },
                      ),
                    ),
                    validator: (password) {
                      if (password == null || password.isEmpty) {
                        return 'Introduza a sua palavra-passe';
                     } else if (password.length <= 6) {
                        return 'Introduza uma palavra-passe válida';
                      } // Validar a palavra passe
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(
                          0xFF4bae50
                      ), // Background color
                    ),
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        EfetuarLogin(); //Efetuar o login
                      }
                    },
                    child: Text(
                      'Aceder',
                      style: TextStyle(
                        color: Colors.white
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  EfetuarLogin() async {

    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance(); //Ativar a library sharedPreferences

     var response = await http.post(
       Uri.parse('https://demo.spot4all.com/login'),
       headers: <String, String>{
         'Content-Type': 'application/json; charset=UTF-8',
       },
       body: jsonEncode(<String, String>{
         'email': _emailController.text,
         'password': _passwordController.text,
       }),
     ); // Executar a pesquisa do login do utilizador na API

    Map<String, dynamic> responseData = jsonDecode(response.body); //Retirar o texto da resposta da API para uma variavel

    if(responseData['token'] != null){
      String? _token = responseData['token']; //Retirar o token para uma variavel para que possa ser utilizado no login
      _sharedPreferences.setString('login_token', _token!); //Colocar o token para que o utilizador não tenha que estar sempre a efetuar o login na app
      _sharedPreferences.setInt('login_token_expiration', DateTime.now().millisecondsSinceEpoch + (5 * 60 * 1000)); // Colocar o tempo que o token irá estar ativo por, o tempo pode ser alterado se modificar o primeiro valor pela quantidade de minutos desejado, de momento está preparado para durar 5 minutos
      Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => const Pagina_Dashboard()));
    }else{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Email ou Password incorreto!'),
            actions: <Widget>[
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}