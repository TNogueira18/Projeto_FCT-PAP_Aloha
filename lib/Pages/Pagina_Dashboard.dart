import 'package:flutter/material.dart';

class Pagina_Dashboard extends StatefulWidget {
  const Pagina_Dashboard({super.key});

  @override
  State<Pagina_Dashboard> createState() => _PaginaDasboardState();
}

class _PaginaDasboardState extends State<Pagina_Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget> [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          )
        ],
      ),
    )
  }
}
