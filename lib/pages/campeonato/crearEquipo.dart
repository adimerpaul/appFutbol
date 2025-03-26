import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import '../../addons/scaffold.dart';

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
  File? _imagen;
  bool loading = false;
  final url = dotenv.env['API_URL'];
  // final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
  }
  pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _imagen= File(image.path);
      setState(() {});
    }
  }
  saveEquipo() async{
      if (name.text.isEmpty) {
        error(context, 'El nombre del equipo es requerido');
        return;
      }
      loading = true;
      setState(() {});
      final uri = Uri.parse('$url/equipos');
      final request = http.MultipartRequest('POST', uri);
      request.fields['name'] = name.text;
      request.fields['ligaId'] = widget.liga!['id'].toString();
      // print(this.image);
      if (_imagen != null) {
        print('image');
        request.files.add(
          await http.MultipartFile.fromPath('image', _imagen!.path, filename: path.basename(_imagen!.path))
        );
      }
      final response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 201) {
        success(context, 'Equipo creado correctamente');
        Navigator.pop(context, true);
      } else {
        error(context, 'Error al crear el equipo');
      }
      loading = false;
      setState(() {});
  }

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
            SizedBox(height: 20),
            TextField(
              controller: name,
              decoration: const InputDecoration(
                labelText: 'Nombre del equipo',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _imagen != null ? FileImage(_imagen!) : AssetImage('assets/images/default.png'),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.camera_alt, color: Colors.black),
                  ),
                ),
              )
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: loading ? null : saveEquipo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  foregroundColor: Colors.white,
                ),
                icon: Icon(Icons.save),
                label: loading ? const CircularProgressIndicator() : const Text('Guardar'),
              ),
            )
          ],
        )
      )
    );
  }
}
