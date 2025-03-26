import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class Equipos extends StatefulWidget {
  final Map? liga;
  const Equipos({super.key, this.liga});

  @override
  State<Equipos> createState() => EquiposState();
}

class EquiposState extends State<Equipos> {
  final url = dotenv.env['API_URL'];
  List equipos = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    getEquipo();
  }

  Future<void> getEquipo() async {
    loading = true;
    setState(() {});
    final ligaId = widget.liga!['id'];
    final response = await http.get(Uri.parse('$url/equipos?ligaId=$ligaId'));
    if (response.statusCode == 200) {
      print(response.body);
      final res = json.decode(response.body);
      equipos = res;
    } else {
      print('Error');
    }
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 5,
                dataRowMinHeight: 20,
                dataRowMaxHeight: 30,
                headingRowHeight: 36,
                columns: const [
                  DataColumn(label: Text('#')),
                  DataColumn(label: Text('Equipo')),
                  DataColumn(label: Text('PJ')),
                  DataColumn(label: Text('G')),
                  DataColumn(label: Text('E')),
                  DataColumn(label: Text('P')),
                  DataColumn(label: Text('GF')),
                  DataColumn(label: Text('GC')),
                  DataColumn(label: Text('DG')),
                  DataColumn(label: Text('Pts')),
                  DataColumn(label: Text('Últimos 5')),
                ],
                rows: equipos.map<DataRow>((equipo) {
                  return DataRow(cells: [
                    DataCell(Text('${equipos.indexOf(equipo) + 1}')),
                    DataCell(
                      Row(
                        children: [
                          Image.network(
                            '$url/uploads/${equipo['imagen']}',
                            width: 24,
                            height: 24,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported,
                                  size: 24, color: Colors.grey);
                            },
                          ),
                          Container(
                            width: 100,
                            child: Text(
                              equipo['name'] ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              style: const TextStyle(height: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                    DataCell(Text('${equipo['pj'] ?? 0}')),
                    DataCell(Text('${equipo['g'] ?? 0}')),
                    DataCell(Text('${equipo['e'] ?? 0}')),
                    DataCell(Text('${equipo['p'] ?? 0}')),
                    DataCell(Text('${equipo['gf'] ?? 0}')),
                    DataCell(Text('${equipo['gc'] ?? 0}')),
                    DataCell(Text('${equipo['dg'] ?? 0}')),
                    DataCell(Text('${equipo['pts'] ?? 0}')),
                    DataCell(Row(
                      children:
                      (equipo['ultimos5'] as List<dynamic>).map((r) {
                        IconData icon;
                        Color color;
                        switch (r) {
                          case 'Ganó':
                            icon = Icons.check_circle;
                            color = Colors.green;
                            break;
                          case 'Perdió':
                            icon = Icons.cancel;
                            color = Colors.red;
                            break;
                          case 'Empate':
                            icon = Icons.remove_circle;
                            color = Colors.orange;
                            break;
                          default:
                            icon = Icons.help;
                            color = Colors.grey;
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Icon(icon, size: 16, color: color),
                        );
                      }).toList(),
                    )),
                  ]);
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
