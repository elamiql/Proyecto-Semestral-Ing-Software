import 'dart:typed_data';

abstract class Reporte {
  String id;
  String estado;
  String titulo;
  String ubicacion;
  String descripcion;
  DateTime fechaReporte;
  String horaDePerdida;
  Uint8List? imagenBytes;
  String correoUsuario;
  String categoria;

  Reporte({
    required this.id,
    required this.titulo,
    required this.ubicacion,
    required this.descripcion,
    required this.fechaReporte,
    required this.horaDePerdida,
    required this.correoUsuario,
    required this.categoria,
    this.imagenBytes,
    this.estado = 'ABIERTO',
  });
}
