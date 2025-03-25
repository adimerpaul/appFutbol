import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CrearEquipo extends StatefulWidget {
  final Map? liga;
  const CrearEquipo({
    super.key,
    this.liga,
  });

  @override
  State<CrearEquipo> createState() => _CrearEquipoState();
}

class _CrearEquipoState extends State<CrearEquipo> {
  TextEditingController name = TextEditingController();
  // imagen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Equipo'),
        backgroundColor: Colors.cyan,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: Text('Liga: ${widget.liga!['name']}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            TextField(
              controller: name,
              decoration: const InputDecoration(
                labelText: 'Nombre del equipo',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        )
      )
    );
  }
}
