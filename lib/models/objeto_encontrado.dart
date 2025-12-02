import "dart:typed_data";

import "package:proyecto_semestral_ing_software/models/reporte.dart";

class ObjetoEncontrado extends Reporte {
  String dondeReclamar;
  ObjetoEncontrado({
    required super.id,
    required super.titulo,
    required super.ubicacion,
    required super.descripcion,
    required super.fechaReporte,
    required super.horaDePerdida,
    required super.correoUsuario,
    required super.categoria,
    required this.dondeReclamar,
    required super.imagenes,
    super.estado = 'Activo',
  });

  List<Uint8List>? get imagenesSeleccionadas => imagenes;
}
