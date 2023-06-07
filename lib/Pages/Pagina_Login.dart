import 'dart:async';
import 'dart:convert';
import "dart:io";

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:main/Pages/Pagina_Dashboard_Tarefas.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Declarar a Página do login
class Pagina_Login extends StatefulWidget {
  const Pagina_Login({Key? key}) : super(key: key);

  @override
  State<Pagina_Login> createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<Pagina_Login> {

  // Declaração de variáveis
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController(); //Controlador do widget de text do login
  final _passwordController = TextEditingController(); //Controlador do widget da palavra-passe do login
  bool _verPassword = false; //Variavel que indica se a palavra-passe está visivel

  @override
  Widget build(BuildContext context) {

    var _height = MediaQuery.of(context).size.height; //Declaração da altura do container do login, tamanho do telemóvel
    var _width = MediaQuery.of(context).size.width; //Declaração da largura do container do login, tamanho do telemóvel

    return Scaffold(
      body: Container( //Declaração do container do login
        height: _height, //Introduzir a altura
        width: _width, //Introduzir a largura
        decoration: BoxDecoration( //Criar o estilo da página
            gradient: LinearGradient( //Declaração do gradient, começa numa cor e acaba noutra
                colors: [ //Declaração das cores do Spot4All
                  Color(0xFF1D3B8C), //Cor de inicio
                  Color(0xFF000000), //Cor do final
                ], //É possivel adicionar cores ao gradient
                begin: Alignment.topLeft, //Declaração de onde começa
                end: Alignment.bottomRight //Declaração de onde acaba
            )
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20), //Declaração da distâncioa que os widgets mantei
            child: Form(
              key: _formkey, //Declaração da formkey
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, //Declaração do format a que os elementos do login e expandem
                children: [
                  Image.asset(
                    'lib/Imagens/logoS4A.png', //Logo da aplicação
                  ),
                  SizedBox(
                    height: 40, //Declaração do espaço entre a Logo e o widget do email
                  ),
                  TextFormField(
                    controller: _emailController, //Introdução do controlador do email
                    keyboardType: TextInputType.emailAddress, //Declaração do typo de teclado que aparece no ecrã do telemóvel
                    decoration: InputDecoration(
                      label: Text('e-mail'), //Introdução do titulo do widget do email
                      hintText: 'nom@gmail.com', //Texto que aparece enquanto o email não está a ser escrito
                      filled: true, //Colocar o fundo do widget com a cor
                      fillColor: Colors.white, //Criação da caixa branca á volta do widget
                    ),
                    validator: (email) { //Validar existe um email na caixa de texto
                      if (email == null || email.isEmpty) {
                        return 'Introduza o seu e-mail';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20, //Declaração do espaço entre a widget do email e o widget da palavra-passe
                  ),
                  TextFormField(
                    controller: _passwordController, //Introdução do controlador da palavra-passe
                    keyboardType: TextInputType.visiblePassword, //Introdução do icone para visualizar a palavra-passe
                    obscureText: !_verPassword, //Declarar o tipo de texto que o widget da palavra-passe contêm
                    decoration: InputDecoration(
                      label: Text('password'), //Introdução do titulo do widget da palavra-passe
                      hintText: 'Introduza a sua palavra-passe', //Texto que aparece enquanto a palavra-passe não está a ser escrita
                      filled: true, //Colocar o fundo do widget com a cor
                      fillColor: Colors.white, //Definir a cor do widget
                      suffixIcon: IconButton( //Colocar o icone no widget
                        icon: Icon(_verPassword //Definir a variavel que controla o icone
                            ? Icons.visibility_off_outlined //Definir o icone quando não ativado
                            : Icons.visibility_outlined //Definir o icone quando ativado
                        ),
                        onPressed: () {
                          setState(() {
                            _verPassword = !_verPassword; //Definir a função que é executada quando o icone é pressionado
                          });
                        },
                      ),
                    ),
                    validator: (password) { //Verificar se a palavra-passe é compativel
                      if (password == null || password.isEmpty) { //verificar se está vazia
                        return 'Introduza a sua palavra-passe';
                     } else if (password.length <= 6) { //Verificar se é menor que 6 characteres
                        return 'Introduza uma palavra-passe válida';
                      } // Validar a palavra passe
                    },
                  ),
                  SizedBox(
                    height: 20, //Colocar a distância entre o widget da palavra passe e o botão
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom( //Colocar o estilo no botão
                      primary: Color(
                          0xFF4bae50 //Definir a cor do botão
                      ), // Background color
                    ),
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        EfetuarLogin(); //Efetuar o login
                      };
                    },
                    child: Text( //Texto do botão
                      'Aceder',
                      style: TextStyle(
                        color: Colors.white //Colocar a cor do texto do botão
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

     var response = await http.post( //Enviar o request para verificar o login
       Uri.parse('https://demo.spot4all.com/login'),
       headers: <String, String>{ //Headers necessários para realizar a verificação
         'Content-Type': 'application/json; charset=UTF-8',
       },
       body: jsonEncode(<String, String>{ //Enviar os valores do email e da palavra-passe
         'email': _emailController.text, //Enviar email
         'password': _passwordController.text, //Enviar palavra-passe
       }),
     ); // Executar a pesquisa do login do utilizador na API

    Map<String, dynamic> responseData = jsonDecode(response.body); //Retirar o texto da resposta da API para uma variavel

    if(responseData['token'] != null){ //Verificação se o login foi aprovado

      var _token = responseData['token']; //Retirar o token para uma variavel para que possa ser utilizado no login
      _sharedPreferences.setString('login_token', _token!); //Colocar o token para que o utilizador não tenha que estar sempre a efetuar o login na app

      int? _user_ID = responseData['user']['user_id']; //Retirar o id do utilizador para uma variavel para que possa ser utilizado na dashboard
      _sharedPreferences.setInt('id_user', _user_ID!); //Colocar o Id do utilizador para que este possa ser utilizado para  a dasboard

      _sharedPreferences.setInt('login_token_expiration', DateTime.now().millisecondsSinceEpoch + (30 * 60 * 1000)); // Colocar o tempo que o token irá estar ativo por, o tempo pode ser alterado se modificar o primeiro valor pela quantidade de minutos desejado, de momento está preparado para durar 30 minutos
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Pagina_Dashboard())); //Trocar para a página da dashboard
    }else{
      showDialog( //Declaração do popup de erro
        context: context,  //Introduzir o contexto
        builder: (BuildContext context) { //Declarar o construtor
          return AlertDialog( //Declarar o widget do popup
            title: Text('Error'), //Titulo do erro
            content: Text('Email ou Password incorreto!'), //Texto do erro
            actions: <Widget>[ //Declarar widgets do popup
              ElevatedButton( //Declaração do botão do popup
                child: Text('OK'), //Texto do botão
                onPressed: () {
                  Navigator.of(context).pop(); //Destruir o botão
                },
              ),
            ],
          );
        },
      );
    }
  }
}