import 'package:flutter/material.dart';
import 'package:grav_chassis/app/my_app.dart';
import 'app/core/services/server.dart' as server;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializa o servidor
  server.main();

  runApp(const MyApp());
}
