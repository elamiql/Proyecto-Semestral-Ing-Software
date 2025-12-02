import 'dart:typed_data';

abstract class Reporte {
  String id;
  String? estado;
  String titulo;
  String ubicacion;
  String descripcion;
  DateTime fechaReporte;
  String horaDePerdida;
  List<Uint8List> imagenes;
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
    required this.imagenes,
    this.estado = 'Activo',
  });
}
