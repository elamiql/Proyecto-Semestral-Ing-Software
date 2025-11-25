import 'dart:typed_data';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_semestral_ing_software/models/objeto_encontrado.dart';
import 'package:proyecto_semestral_ing_software/providers/objetos_provider.dart';
import 'package:proyecto_semestral_ing_software/providers/auth_provider.dart';
import 'package:proyecto_semestral_ing_software/utils/categorias.dart';
import 'package:proyecto_semestral_ing_software/theme/app_theme.dart';
import 'package:proyecto_semestral_ing_software/widgets/image_selector.dart';
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

  Uint8List? _imagenBytes;
  String? _categoriaSel;
  final ImagePicker _picker = ImagePicker();

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
      _imagenBytes = obj.imagenBytes;
    }
  }

  Future<void> _pickImage() async {
    final XFile? img = await _picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      final bytes = await img.readAsBytes();
      setState(() => _imagenBytes = bytes);
    }
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
      imagenBytes: _imagenBytes,
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

              ImageSelector(imagenBytes: _imagenBytes, onTap: _pickImage),
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
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
