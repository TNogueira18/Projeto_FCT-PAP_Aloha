import 'package:flutter/material.dart';
import 'package:main/Pagina_Login.dart';
import 'package:main/Pagina_Inicial.dart';
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
    verificarUtilizador().then((temUtilizador) {
      if (temUtilizador) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Pagina_Inicial()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Pagina_Login()));
      }
    });
  }

  //Colocar os widgets
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.black,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight
              )
          ),
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