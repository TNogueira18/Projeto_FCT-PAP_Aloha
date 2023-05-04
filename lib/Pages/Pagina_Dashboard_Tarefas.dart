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
            child: AppBar(
              title: Text(
                'Tarefas'
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
                          backgroundColor: Color(
                              0xFF2c55ca
                          )
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
                            backgroundColor: Color(
                                0xFF2c55ca
                            )
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
                              backgroundColor: Color(
                                  0xFF2c55ca
                              )
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
