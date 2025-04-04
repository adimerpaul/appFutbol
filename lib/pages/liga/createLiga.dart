import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../addons/scaffold.dart';

class Createliga extends StatefulWidget {
  final Map? liga;
  const Createliga({
    super.key,
    this.liga,
  });

  @override
  State<Createliga> createState() => _CreateligaState();
}

class _CreateligaState extends State<Createliga> {
  final url = dotenv.env['API_URL'];
  TextEditingController name = TextEditingController();
  TextEditingController tipo = TextEditingController();
  List<String> tipos = ['Futbol', 'Basquet'];
  bool loading = false;
  @override
  void initState() {
    super.initState();
    tipo.text = 'Futbol';
    if (widget.liga != null) {
      name.text = widget.liga!['name'];
      tipo.text = widget.liga!['tipo'];
    }
  }

  save() async {
    if (name.text.isEmpty) {
      error(context, 'El nombre de la liga es requerido');
      return;
    }
    setState(() {
      loading = true;
    });
    if (widget.liga != null) {
      var response = await http.put(Uri.parse('$url/ligas/${widget.liga!['id']}'), body: {
        'name': name.text,
        'tipo': tipo.text,
      });
      if (response.statusCode == 200) {
        success(context, 'Liga actualizada correctamente');
        Navigator.pop(context, true);
      } else {
        error(context, response.body);
      }
      setState(() {
        loading = false;
      });
      return;
    }
    var response = await http.post(Uri.parse('$url/ligas'), body: {
      'name': name.text,
      'tipo': tipo.text,
    });
    if (response.statusCode == 201) {
      success(context, 'Liga creada correctamente');
      Navigator.pop(context, true);
    } else {
      error(context, response.body);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.liga != null ? 'Actualizar Liga' : 'Crear Liga'),
        backgroundColor: widget.liga != null ? Colors.orange : Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: name,
              decoration: InputDecoration(
                labelText: 'Nombre de la liga',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            // DropdownButtonFormField<String>(
            //   value: tipo.text,
            //   items: tipos.map((String value) {
            //     return DropdownMenuItem<String>(
            //       value: value,
            //       child: Text(value),
            //     );
            //   }).toList(),
            //   onChanged: (String? value) {
            //     setState(() {
            //       tipo.text = value!;
            //     });
            //   },
            //   decoration: InputDecoration(
            //     labelText: 'Tipo',
            //     border: OutlineInputBorder(),
            //   ),
            // ),
            // radio button
            Row(
              children: [
                Text('Futbol'),
                Radio<String>(
                  value: 'Futbol',
                  groupValue: tipo.text,
                  onChanged: (String? value) {
                    setState(() {
                      tipo.text = value!;
                    });
                  },
                ),
                Text('Basquet'),
                Radio<String>(
                  value: 'Basquet',
                  groupValue: tipo.text,
                  onChanged: (String? value) {
                    setState(() {
                      tipo.text = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.liga != null ? Colors.orange : Colors.green,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.save, color: Colors.white),
                label: loading ? const CircularProgressIndicator() : Text(widget.liga != null ? 'Actualizar Liga' : 'Crear Liga'),
                onPressed: loading ? null : save,
                // child: const Text('Crear Liga'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
