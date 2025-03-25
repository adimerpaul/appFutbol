import 'package:flutter/material.dart';

class Equipos extends StatefulWidget {
  final Map? liga;
  const Equipos({
    super.key,
    this.liga,
  });

  @override
  State<Equipos> createState() => _EquiposState();
}

class _EquiposState extends State<Equipos> {
  @override
  void initState() {
    super.initState();
    if (widget.liga != null) {
      print(widget.liga!['name']);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Equipos'),
        const Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Equipo $index'),
                subtitle: Text('Estadio $index'),
                leading: Image.asset(
                  'assets/images/futbol.jpg',
                  width: 50,
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
              );
            },
          ),
        ),
      ],
    );
  }
}
