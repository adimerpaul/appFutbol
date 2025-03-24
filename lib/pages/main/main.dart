import 'package:flutter/material.dart';
import 'package:futbol/color/Colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List campeonatos = [];
  @override
  void initState() {
    super.initState();
    getCampeonatos();
  }
  getCampeonatos() {
    campeonatos = [
      {'id': 1, 'nombre': 'Futbol mayores', 'imagen': 'assets/images/futbol.jpg', 'equipos': 10},
      {'id': 2, 'nombre': 'Futsal femenino', 'imagen': 'assets/images/futbol.jpg', 'equipos': 8},
      {'id': 3, 'nombre': 'Futbol infantil', 'imagen': 'assets/images/futbol.jpg', 'equipos': 12},
      {'id': 4, 'nombre': 'Basquet femenino', 'imagen': 'assets/images/basquet.jpg', 'equipos': 6},
      // {'id': 5, 'nombre': 'Basquet masculino', 'imagen': 'assets/images/basquet.jpg', 'equipos': 8},
      // {'id': 6, 'nombre': 'Voley femenino', 'imagen': 'assets/images/voley.jpg', 'equipos': 10},
      // {'id': 7, 'nombre': 'Voley masculino', 'imagen': 'assets/images/voley.jpg', 'equipos': 8},
    ];
    setState(() {});
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
            Text('Campeonatos',style: TextStyle(fontSize: 20)),
            Icon(Icons.search),
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
            leading: Image.asset(campeonatos[index]['imagen']),
            title: Text(campeonatos[index]['nombre'],style: TextStyle(fontSize: 20)),
            subtitle: Text('Equipos: ${campeonatos[index]['equipos']}'),
            onTap: () {
              Navigator.pushNamed(context, '/campeonato', arguments: campeonatos[index]);
            },
          );
        },
      ),
    );
  }
}
