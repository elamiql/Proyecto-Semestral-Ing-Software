import 'package:flutter/material.dart';

class VerObjetosScreen extends StatelessWidget {
  const VerObjetosScreen({super.key});

  
  Widget buildObjetoCard({
    required String que,
    required String donde,
    required String reclamar,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Qué
            Row(
              children: [
                const Icon(Icons.inventory_2_outlined, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Text(
                  "Objeto: $que",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Dónde
            Row(
              children: [
                const Icon(Icons.place_outlined, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  "Encontrado en: $donde",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Reclamar
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.call_outlined, color: Colors.orange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Reclamar en: $reclamar",
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Objetos Reportados"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Lista de objetos encontrados",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 🔹 Ejemplo de uso del método (por ahora estático)
            buildObjetoCard(
              que: "Mochila Negra",
              donde: "Biblioteca Central",
              reclamar: "Oficina de objetos perdidos (Edificio A, piso 1)",
            ),
            buildObjetoCard(
              que: "Paraguas Azul",
              donde: "Cafetería del Campus",
              reclamar: "Mostrador de información principal",
            ),

            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Próximamente se mostrarán todos los objetos registrados...",
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
