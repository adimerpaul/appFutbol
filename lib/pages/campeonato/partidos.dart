import 'package:flutter/material.dart';

class Partidos extends StatefulWidget {
  final Map? liga;
  const Partidos({
    super.key,
    this.liga,
  });

  @override
  State<Partidos> createState() => _PartidosState();
}

class _PartidosState extends State<Partidos> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Partidos'),
        const Divider(),
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Partido $index'),
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
