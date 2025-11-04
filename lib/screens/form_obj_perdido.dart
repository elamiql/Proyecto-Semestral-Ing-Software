import 'dart:typed_data';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_semestral_ing_software/models/objeto_perdido.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_semestral_ing_software/providers/objetos_provider.dart';

class FormObjPerdido extends StatefulWidget {
  const FormObjPerdido({super.key});

  @override
  State<FormObjPerdido> createState() => _FormObjPerdidoState();
}

class _FormObjPerdidoState extends State<FormObjPerdido> {
  final _tituloController = TextEditingController();
  final _ubicacionController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _contactoController = TextEditingController();
  final _horaDePerdidaController = TextEditingController();
  Uint8List? _imagenBytes;
  final ImagePicker _picker = ImagePicker();

  Future<void> _seleccionarImagen() async {
    final XFile? imagen = await _picker.pickImage(source: ImageSource.gallery);
    if (imagen == null) return;
    final bytes = await imagen.readAsBytes();
    setState(() {
      _imagenBytes = bytes;
    });
  }

  void _enviarReporte() {
    if (_tituloController.text.isEmpty ||
        _ubicacionController.text.isEmpty ||
        _contactoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Por favor, rellene titulo, ubicacion y donde reclamar",
          ),
        ),
      );
      return;
    }

    final nuevoReporte = ObjetoPerdido(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: _tituloController.text,
      ubicacion: _ubicacionController.text,
      descripcion: _descripcionController.text,
      fechaReporte: DateTime.now(),
      horaDePerdida: _horaDePerdidaController.text,
      infoContacto: _contactoController.text,
      imagenBytes: _imagenBytes,
    );

    Provider.of<ObjetosProvider>(
      context,
      listen: false,
    ).agregarObjeto(nuevoReporte);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Reporte enviado con exito")));

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _ubicacionController.dispose();
    _descripcionController.dispose();
    _contactoController.dispose();
    _horaDePerdidaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Formulario para reportar objetos perdidos"),
        centerTitle: true,
        bottomOpacity: .5,
        actions: [const SizedBox(width: 8)],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 16),
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
                  labelText: "Dónde lo perdiste",
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
                controller: _horaDePerdidaController,
                decoration: InputDecoration(
                  labelText: "Hora aproximada de perdida",
                  hintText: "Ej: Aprox 20:00, etc",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 16),

              TextField(
                controller: _contactoController,
                decoration: InputDecoration(
                  labelText: "informacion de contacto",
                  hintText: "Ej: +56 9 1234 5678",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 16),

              Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),

                child: _imagenBytes == null
                    ? const Center(
                  child: Text("Aún no has seleccionado una imagen."),
                )
                    : Image.memory(_imagenBytes!, fit: BoxFit.contain),
              ),

              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _seleccionarImagen,
                icon: const Icon(Icons.image),
                label: const Text("Seleccionar Imagen de Galería"),
              ),

              SizedBox(height: 24),

              ElevatedButton(
                onPressed: _enviarReporte,
                child: Text("Enviar Reporte de perdida"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
