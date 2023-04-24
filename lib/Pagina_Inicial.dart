import 'package:flutter/material.dart';
import 'package:main/Pagina_Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Declarar a Página
class Pagina_Inicial extends StatefulWidget {
  const Pagina_Inicial({super.key});

  @override
  State<Pagina_Inicial> createState() => _PaginaInicialState();
}


class _PaginaInicialState extends State<Pagina_Inicial> {

  //Executar a verificação do token
  @override
  initState(){
    super.initState();
    verificarUtilizador().then((temUtilizador){
      if(temUtilizador){
        Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => const Pagina_Inicial()));
      }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => const Pagina_Login()));
      }
    });
  }

  //Colocar os widgets
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text('Bem Vindo')
      ),
    );
  }

  //Função que verifica se o token ainda está valido
  Future<bool> verificarUtilizador() async {
    SharedPreferences _sharedPreferences = await SharedPreferences
        .getInstance();
    String? token = _sharedPreferences.getString('login_token');
    int? expirationTime = _sharedPreferences.getInt('login_token_expiration');

    if (token != null && expirationTime != null && DateTime
        .now()
        .millisecondsSinceEpoch < expirationTime) {
      return true;
    } else {
      return false;
    }
  }
}