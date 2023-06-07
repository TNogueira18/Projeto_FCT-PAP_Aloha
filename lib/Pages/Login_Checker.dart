import 'package:flutter/material.dart';
import 'package:main/Pages/Pagina_Login.dart';
import 'package:main/Pages/Pagina_Dashboard_Tarefas.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Declarar a Página
class Login_Ckecker extends StatefulWidget {
  const Login_Ckecker({super.key});

  @override
  State<Login_Ckecker> createState() => _Login_CkeckerState();
}

class _Login_CkeckerState extends State<Login_Ckecker> {
  //Executar a verificação do token
  @override
  initState() {
    super.initState();
    verificarUtilizador().then((_temUtilizador) { //Verificar se o existe um token ou se o mesmo ainda está válido
      if (_temUtilizador == true) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Pagina_Dashboard())); //Enviar para a página da dashboard quando o mesmo existe e está válido
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Pagina_Login())); //Enviar para o login quando não existe ou não está válido
      }
    });
  }

  //Colocar os widgets
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration( //Colocar o estilo
              gradient: LinearGradient( //Definir o tipo de gradient
                  colors: [
                    Colors.white, //Declaração da cor de ínicio do gradient
                    Colors.black, //Declaração da cor final do gradient
                  ],
                  begin: Alignment.topLeft, //Onde o gradient começa
                  end: Alignment.bottomRight //Onde o gradient acaba
              )
          ),
      ),
    );
  }

  //Função que verifica se o token ainda está valido
  Future<bool> verificarUtilizador() async {
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance(); //Ativar a library sharedPreferences
    String? token = _sharedPreferences.getString('login_token'); //Colocar o token, se existir, numa variavél
    int? expirationTime = _sharedPreferences.getInt('login_token_expiration'); //Colocar o tempo de expiração numa variável, se existir

    if (token != null && expirationTime != null && DateTime.now().millisecondsSinceEpoch < expirationTime) { //Verificação do tempo de expiração
      return true;
    } else { //Returnar o resultado da verificação
      return false;
    }
  }
  }