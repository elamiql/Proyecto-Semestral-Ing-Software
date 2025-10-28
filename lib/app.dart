import 'package:flutter/material.dart';
import 'package:proyecto_semestral_ing_software/screens/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recüper',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
