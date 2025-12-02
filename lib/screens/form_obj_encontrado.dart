import 'dart:typed_data';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_semestral_ing_software/models/objeto_encontrado.dart';
import 'package:proyecto_semestral_ing_software/providers/objetos_provider.dart';
import 'package:proyecto_semestral_ing_software/providers/auth_provider.dart';
import 'package:proyecto_semestral_ing_software/utils/categorias.dart';
import 'package:proyecto_semestral_ing_software/theme/app_theme.dart';
// import 'package:proyecto_semestral_ing_software/widgets/image_selector.dart'; // YA NO LO NECESITAMOS SI USAMOS EL MANUAL
import 'package:proyecto_semestral_ing_software/utils/form_utils.dart';

class FormObjEncontrado extends StatefulWidget {
  final ObjetoEncontrado? objetoEditar;
  const FormObjEncontrado({super.key, this.objetoEditar});
  @override
  State<FormObjEncontrado> createState() => _FormObjEncontradoState();
}

class _FormObjEncontradoState extends State<FormObjEncontrado> {
  final _tituloCtrl = TextEditingController();
  final _ubicacionCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _dondeReclamarCtrl = TextEditingController();
  final _horaCtrl = TextEditingController();

  // CORRECCIÓN 1: Inicializar lista vacía, no nula
  List<Uint8List> _imagenesSeleccionadas = [];
  String? _categoriaSel;
  // final ImagePicker _picker = ImagePicker(); // No es necesario instanciarlo aquí arriba

  @override
  void initState() {
    super.initState();
    if (widget.objetoEditar != null) {
      final obj = widget.objetoEditar!;
      _tituloCtrl.text = obj.titulo;
      _ubicacionCtrl.text = obj.ubicacion;
      _descCtrl.text = obj.descripcion;
      _dondeReclamarCtrl.text = obj.dondeReclamar;
      _horaCtrl.text = obj.horaDePerdida;
      _categoriaSel = obj.categoria;

      // CORRECCIÓN 2: Usar el nombre correcto del modelo 'imagenes' y crear una copia
      _imagenesSeleccionadas = List.from(obj.imagenes);
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      for (var file in pickedFiles) {
        final bytes = await file.readAsBytes();
        setState(() {
          _imagenesSeleccionadas.add(bytes);
        });
      }
    }
  }

  void _removerImagen(int index) {
    setState(() {
      _imagenesSeleccionadas.removeAt(index);
    });
  }

  Future<void> _pickTime() async {
    final hora = await FormUtils.seleccionarHora(context);
    if (hora != null) {
      setState(() => _horaCtrl.text = hora);
    }
  }

  void _enviar() {
    if (_tituloCtrl.text.isEmpty ||
        _ubicacionCtrl.text.isEmpty ||
        _dondeReclamarCtrl.text.isEmpty ||
        _categoriaSel == null) {
      FormUtils.showSnackBar(
        context,
        "Por favor, completa los campos obligatorios",
        isError: true,
      );
      return;
    }

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final esEdicion = widget.objetoEditar != null;

    final nuevo = ObjetoEncontrado(
      id: esEdicion
          ? widget.objetoEditar!.id
          : DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: _tituloCtrl.text,
      ubicacion: _ubicacionCtrl.text,
      descripcion: _descCtrl.text,
      fechaReporte: esEdicion
          ? widget.objetoEditar!.fechaReporte
          : DateTime.now(),
      horaDePerdida: _horaCtrl.text,
      correoUsuario: esEdicion
          ? widget.objetoEditar!.correoUsuario
          : (auth.correo ?? ''),
      categoria: _categoriaSel!,
      dondeReclamar: _dondeReclamarCtrl.text,
      imagenes: _imagenesSeleccionadas, // Pasamos la lista
    );

    final provider = Provider.of<ObjetosProvider>(context, listen: false);

    if (esEdicion) {
      provider.editarObjeto(nuevo);
      FormUtils.showSnackBar(context, "Hallazgo actualizado correctamente");
    } else {
      provider.agregarObjeto(nuevo);
      FormUtils.showSnackBar(context, "Hallazgo reportado con éxito");
    }

    Navigator.pop(context);
  }

  // WIDGET MANUAL DE GALERÍA (Para asegurar que funcione el borrar)
  Widget _buildGaleriaSeleccionada() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Botón para agregar
        OutlinedButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.add_photo_alternate),
          label: Text("Agregar Fotos (${_imagenesSeleccionadas.length})"),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const SizedBox(height: 12),

        // Lista horizontal de fotos
        if (_imagenesSeleccionadas.isNotEmpty)
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _imagenesSeleccionadas.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 12, top: 6),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: MemoryImage(_imagenesSeleccionadas[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: GestureDetector(
                        onTap: () => _removerImagen(index),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.objetoEditar != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          esEdicion ? "Editar Hallazgo" : "Reportar Hallazgo",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!esEdicion) _buildAlertBanner(),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: _categoriaSel,
                decoration: AppTheme.inputDecoration(
                  label: "Categoría *",
                  icon: Icons.category_outlined,
                ),
                items: Categorias.lista
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _categoriaSel = v),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _tituloCtrl,
                textCapitalization: TextCapitalization.sentences,
                decoration: AppTheme.inputDecoration(
                  label: "Qué encontraste *",
                  icon: Icons.inventory_2_outlined,
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _ubicacionCtrl,
                textCapitalization: TextCapitalization.sentences,
                decoration: AppTheme.inputDecoration(
                  label: "Ubicación *",
                  icon: Icons.place_outlined,
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _horaCtrl,
                readOnly: true,
                onTap: _pickTime,
                decoration: AppTheme.inputDecoration(
                  label: "Hora del hallazgo",
                  icon: Icons.access_time,
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _dondeReclamarCtrl,
                textCapitalization: TextCapitalization.sentences,
                decoration: AppTheme.inputDecoration(
                  label: "Dónde reclamar *",
                  icon: Icons.pin_drop_outlined,
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _descCtrl,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: AppTheme.inputDecoration(
                  label: "Descripción",
                  icon: Icons.description_outlined,
                ),
              ),
              const SizedBox(height: 24),

              // CORRECCIÓN 3: Usamos el widget local para manejar borrado
              _buildGaleriaSeleccionada(),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _enviar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  esEdicion ? "GUARDAR CAMBIOS" : "PUBLICAR HALLAZGO",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlertBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green),
      ),
      child: const Row(
        children: [
          Icon(Icons.check_circle_outline, color: Colors.green),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Estás reportando un objeto ENCONTRADO.",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
