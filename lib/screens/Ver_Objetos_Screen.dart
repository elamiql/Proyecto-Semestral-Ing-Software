import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_semestral_ing_software/models/objeto_perdido.dart';
import 'package:proyecto_semestral_ing_software/providers/objetos_provider.dart';
import 'package:proyecto_semestral_ing_software/models/reporte.dart';
import 'package:proyecto_semestral_ing_software/models/objeto_encontrado.dart';

class VerObjetosScreen extends StatelessWidget {
  const VerObjetosScreen({super.key});

  Widget buildObjetoCard({
    required String que,
    required String dondeLabel,
    required String donde,
    required String infoLabel,
    required String info,
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
            Row(
              children: [
                const Icon(Icons.place_outlined, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  "$dondeLabel: $donde",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.call_outlined, color: Colors.orange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "$infoLabel : $info",
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
    final objetosProvider = Provider.of<ObjetosProvider>(context);
    final objetos = objetosProvider.objetos;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Objetos Reportados"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: objetos.isEmpty
            ? const Center(
                child: Text(
                  "No hay objetos registrados aún.",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              )
            : ListView.builder(
                itemCount: objetos.length,
                itemBuilder: (context, index) {
                  final obj = objetos[index];

                  // Detectar tipo de reporte
                  String dondeLabel;
                  String infoLabel;
                  String info;
                  if (obj is ObjetoEncontrado) {
                    dondeLabel = "Encontrado en";
                    infoLabel = "Reclamar en";
                    info = obj.dondeReclamar;
                  } else if(obj is ObjetoPerdido) {
                    dondeLabel = "Perdido en";
                    infoLabel = "Informacion de contacto";
                    info = obj.infoContacto;
                  } else {
                    dondeLabel = "Ubicacion";
                    infoLabel = "informacion";
                    info = "no disponible";
                  }
                  return buildObjetoCard(
                    que: obj.titulo,
                    dondeLabel: dondeLabel,
                    donde: obj.ubicacion,
                    infoLabel: infoLabel,
                    info: info,
                  );
                },
              ),
      ),
    );
  }
}
