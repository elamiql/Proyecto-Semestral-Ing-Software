import 'package:flutter/material.dart';
import 'package:proyecto_semestral_ing_software/screens/form_obj_encontrado.dart';
import 'ver_objetos_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recüper Dashboard"), centerTitle: true),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FormObjEncontrado(),
                        ),
                      );
                    },
                    child: const Text("Reportar Objeto Encontrado"),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: implementar pantalla para objeto perdido
                    },
                    child: const Text("Reportar Objeto Perdido"),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerObjetosScreen(),
                        ),
                      );
                    },
                    child: const Text("Ver Objetos"),
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(width: 2, color: Colors.black38),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Últimos Avisos",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          child: ListTile(
                            title: Text("Objeto de prueba $index"),
                            subtitle: const Text(
                              "Encontrado en Biblioteca - hace 5 min",
                            ),
                            leading: const Icon(Icons.pin_drop),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
