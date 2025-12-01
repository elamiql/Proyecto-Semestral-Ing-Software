import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_semestral_ing_software/models/objeto_encontrado.dart';
import 'package:proyecto_semestral_ing_software/providers/objetos_provider.dart';

class VincularObjetoScreen extends StatelessWidget {
  final String idObjetoPerdido;

  const VincularObjetoScreen({super.key, required this.idObjetoPerdido});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ObjetosProvider>(context);

    final hallazgos = provider.objetos.whereType<ObjetoEncontrado>().toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Vincular con Hallazgo")),
      body: hallazgos.isEmpty
          ? const Center(child: Text("No hay objetos encontrados registrados"))
          : ListView.builder(
        itemCount: hallazgos.length,
        itemBuilder: (ctx, i) {
          final hallazgo = hallazgos[i];
          return ListTile(
            leading: const Icon(Icons.check_circle_outline, color: Colors.green),
            title: Text(hallazgo.titulo),
            subtitle: Text(hallazgo.ubicacion),
            trailing: const Icon(Icons.link),
            onTap: () {
              provider.vincularObjetos(idObjetoPerdido, hallazgo.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("¡Objetos vinculados!")),
              );
            },
          );
        },
      ),
    );
  }
}