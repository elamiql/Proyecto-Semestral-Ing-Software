import 'package:flutter/material.dart';
import 'package:proyecto_semestral_ing_software/models/objeto_encontrado.dart';
import 'package:proyecto_semestral_ing_software/models/objeto_perdido.dart';

class ObjetoCard extends StatelessWidget {
  final dynamic obj;

  const ObjetoCard({super.key, required this.obj});

  @override
  Widget build(BuildContext context) {
    String dondeLabel;
    String infoLabel;
    String info;

    if (obj is ObjetoEncontrado) {
      dondeLabel = "Encontrado en";
      infoLabel = "Reclamar en";
      info = obj.dondeReclamar;
    } else if (obj is ObjetoPerdido) {
      dondeLabel = "Perdido en";
      infoLabel = "Informacion de contacto";
      info = obj.infoContacto;
    } else {
      dondeLabel = "Ubicacion";
      infoLabel = "informacion";
      info = "no disponible";
    }
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.inventory_2_outlined,
                  color: Colors.blueAccent,
                ),
                const SizedBox(width: 8),
                Text(
                  "Objeto: ${obj.titulo}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.place_outlined, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  "$dondeLabel: ${obj.ubicacion}",
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
}
