import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_semestral_ing_software/providers/auth_provider.dart';
import 'package:proyecto_semestral_ing_software/providers/objetos_provider.dart';
import 'package:proyecto_semestral_ing_software/models/reporte.dart';
import 'package:proyecto_semestral_ing_software/models/objeto_perdido.dart';
import 'package:proyecto_semestral_ing_software/models/objeto_encontrado.dart';
import 'package:proyecto_semestral_ing_software/screens/fullscreen_image.dart';
import 'package:proyecto_semestral_ing_software/screens/form_obj_encontrado.dart';
import 'package:proyecto_semestral_ing_software/screens/form_obj_perdido.dart';

class DetalleObjetoScreen extends StatelessWidget {
  final Reporte objeto;

  const DetalleObjetoScreen({super.key, required this.objeto});

  void _confirmarEliminacion(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Eliminar publicación?'),
        content: const Text(
          'Esta acción no se puede deshacer. ¿Estás seguro de que quieres eliminar este objeto?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Provider.of<ObjetosProvider>(context, listen: false)
                  .eliminarObjeto(objeto);
              Navigator.of(ctx).pop();

              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Publicación eliminada correctamente')),
              );
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final esDueno = auth.correo != null && auth.correo == objeto.correoUsuario;
    final tienePermiso = auth.esAdmin || esDueno;
    final esPerdido = objeto is ObjetoPerdido;
    final colorTema = esPerdido ? Colors.red : Colors.green;
    final tituloAppBar = esPerdido ? "Detalle Pérdida" : "Detalle Hallazgo";

    String infoEspecificaTitulo = "";
    String infoEspecificaValor = "";

    if (esPerdido) {
      infoEspecificaTitulo = "Contacto";
      infoEspecificaValor = (objeto as ObjetoPerdido).infoContacto;
    } else {
      infoEspecificaTitulo = "Dónde Reclamar";
      infoEspecificaValor = (objeto as ObjetoEncontrado).dondeReclamar;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(tituloAppBar),
        backgroundColor: colorTema,
        foregroundColor: Colors.white,
        actions: [
          if (tienePermiso)
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Modificar Objeto',
              onPressed: () {
                if (esPerdido) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FormObjPerdido(
                          objetoEditar: objeto as ObjetoPerdido
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FormObjEncontrado(
                          objetoEditar: objeto as ObjetoEncontrado
                      ),
                    ),
                  );
                }
              },
            ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Eliminar',
            onPressed: () => _confirmarEliminacion(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                if (objeto.imagenBytes != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImageScreen(
                        imageBytes: objeto.imagenBytes!,
                      ),
                    ),
                  );
                }
              },
              child: Container(
                width: double.infinity,
                height: 250,
                color: Colors.black87,
                child: objeto.imagenBytes != null
                    ? Image.memory(
                        objeto.imagenBytes!,
                        fit: BoxFit.contain,
                      )
                    : Icon(
                        Icons.image_not_supported,
                        size: 80,
                        color: Colors.grey[400],
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: colorTema.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: colorTema),
                    ),
                    child: Text(
                      objeto.categoria,
                      style: TextStyle(
                        color: colorTema,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    objeto.titulo,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        objeto.ubicacion,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.access_time,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        objeto.horaDePerdida,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: [
                        Text(
                          infoEspecificaTitulo.toUpperCase(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          infoEspecificaValor,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    "Descripción",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    objeto.descripcion,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
