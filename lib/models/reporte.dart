abstract class Reporte {
  String id;
  String titulo;
  String ubicacion;
  String descripcion;
  DateTime fechaReporte;

  Reporte({
    required this.id,
    required this.titulo,
    required this.ubicacion,
    required this.descripcion,
    required this.fechaReporte,
  });
}
