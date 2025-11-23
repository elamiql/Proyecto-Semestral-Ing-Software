import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_semestral_ing_software/providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final correo = TextEditingController();
  final nombre = TextEditingController();
  final matricula = TextEditingController();
  final telefono = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Crear Cuenta")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(decoration: const InputDecoration(labelText: "Correo"), controller: correo),
            TextField(decoration: const InputDecoration(labelText: "Nombre Completo"), controller: nombre),
            TextField(decoration: const InputDecoration(labelText: "Matrícula"), controller: matricula),
            TextField(decoration: const InputDecoration(labelText: "Teléfono"), controller: telefono),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await auth.registrarUsuario(
                  correo: correo.text.trim(),
                  nombre: nombre.text.trim(),
                  matricula: matricula.text.trim(),
                  telefono: telefono.text.trim(),
                );
                Navigator.pop(context);
              },
              child: const Text("Registrar"),
            ),
          ],
        ),
      ),
    );
  }
}

