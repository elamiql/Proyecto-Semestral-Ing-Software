import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_semestral_ing_software/providers/auth_provider.dart';
import 'package:proyecto_semestral_ing_software/screens/registro_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final correoCtrl = TextEditingController();
  String error = "";

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Iniciar Sesión")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: correoCtrl,
              decoration: const InputDecoration(labelText: "Correo"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final ok = await auth.login(correoCtrl.text.trim());
                if (!ok) {
                  setState(() => error = "Correo no registrado");
                }
              },
              child: const Text("Ingresar"),
            ),
            if (error.isNotEmpty)
              Text(error, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            TextButton(
              child: const Text("Crear cuenta"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
