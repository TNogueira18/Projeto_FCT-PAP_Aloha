import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Declarar a Página
class Pagina_Inicial extends StatefulWidget {
  const Pagina_Inicial({super.key});

  @override
  State<Pagina_Inicial> createState() => _PaginaInicialState();
}


class _PaginaInicialState extends State<Pagina_Inicial> {

  //Colocar os widgets
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Bem-Vindo"
        )
      )
    );
  }
}