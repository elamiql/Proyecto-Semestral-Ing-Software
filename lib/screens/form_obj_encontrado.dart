import 'package:flutter/material.dart';
import 'package:proyecto_semestral_ing_software/models/objeto_Encontrado.dart';

class FormObjEncontrado extends StatefulWidget {
  const FormObjEncontrado({super.key});

  @override
  State<FormObjEncontrado> createState() => _FormObjEncontradoState();
}

class _FormObjEncontradoState extends State<FormObjEncontrado> {
  final _tituloController = TextEditingController();
  final _ubicacionController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _contactoController = TextEditingController();

  @override
  void dispose() {
    _tituloController.dispose();
    _ubicacionController.dispose();
    _descripcionController.dispose();
    _contactoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Formulario para reportar objetos encontrados"),
        centerTitle: true,
        bottomOpacity: .5,
        actions: [const SizedBox(width: 8)],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _tituloController,
                decoration: InputDecoration(
                  labelText: "Qué perdiste",
                  hintText: "Ej: Celular, llaves...",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 16),

              TextField(
                controller: _ubicacionController,
                decoration: InputDecoration(
                  labelText: "Dónde crees que lo perdiste",
                  hintText: "Ej: Los Patos, Biblioteca...",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 16),

              TextField(
                controller: _descripcionController,
                decoration: InputDecoration(
                  labelText: "Descripción detallada",
                  hintText: "Ej: iPhone 20 Pro Menos, carcasa roja...",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 16),

              TextField(
                controller: _contactoController,
                decoration: InputDecoration(
                  labelText: "Tu información de contacto",
                  hintText: "Ej: +56 9 1234 5678",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  String titulo = _tituloController.text;
                  String ubicacionDeEncuentro = _ubicacionController.text;
                  String descripcion = _descripcionController.text;
                  String ubicacionDeReclamo = _contactoController.text;

                  if (titulo.isNotEmpty &&
                      ubicacionDeEncuentro.isNotEmpty &&
                      ubicacionDeReclamo.isNotEmpty) {
                    ObjetoEncontrado nuevoReporte = ObjetoEncontrado(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      titulo: titulo,
                      ubicacion: ubicacionDeEncuentro,
                      descripcion: descripcion,
                      fechaReporte: DateTime.now(),
                      dondeReclamar: ubicacionDeReclamo,
                    );

                    _tituloController.clear();
                    _ubicacionController.clear();
                    _descripcionController.clear();
                    _contactoController.clear();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('¡Reporte enviado con éxito!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Por favor, rellena todos los campos.'),
                      ),
                    );
                  }
                },
                child: Text("Enviar Reporte de Pérdida"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
