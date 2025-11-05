import 'package:flutter/material.dart';
// --- AÑADIDOS ---
import 'package:provider/provider.dart';
import 'package:proyecto_semestral_ing_software/providers/objetos_provider.dart';
// Asegúrate de que esta ruta sea correcta
import 'package:proyecto_semestral_ing_software/widgets/objeto_card.dart';
// --- FIN AÑADIDOS ---

import 'package:proyecto_semestral_ing_software/screens/form_obj_encontrado.dart';
import 'package:proyecto_semestral_ing_software/screens/form_obj_perdido.dart';
import 'ver_objetos_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final objetosProvider = Provider.of<ObjetosProvider>(context);
    final todosLosObjetos = objetosProvider.objetos;
    final ultimosObjetos = todosLosObjetos.reversed.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Recüper",
          style: TextStyle(color: Colors.white70, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 57, 102),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4.0,
                margin: const EdgeInsets.all(4.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(
                        child: Text(
                          "Categorias",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                      ),
                      const SizedBox(height: 12),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FormObjPerdido(),
                            ),
                          );
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
                    child: ultimosObjetos.isEmpty
                        ? const Center(
                            child: Text(
                              "No hay avisos recientes.",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount:
                                ultimosObjetos.length,
                            itemBuilder: (context, index) {
                              final obj = ultimosObjetos[index];

                              return ObjetoCard(obj: obj);
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
