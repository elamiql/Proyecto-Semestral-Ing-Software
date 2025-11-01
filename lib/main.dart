import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_semestral_ing_software/app.dart';
import 'package:proyecto_semestral_ing_software/providers/objetos_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ObjetosProvider(),
      child: const MyApp(),
    ),
  );
}
