import 'dart:typed_data';

abstract class Reporte {
  String id;
  String titulo;
  String ubicacion;
  String descripcion;
  DateTime fechaReporte;
  String horaDePerdida;
  Uint8List? imagenBytes;

  Reporte({
    required this.id,
    required this.titulo,
    required this.ubicacion,
    required this.descripcion,
    required this.fechaReporte,
    required this.horaDePerdida,
    this.imagenBytes
  });
}
