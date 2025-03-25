import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:futbol/pages/main/main.dart';

import 'pages/campeonato/campeonato.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const bool isProduction = bool.fromEnvironment('dart.vm.product');
  await dotenv.load(fileName: isProduction ? ".env.production" : ".env");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      child: MaterialApp(
        title: 'Torneo',
        initialRoute: '/',
        onGenerateRoute: (settings) {
          if (settings.name == '/') {
            return MaterialPageRoute(builder: (context) => const MainPage());
          }

          if (settings.name == '/campeonato') {
            final campeonato = settings.arguments as Map;
            return MaterialPageRoute(
              builder: (context) => CampeonatoPage(campeonato: campeonato),
            );
          }

          // Ruta desconocida
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(child: Text('Página no encontrada')),
            ),
          );
        },
      ),
    );
  }
}