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
      print(response.body);
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
            leading: Image.asset( campeonatos[index]['tipo'] == 'Futbol' ? 'assets/images/futbol.jpg' : 'assets/images/basquet.jpg', width: 50),
            title: Text(campeonatos[index]['name'],style: TextStyle(fontSize: 20)),
            subtitle: Text('Equipos: ${campeonatos[index]['equipos']}'),
            onTap: () {
              Navigator.pushNamed(context, '/campeonato', arguments: campeonatos[index]);
            },
          );
        },
      ),
      floatingActionButton: PopupMenuButton(
        icon: Icon(Icons.add),
        itemBuilder: (context) => [
          PopupMenuItem(
            child: ListTile(
              leading: Icon(Icons.add),
              title: Text('Crear liga'),
            ),
            value: 'liga',
          ),
          PopupMenuItem(
            child: ListTile(
              leading: Icon(Icons.refresh),
              title: Text('Actualizar'),
            ),
            value: 'actualizar',
          ),
        ],
        onSelected: (value) async {
          if (value == 'actualizar') {
            getLigas();
          }
          if (value == 'liga') {
            var result =await Navigator.pushNamed(context, '/crear-liga');
            if (result == true){
              getLigas();
            }
          }
        },
      )
    );
  }
}
