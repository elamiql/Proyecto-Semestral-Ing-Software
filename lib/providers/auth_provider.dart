import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto_semestral_ing_software/user_models/usuario.dart';
import 'package:proyecto_semestral_ing_software/user_models/admin.dart';

class AuthProvider with ChangeNotifier {
  Usuario? _usuarioActual;
  bool _autenticado = false;

  bool get autenticado => _autenticado;
  Usuario? get usuarioActual => _usuarioActual;

  bool get esAdmin => _usuarioActual is Admin;

  String? get nombre => _usuarioActual?.nombre;
  String? get correo => _usuarioActual?.correoUdec;

  Future<void> cargarEstado() async {
    final prefs = await SharedPreferences.getInstance();
    final correoGuardado = prefs.getString('correo');
    final authState = prefs.getBool('autenticado') ?? false;

    if (authState && correoGuardado != null) {
      if (correoGuardado == 'admin@udec.cl') {
        _usuarioActual = Admin(
          idUsuario: 1,
          nombre: 'Administrador Principal',
          correoUdec: correoGuardado,
          password: '***',
          idAdmin: 1,
          oficina: 'Oficina de Software 202',
        );
        _autenticado = true;
      } else {
        final nombreGuardado = prefs.getString('nombre') ?? 'Usuario';
        final matriculaGuardada = prefs.getString('matricula');
        int idDesdeMatricula = int.tryParse(matriculaGuardada ?? '0') ?? 0;

        _usuarioActual = Usuario(
          idUsuario: idDesdeMatricula,
          nombre: nombreGuardado,
          correoUdec: correoGuardado,
          password: '',
        );
        _autenticado = true;
      }
    }
    notifyListeners();
  }

  Future<void> registrarUsuario({
    required String correo,
    required String nombre,
    required String matricula,
    required String telefono,
    required String password,
  }) async {
    if (!correo.endsWith("@udec.cl")) throw Exception('Debe ser correo UdeC');

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('correo', correo);
    await prefs.setString('nombre', nombre);

    await prefs.setString('matricula', matricula);

    await prefs.setString('telefono', telefono);
    await prefs.setString('password', password);
    await prefs.setBool('autenticado', false);

    _autenticado = false;
    _usuarioActual = null;
    notifyListeners();
  }

  Future<void> login(String correo, String password) async {
    if (correo == 'admin@udec.cl' && password == 'admin123') {

      _usuarioActual = Admin(
        idUsuario: 1,
        nombre: 'Administrador',
        correoUdec: correo,
        password: password,
        idAdmin: 777,
        oficina: 'Edificio Sistemas - Of. 304',
      );

      _autenticado = true;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('correo', correo);
      await prefs.setString('nombre', _usuarioActual!.nombre);
      await prefs.setBool('autenticado', true);

      notifyListeners();
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final correoGuardado = prefs.getString('correo');
    final passwordGuardada = prefs.getString('password');
    final matriculaGuardada = prefs.getString('matricula');

    if (correoGuardado == null) throw Exception('Usuario no registrado');
    if (correoGuardado != correo) throw Exception('Correo incorrecto');
    if (passwordGuardada != password) throw Exception('Contraseña incorrecta');
    int idDesdeMatricula = int.tryParse(matriculaGuardada ?? '0') ?? 0;

    _usuarioActual = Usuario(
      idUsuario: idDesdeMatricula,
      nombre: prefs.getString('nombre') ?? 'Estudiante',
      correoUdec: correo,
      password: password,
    );

    _autenticado = true;
    await prefs.setBool('autenticado', true);
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('autenticado', false);
    _usuarioActual = null;
    _autenticado = false;
    notifyListeners();
  }

  Future<void> eliminarCuenta() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();


    _usuarioActual = null;
    _autenticado = false;

    notifyListeners();
  }
}
