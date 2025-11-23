import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_semestral_ing_software/providers/auth_provider.dart';
import 'package:proyecto_semestral_ing_software/providers/objetos_provider.dart';
import 'package:proyecto_semestral_ing_software/screens/login_page.dart';
import 'package:proyecto_semestral_ing_software/screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..cargarEstado()),
        ChangeNotifierProvider(create: (_) => ObjetosProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Recüper",
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (!auth.autenticado) {
            return const LoginScreen();
          }
          return const HomePage();
        },
      ),
    );
  }
}
