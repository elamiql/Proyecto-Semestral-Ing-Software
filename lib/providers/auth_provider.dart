import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthProvider with ChangeNotifier {
  String? _correo;
  bool _autenticado = false;

  String? get correo => _correo;
  bool get autenticado => _autenticado;


  Future<void> cargarEstado() async {
    final prefs = await SharedPreferences.getInstance();
    _correo = prefs.getString('correo');
    _autenticado = _correo != null;
    notifyListeners();
  }

  Future<bool> registrarUsuario({
  required String correo,
  required String nombre,
  required String matricula,
  required String telefono,
}) async {
  
  if (!correo.endsWith("@udec.cl")) {
    return false;  
  }

  final prefs = await SharedPreferences.getInstance();

  await prefs.setString('correo', correo);
  await prefs.setString('nombre', nombre);
  await prefs.setString('matricula', matricula);
  await prefs.setString('telefono', telefono);

  _correo = correo;
  _autenticado = false;
  notifyListeners();

  return true;
}




  
  Future<bool> login(String correo) async {
    final prefs = await SharedPreferences.getInstance();
    final registrado = prefs.getString('correo');

    if (registrado == correo) {
      _correo = correo;
      _autenticado = true;
      notifyListeners();
      return true;
    }

    return false;
  }


  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _correo = null;
    _autenticado = false;
    notifyListeners();
  }
}
