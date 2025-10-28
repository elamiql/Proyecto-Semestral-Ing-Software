import 'package:proyecto_semestral_ing_software/models/reporte.dart';

class ObjetoPerdido extends Reporte {
  String infoContacto;
  ObjetoPerdido({
    required super.id,
    required super.titulo,
    required super.ubicacion,
    required super.descripcion,
    required super.fechaReporte,
    required this.infoContacto,
  });
}
