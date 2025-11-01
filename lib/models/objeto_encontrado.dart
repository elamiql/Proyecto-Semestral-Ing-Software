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
    required this.dondeReclamar,
    super.imagenBytes,
  });
}
