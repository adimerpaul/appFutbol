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
  final Map? equipo;
  const CrearEquipo({
    super.key,
    this.liga,
    this.equipo,
  });

  @override
  State<CrearEquipo> createState() => _CrearEquipoState();
}

class _CrearEquipoState extends State<CrearEquipo> {
  TextEditingController name = TextEditingController();
  // liga

  File? _imagen;
  bool loading = false;
  final url = dotenv.env['API_URL'];
  // final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.equipo != null) {
      name.text = widget.equipo!['name'];
    }
  }
  pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _imagen= File(image.path);
      setState(() {});
    }
  }
  saveEquipo() async {
    if (name.text.isEmpty) {
      error(context, 'El nombre del equipo es requerido');
      return;
    }
    loading = true;
    setState(() {});

    final isEdit = widget.equipo != null;
    final uri = isEdit
        ? Uri.parse('$url/equipos/${widget.equipo!['id']}')
        : Uri.parse('$url/equipos');

    final request = http.MultipartRequest(isEdit ? 'PUT' : 'POST', uri);
    request.fields['name'] = name.text;
    request.fields['ligaId'] = widget.liga!['id'].toString();

    if (_imagen != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', _imagen!.path, filename: path.basename(_imagen!.path)),
      );
    }

    final response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      success(context, isEdit ? 'Equipo actualizado correctamente' : 'Equipo creado correctamente');
      Navigator.pop(context, true);
    } else {
      error(context, 'Error al ${isEdit ? 'actualizar' : 'crear'} el equipo');
    }
    loading = false;
    setState(() {});
  }
getImagen() {
  // print('getImagen zzzzzzzzzzzzzzzzzzzzzzzz');
  // _imagen != null ? FileImage(_imagen!) : AssetImage('assets/images/default.png')
  if (_imagen != null) {
    return FileImage(_imagen!);
  }
  if (widget.equipo != null) {
    // print('$url/uploads/${widget.equipo!['imagen']}');
    return NetworkImage('$url/uploads/${widget.equipo!['imagen']}');
  }
  return const AssetImage('assets/images/default.png');
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text( widget.equipo != null ? 'Editar equipo' : 'Crear equipo'),
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
                backgroundImage: getImagen(),
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
                icon: Icon(widget.equipo != null ? Icons.edit : Icons.save),
                label: loading ? const CircularProgressIndicator() : Text(widget.equipo != null ? 'Editar' : 'Crear'),
              ),
            ),
            SizedBox(height: 20),
            if (widget.equipo != null)
            SizedBox(
              // eliminar
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Eliminar equipo'),
                        content: const Text('¿Estás seguro de eliminar este equipo?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () async {
                              final response = await http.delete(Uri.parse('$url/equipos/${widget.equipo!['id']}'));
                              print(response.statusCode);
                              if (response.statusCode == 200) {
                                success(context, 'Equipo eliminado correctamente');
                                Navigator.pop(context, true);
                                Navigator.pop(context, true);
                              } else {
                                error(context, 'Error al eliminar el equipo');
                              }
                            },
                            child: const Text('Eliminar'),
                          ),
                        ],
                      );
                    },
                  );
                  // var response = await http.delete(Uri.parse('$url/equipos/${widget.equipo!['id']}'));
                  // if (response.statusCode == 200) {
                  //   success(context, 'Equipo eliminado correctamente');
                  //   Navigator.pop(context, true);
                  // } else {
                  //   error(context, 'Error al eliminar el equipo');
                  // }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.delete),
                label: const Text('Eliminar'),
              ),
            ),
          ],
        )
      )
    );
  }
}
