import 'package:proyecto_semestral_ing_software/models/reporte.dart';

class ObjetoPerdido extends Reporte {
  String infoContacto;
  String? idObjetoVinculado;
  ObjetoPerdido({
    required super.id,
    required super.titulo,
    required super.ubicacion,
    required super.descripcion,
    required super.fechaReporte,
    required super.horaDePerdida,
    required super.correoUsuario,
    required super.categoria,
    required this.infoContacto,
    this.idObjetoVinculado,
    super.imagenBytes,
    super.estado = 'ABIERTO',
  });
}
