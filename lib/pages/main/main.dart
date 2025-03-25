import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:futbol/addons/scaffold.dart';
import 'package:futbol/color/Colors.dart';
import 'package:http/http.dart' as http;
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List campeonatos = [];
  final url = dotenv.env['API_URL'];
  @override
  void initState() {
    super.initState();
    getLigas();
  }
  getLigas() async {
    // print(url);
    var response = await http.get(Uri.parse('$url/ligas'));
    if (response.statusCode == 200) {
      // print(response.body);
      var res = json.decode(response.body);
      campeonatos = res;
      setState(() {});
    } else {
      print('Error');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.menu),
            Text('Campeonatos',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
            Icon(Icons.person_outline_outlined),
            // icon notification
          ],
        ),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => const Divider(),
        itemCount: campeonatos.length,
        itemBuilder: (context, index) {
          return ListTile(
            // dense: true,
            leading: Image.asset( campeonatos[index]['tipo'] == 'Futbol' ? 'assets/images/futbol.jpg' : 'assets/images/basquet.png', width: 50),
            title: Text(campeonatos[index]['name'],style: TextStyle(fontSize: 20)),
            subtitle: Text('Equipos: ${campeonatos[index]['equipos']}'),
            onTap: () {
              Navigator.pushNamed(context, '/campeonato', arguments: campeonatos[index]);
            },
          //   acciones modificar y elminar
            trailing: PopupMenuButton(
              icon: Icon(Icons.more_vert),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Modificar'),
                  ),
                  value: 'modificar',
                ),
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.delete),
                    title: Text('Eliminar'),
                  ),
                  value: 'eliminar',
                ),
              ],
              onSelected: (value) async {
                if (value == 'modificar') {
                  var result = await Navigator.pushNamed(context, '/crear-liga', arguments: campeonatos[index]);
                  if (result == true){
                    getLigas();
                  }
                }
                if (value == 'eliminar') {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Eliminar'),
                        content: Text('¿Estas seguro de eliminar este campeonato?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () async {
                              var response = await http.delete(Uri.parse('$url/ligas/${campeonatos[index]['id']}'));
                              if (response.statusCode == 200) {
                                getLigas();
                                Navigator.pop(context);
                              } else {
                                print('Error'+response.body);
                              }
                            },
                            child: Text('Eliminar'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: SizedBox(
        height: 40,
        child: FloatingActionButton.extended(
          onPressed: () {
            showMenu(
              context: context,
              position: RelativeRect.fromLTRB(
                MediaQuery.of(context).size.width - 100,
                MediaQuery.of(context).size.height - 150,
                16,
                16,
              ),
              items: [
                PopupMenuItem(
                  value: 'liga',
                  child: ListTile(
                    leading: Icon(Icons.add),
                    title: Text('Crear liga'),
                  ),
                ),
                PopupMenuItem(
                  value: 'actualizar',
                  child: ListTile(
                    leading: Icon(Icons.refresh),
                    title: Text('Actualizar'),
                  ),
                ),
              ],
            ).then((value) async {
              if (value == 'actualizar') {
                getLigas();
              }
              if (value == 'liga') {
                var result = await Navigator.pushNamed(context, '/crear-liga');
                if (result == true) {
                  getLigas();
                }
              }
            });
          },
          label: Text("Opciones",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
          icon: Icon(Icons.menu, color: Colors.white),
          backgroundColor: primaryColor,
          elevation: 10,
        ),
      ),
    );
  }
}
