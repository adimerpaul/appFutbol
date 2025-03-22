import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Para redibujar y actualizar el color del ícono
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
        title: Text(campeonato['nombre']),
        backgroundColor: Colors.blue,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            customTab('Resumen', Icons.info, 0),
            customTab('Equipos', Icons.groups, 1),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Resumen
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.asset(
                  campeonato['imagen'],
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 20),
                Text(
                  campeonato['nombre'],
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'Cantidad de equipos: ${campeonato['equipos']}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),

          // Tab 2: Equipos
          Center(
            child: Text(
              'Lista de Equipos',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔧 Este widget genera los tabs personalizados
  Widget customTab(String title, IconData icon, int index) {
    final isSelected = _tabController.index == index;

    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.white : Colors.grey,
          ),
          const SizedBox(width: 8),
          Text(title, style: TextStyle(color: isSelected ? Colors.white : Colors.grey)),
        ],
      ),
    );
  }
}

