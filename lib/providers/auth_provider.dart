import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthProvider with ChangeNotifier {
  String? _correo;
  bool _autenticado = false;

  String? get correo => _correo;
  bool get autenticado => _autenticado;

  // Cargar datos al iniciar app
  Future<void> cargarEstado() async {
    final prefs = await SharedPreferences.getInstance();
    _correo = prefs.getString('correo');
    _autenticado = _correo != null;
    notifyListeners();
  }

  Future<void> registrarUsuario({
  required String correo,
  required String nombre,
  required String matricula,
  required String telefono,
}) async {
  final prefs = await SharedPreferences.getInstance();

  // Guardamos información del usuario
  await prefs.setString('correo', correo);
  await prefs.setString('nombre', nombre);
  await prefs.setString('matricula', matricula);
  await prefs.setString('telefono', telefono);

  // ❗ NO loguear aquí
  _correo = null;
  _autenticado = false;

  notifyListeners();
}


  // Login simple con correo
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

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _correo = null;
    _autenticado = false;
    notifyListeners();
  }
}
