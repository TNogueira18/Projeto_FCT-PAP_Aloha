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

String _Path = 'Todas'; //Declaração da variavél utilizada para definir o endpoint a ser utilizado

class Constants { //Declaração das constantes utilizadas no dropdown menu
  static const String FirstItem = 'Todas'; //Declaração do primeiro item da lista
  static const String SecondItem = 'Dia'; //Declaração do segundo item da lista
  static const String ThirdItem = 'Pendentes'; //Declaração do terceiro item da lista
  static const String FourthItem = 'Futuras'; //Declaração do quarto item da lista
  static const String FifthItem = 'Logout'; //Declaração do quinto item da lista

  static const List<String> choices = <String>[ //Declaração da lista do dropdown menu
    FirstItem, //Primeiro item
    SecondItem, //Segundo item
    ThirdItem, //Terceiro item
    FourthItem, //Quarto item
    FifthItem, //Quinto item
  ];
}

class _PaginaDasboardState extends State<Pagina_Dashboard> {
  //final _formkey = GlobalKey<FormState>();
  List<Widget> _Lista_Widgets = []; //Declaração da lista do cartões da tarefas
  List<Widget> _list_widgets = []; //Declaração da lista de cartões enquanto os mesmos estão a ser chamados na função de ir buscar todas as tarefas

  @override
  void initState() {
    super.initState();
    todasTarefas(); //Iniciar a função que vai buscar todas as tarefas
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
        leading: PopupMenuButton<String>( //Criar o dropdown menu
          icon: Icon(Icons.menu), //Colocar o icone
          onSelected: choiceAction, //Implementar a função para selecionar cada opção
          itemBuilder: (BuildContext context) { //Ativar o construtor
            return Constants.choices.map((String choice) {
              return PopupMenuItem<String>( //Construir o popup
                value: choice,
                child: Text(
                  choice, //Colocar o text da lista dos items
                ),
              );
            }).toList();
          },
        ),
      ),
      body: ListView.builder(
        itemCount: _Lista_Widgets.length,
        itemBuilder: (context, index) {
          return _Lista_Widgets[index]; //Construir a lista dos cartões das tarefas
        },
      ),
    );
  }

  //Função que realiza o request á base de dados, e cria os cartões das tarefas
  Future<List<Widget>> getTarefas(String path) async {
    List<Widget> _Lista_Widget_Tarefas = []; //Declaração da lista provisória dos cartões
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance(); //Ativar a livraria do shared preferences
    String? _token = _sharedPreferences.getString('login_token'); //Colocar o token numa variável
    int? _id = _sharedPreferences.getInt('id_user'); //Colocar o id do utilizador numa variável

    var _BC = 5; //Definir a variável da cor do cartão

    if (path == 'todas-tarefas-pendentes') { //Trocar a cordo cartão para a cor dos cartões pendentes
      _BC = 0xFFf2c4c4;
    } else if (path == 'todas-tarefas-dia') { //Trocar a cordo cartão para a cor dos cartões diários
      _BC = 0xFFf5e8b3;
    } else if (path == 'todas-tarefas-futuras') { //Trocar a cordo cartão para a cor dos cartões futuros
      _BC = 0xFF9db5f6;
    }

    try {
      String _url = 'https://demo.spot4all.com/$path/$_id'; //Definir o endpoint onde o request irá ser realizado
      Map<String, String> _headers = { //Definir os headers utilizados no request á API
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $_token',
      };
      try {
        final response = await http.get(Uri.parse(_url), headers: _headers); //Realizar o request á API
        if (response.statusCode == 200) { //Verificar se o Request foi consebido
          List<dynamic> _Lista_Mapas = jsonDecode(response.body); //Colocar a resposta da API numa lista
          for (int counter = 0; counter < _Lista_Mapas.length; counter++) {
            Map<String, dynamic> _Lista_Tarefas = _Lista_Mapas[counter]; //Mapear cada item da list para que possa ser processado
            if (_Lista_Tarefas['status_tarefa'] == 1) { //Verificar se a Tarefas ainda está ativa
              String _id_contactos = 'id:' + //Criar o texto dos widgets dos cartões
                  _Lista_Tarefas['tarefa_id'].toString() +
                  ' - ' +
                  _Lista_Tarefas['name'].toString() +
                  ' - (' +
                  _Lista_Tarefas['nickname'].toString() +
                  ')';
              String _title_status = _Lista_Tarefas['title'] +
                  ' - ' +
                  _Lista_Tarefas['status_name'].toString();
              String _subject = _Lista_Tarefas['subject'];
              String _description = _Lista_Tarefas['description'];
              String _dataend_assigned =
                  _Lista_Tarefas['data_evento_end'].toString() +
                      ' - ' +
                      _Lista_Tarefas['consultor'].toString();
              String _creator =
                  'Criado por: ' + _Lista_Tarefas['criador'].toString();
              Widget containerWidget = Padding( //Criar os cartões
                padding: EdgeInsets.all(20), //Definir a distância a que o cartão fica dos outros widgets
                child: Container(
                    padding: EdgeInsets.all(20), //Definir a distância a que os widgets ficam da borda do cartão
                    height: 250, //Definir a altura do cartão
                    color: Color(_BC), //Definir a cor do cartão
                    child: Column( //Colocar os widgets no cartão
                      mainAxisSize: MainAxisSize.max, //Definir o tamanho da coluna
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, //Definir o espaço entre widgets
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max, //Definir o tamanho da coluna
                          crossAxisAlignment: CrossAxisAlignment.stretch, //Colocar os widgets no principio do container
                          children: [
                            Text(
                              _id_contactos, //Colocar o texto nos widgets
                              style: TextStyle(color: Colors.black, fontSize: 15), //Colocar os estilo nos widgets
                            ),
                            Text(
                              _title_status, //Colocar o texto nos widgets
                              style: TextStyle(color: Colors.black, fontSize: 15), //Colocar os estilo nos widgets
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min, //Definir o tamanho da coluna
                          crossAxisAlignment: CrossAxisAlignment.start, //Definir onde os widgets começão
                          children: [
                            Text(
                              _subject, //Colocar o texto nos widgets
                              style: TextStyle(color: Colors.black, fontSize: 20), //Colocar os estilo nos widgets
                            ),
                            Text(
                              _description, //Colocar o texto nos widgets
                              style: TextStyle(color: Colors.black, fontSize: 12), //Colocar os estilo nos widgets
                            ),
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.max, //Definir o tamanho da coluna
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, //Definir o espaço entre widgets
                          crossAxisAlignment: CrossAxisAlignment.stretch, //Colocar os widgets no principio do container
                          children: [
                            Text(
                              _dataend_assigned, //Colocar o texto nos widgets
                              style: TextStyle(color: Colors.black, fontSize: 15), //Colocar os estilo nos widgets
                            ),
                            Text(
                              _creator, //Colocar o texto nos widgets
                              style: TextStyle(color: Colors.black, fontSize: 15), //Colocar os estilo nos widgets
                            ),
                          ],
                        ),
                      ],
                    )),
              );
              _Lista_Widget_Tarefas.add(containerWidget); //Colocar os cartões na lista
            }
          }
          ;
        } else {
          print('Failed to fetch data: ${response.statusCode}');
        }
      } catch (e) {
        print('Failed to fetch data: $e');
      }
      return _Lista_Widget_Tarefas; //Returnar a lista dos cartões
    } catch (e) {
      print('Failed to get data: $e');
      return _Lista_Widget_Tarefas; //Returnar a lista dos cartões
    }
  }

  //Função que inicia o processo de criar os cartões
  Future<void> _initializeListaWidgets() async {
    List<Widget> listaWidgets = await getTarefas(_Path); //Iniciar a função para criar os cartões
    setState(() {
      _Lista_Widgets = listaWidgets; //Returnar a lista dos cartões
    });
  }

  //Função que inicia o processo de criar os cartões quando a opção é para ir buscar todas as tarefas
  Future<void> _initializeListaWidgets_todas() async {
    List<Widget> listaWidgets = await getTarefas(_Path); //Iniciar a função para criar os cartões
    setState(() {
      _list_widgets.addAll(listaWidgets); //Adicionar os cartões á lista
    });
  }

  //Função que realiza a pesquisa de todas as tarefas
  Future<void> todasTarefas() async {
    _list_widgets = []; //Declaração da lista onde os cartões estarão guardados enquanto a função vai buscar o resto dos cartões
    int counter = 0; //Declaração do contador
    while (counter < 3) { //Definição do loop
      if (counter == 0) {
        _Path = 'todas-tarefas-pendentes'; //Declaração da primeira entrada na função
      } else if (counter == 1) {
        _Path = 'todas-tarefas-dia'; //Declaração da segunda entrada na função
      } else if (counter == 2) {
        _Path = 'todas-tarefas-futuras'; //Declaração da terceira entrada na função
      } else {
        break; //Acabar o loop
      }
      await _initializeListaWidgets_todas(); //Envoção da lista para realizar a criação dos cartões
      counter+=1; //Aumentar o contador
    }
    _Lista_Widgets = _list_widgets; //Colocar os cartões na lista dos cartões
  }

  //Função que realiza a escolha no dropdown menu
  void choiceAction(String choice) {
    if (choice == Constants.FirstItem) { //Primeiro item selecionado, realiza a pesquisa de todas as tarefas
      //todas
      todasTarefas();
    } else if (choice == Constants.SecondItem) { //Segundo item selecionado, realiza a pesquisa das tarefas do dia
      //dia
      _Path = 'todas-tarefas-dia';
      _initializeListaWidgets();
    } else if (choice == Constants.ThirdItem) { //Terceiro item selecionado, realiza a pesquisa das tarefas pendentes
      //pendentes
      _Path = 'todas-tarefas-pendentes';
      _initializeListaWidgets();
    } else if (choice == Constants.FourthItem) { //Quarto item selecionado, realiza a pesquisa das tarefas futuras
      //futuras
      _Path = 'todas-tarefas-futuras';
      _initializeListaWidgets();
    } else if (choice == Constants.FifthItem) { //Quinto item selecionado, realiza o logout
      //logout
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const Pagina_Login()));
    }
  }
}
