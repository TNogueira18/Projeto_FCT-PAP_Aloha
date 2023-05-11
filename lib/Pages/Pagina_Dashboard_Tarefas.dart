import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
            child: AppBar(
              title: Text(
                'Tarefas'
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
                          ),
                        )
                    )
                ),
              ],
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,

          )
        ],
      ),
    );
  }
}

EfetuarLogin() async {
  var response = await http.get(
    Uri.parse('https://demo.spot4all.com/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      },
    ),
  ); // Executar a pesquisa do login do utilizador na API
}
