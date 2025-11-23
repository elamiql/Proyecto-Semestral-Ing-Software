import 'package:proyecto_semestral_ing_software/user_models/usuario.dart';

class Admin extends Usuario {
  int idAdmin;
  String oficina;

  Admin({
    required super.idUsuario,
    required super.nombre,
    required super.correoUdec,
    required super.password,
    required this.idAdmin,
    required this.oficina,
  });

  void hacerMatch() {}
  void archivar() {}
  void eliminarObjeto() {}
}
