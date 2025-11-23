import 'package:flutter/material.dart';
import 'package:proyecto_semestral_ing_software/models/reporte.dart'; // Asegúrate de importar esto
import 'package:proyecto_semestral_ing_software/models/objeto_encontrado.dart';
import 'package:proyecto_semestral_ing_software/models/objeto_perdido.dart';
import 'package:proyecto_semestral_ing_software/screens/detalle_objeto_screen.dart'; // Importamos la nueva pantalla

class ObjetoCard extends StatelessWidget {
  // Cambié dynamic a Reporte para que sea compatible con la pantalla de detalle, 
  // pero la lógica sigue igual.
  final Reporte obj; 

  const ObjetoCard({super.key, required this.obj});

  @override
  Widget build(BuildContext context) {
    String dondeLabel;
    String infoLabel;
    String info;

    if (obj is ObjetoEncontrado) {
      dondeLabel = "Encontrado en";
      infoLabel = "Reclamar en";
      // Hacemos cast para acceder a las propiedades específicas
      info = (obj as ObjetoEncontrado).dondeReclamar; 
    } else if (obj is ObjetoPerdido) {
      dondeLabel = "Perdido en";
      infoLabel = "Informacion de contacto";
      info = (obj as ObjetoPerdido).infoContacto;
    } else {
      dondeLabel = "Ubicacion";
      infoLabel = "informacion";
      info = "no disponible";
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12.0),
      // AQUÍ ESTÁ EL CAMBIO: Usamos InkWell para el clic
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Al hacer clic, nos vamos a la pantalla de detalle
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetalleObjetoScreen(objeto: obj),
            ),
          );
        },
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
                  Expanded( // Agregué Expanded para evitar overflow si el título es largo
                    child: Text(
                      "Objeto: ${obj.titulo}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
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
                      maxLines: 2, // Limite para que no rompa el diseño
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}