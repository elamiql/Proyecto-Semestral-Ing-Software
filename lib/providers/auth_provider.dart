import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _correo;
  String? _nombre;
  bool _autenticado = false;

  String? get correo => _correo;
  String? get nombre => _nombre;
  bool get autenticado => _autenticado;

  Future<void> cargarEstado() async {
    final prefs = await SharedPreferences.getInstance();
    _correo = prefs.getString('correo');
    _nombre = prefs.getString('nombre');
    _autenticado = (prefs.getBool('autenticado') ?? false) && _correo != null;
    notifyListeners();
  }

  Future<void> registrarUsuario({
    required String correo,
    required String nombre,
    required String matricula,
    required String telefono,
    required String password,
  }) async {
    if (!correo.endsWith("@udec.cl")) {
      throw Exception('Debes usar un correo @udec.cl');
    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('correo', correo);
    await prefs.setString('nombre', nombre);
    await prefs.setString('matricula', matricula);
    await prefs.setString('telefono', telefono);
    await prefs.setString('password', password);
    await prefs.setBool('autenticado', false);

    _correo = correo;
    _nombre = nombre;
    _autenticado = false;
    notifyListeners();
  }

  Future<void> login(String correo, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final correoGuardado = prefs.getString('correo');
    final passwordGuardada = prefs.getString('password');

    if (correoGuardado == null) {
      throw Exception('Usuario no registrado');
    }

    if (correoGuardado != correo) {
      throw Exception('Correo incorrecto');
    }

    if (passwordGuardada != password) {
      throw Exception('Contraseña incorrecta');
    }

    _correo = correo;
    _nombre = prefs.getString('nombre');
    _autenticado = true;
    await prefs.setBool('autenticado', true);
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('autenticado', false);
    _autenticado = false;
    notifyListeners();
  }

  Future<void> eliminarCuenta() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _correo = null;
    _nombre = null;
    _autenticado = false;
    notifyListeners();
  }
}
