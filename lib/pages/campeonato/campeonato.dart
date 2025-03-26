import 'package:flutter/material.dart';
import 'package:futbol/pages/campeonato/equipos.dart';
import 'package:futbol/pages/campeonato/partidos.dart';

class CampeonatoPage extends StatefulWidget {
  final Map campeonato;
  const CampeonatoPage({
    super.key,
    required this.campeonato,
  });

  @override
  State<CampeonatoPage> createState() => _CampeonatoPageState();
}

class _CampeonatoPageState extends State<CampeonatoPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final GlobalKey<EquiposState> equiposKey = GlobalKey<EquiposState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final campeonato = widget.campeonato;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              campeonato['tipo'] == 'Futbol'
                  ? 'assets/images/futbol.jpg'
                  : 'assets/images/basquet.png',
              width: 30,
            ),
            Text(campeonato['name'], style: const TextStyle(fontSize: 15)),
          ],
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            customTab('Equipos', Icons.groups, 0),
            customTab('Partidos', Icons.sports_soccer, 1),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Equipos(key: equiposKey, liga: campeonato), // ✅ pasa la key
          Partidos(liga: campeonato),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    switch (_tabController.index) {
      case 0:
        return SizedBox(
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
                    value: 'agregar',
                    child: ListTile(
                      leading: const Icon(Icons.add),
                      title: const Text('Agregar equipo'),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'actualizar',
                    child: ListTile(
                      leading: const Icon(Icons.refresh),
                      title: const Text('Actualizar'),
                    ),
                  ),
                ],
              ).then((value) async {
                if (value == 'agregar') {
                  final res =await Navigator.pushNamed(
                    context,
                    '/crear-equipo',
                    arguments: {
                      'liga': widget.campeonato,
                    }
                  );
                  if (res == true){
                    equiposKey.currentState?.getEquipo(); // ✅ refresca al volver
                  }
                }
                if (value == 'actualizar') {
                  equiposKey.currentState?.getEquipo(); // ✅ actualiza
                }
              });
            },
            label: const Text("Equipo", style: TextStyle(color: Colors.white)),
            icon: const Icon(Icons.menu, color: Colors.white),
            elevation: 10,
            backgroundColor: Colors.blue,
          ),
        );
      case 1:
        return FloatingActionButton(
          onPressed: () {
            print('Partido');
          },
          child: const Icon(Icons.add),
        );
      default:
        return const SizedBox();
    }
  }

  Widget customTab(String title, IconData icon, int index) {
    final isSelected = _tabController.index == index;
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? Colors.white : Colors.black),
          const SizedBox(width: 8),
          Text(title,
              style:
              TextStyle(color: isSelected ? Colors.white : Colors.black)),
        ],
      ),
    );
  }
}
