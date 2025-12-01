import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:proyecto_semestral_ing_software/models/reporte.dart';
import 'package:proyecto_semestral_ing_software/models/objeto_perdido.dart';
import 'package:proyecto_semestral_ing_software/models/objeto_encontrado.dart';

class ObjetosProvider with ChangeNotifier {
  final List<Reporte> _objetos = [];

  ObjetosProvider() {
    _cargarObjetosPorDefecto();
  }

  void _cargarObjetosPorDefecto() {
    // Objetos Perdidos
    _objetos.addAll([
      ObjetoPerdido(
        id: '1',
        titulo: 'iPhone 14 Pro',
        ubicacion: 'Biblioteca Central',
        descripcion:
            'iPhone 14 Pro color morado con funda transparente. Tiene un sticker de la UdeC en la parte trasera.',
        fechaReporte: DateTime.now().subtract(const Duration(days: 2)),
        horaDePerdida: '14:30',
        correoUsuario: 'juan.perez@udec.cl',
        categoria: 'Electrónicos',
        infoContacto: '+56 9 8765 4321',
      ),
      ObjetoPerdido(
        id: '2',
        titulo: 'Carnet Universitario',
        ubicacion: 'Facultad de Ingeniería',
        descripcion:
            'Carnet universitario a nombre de María González, con cinta azul.',
        fechaReporte: DateTime.now().subtract(const Duration(days: 1)),
        horaDePerdida: '10:00',
        correoUsuario: 'maria.gonzalez@udec.cl',
        categoria: 'Documentos',
        infoContacto: 'maria.gonzalez@udec.cl',
      ),
      ObjetoPerdido(
        id: '3',
        titulo: 'Llavero con 5 llaves',
        ubicacion: 'Gimnasio UdeC',
        descripcion:
            'Llavero metálico con forma de guitarra, incluye 5 llaves y un pendrive pequeño.',
        fechaReporte: DateTime.now().subtract(const Duration(hours: 5)),
        horaDePerdida: '18:00',
        correoUsuario: 'pedro.soto@udec.cl',
        categoria: 'Llaves',
        infoContacto: '+56 9 7654 3210',
      ),
      ObjetoPerdido(
        id: '4',
        titulo: 'Mochila Negra North Face',
        ubicacion: 'Los Patos',
        descripcion:
            'Mochila negra marca North Face con un parche de Iron Maiden. Contiene cuadernos de Cálculo.',
        fechaReporte: DateTime.now().subtract(const Duration(days: 3)),
        horaDePerdida: '12:00',
        correoUsuario: 'carlos.ruiz@udec.cl',
        categoria: 'Mochilas y Bolsos',
        infoContacto: '+56 9 6543 2109',
      ),
      ObjetoPerdido(
        id: '5',
        titulo: 'Calculadora Científica',
        ubicacion: 'Sala C301',
        descripcion:
            'Calculadora Casio fx-991 con mi nombre escrito en la parte de atrás (A. Muñoz).',
        fechaReporte: DateTime.now().subtract(const Duration(hours: 3)),
        horaDePerdida: '09:15',
        correoUsuario: 'andrea.munoz@udec.cl',
        categoria: 'Libros y Útiles',
        infoContacto: 'andrea.munoz@udec.cl',
      ),
    ]);

    // Objetos Encontrados
    _objetos.addAll([
      ObjetoEncontrado(
        id: '6',
        titulo: 'Audífonos Bluetooth Sony',
        ubicacion: 'Cafetería Central',
        descripcion:
            'Audífonos inalámbricos Sony color negro, encontrados en una mesa junto a la ventana.',
        fechaReporte: DateTime.now().subtract(const Duration(hours: 8)),
        horaDePerdida: '13:00',
        correoUsuario: 'lucia.torres@udec.cl',
        categoria: 'Electrónicos',
        dondeReclamar: 'Conserjería Facultad de Ciencias',
      ),
      ObjetoEncontrado(
        id: '7',
        titulo: 'Polera Roja con Logo de Ingeniería',
        ubicacion: 'Cancha de Fútbol',
        descripcion:
            'Polera deportiva roja con el logo de Ingeniería Civil. Talla L.',
        fechaReporte: DateTime.now().subtract(const Duration(days: 1)),
        horaDePerdida: '17:30',
        correoUsuario: 'diego.vera@udec.cl',
        categoria: 'Ropa y Accesorios',
        dondeReclamar: 'Centro de alumnos Ingeniería',
      ),
      ObjetoEncontrado(
        id: '8',
        titulo: 'Tarjeta BIP',
        ubicacion: 'Paradero Los Patos',
        descripcion: 'Tarjeta BIP verde con sticker de Baby Yoda.',
        fechaReporte: DateTime.now().subtract(const Duration(hours: 12)),
        horaDePerdida: '08:30',
        correoUsuario: 'test@udec.cl',
        categoria: 'Tarjetas',
        dondeReclamar: 'Oficina de asuntos estudiantiles',
      ),
      ObjetoEncontrado(
        id: '9',
        titulo: 'Libro "Fundamentos de Programación"',
        ubicacion: 'Sala de Estudio B',
        descripcion:
            'Libro de programación en Python, tiene notas y subrayados. En la primera página dice "Propiedad de J. Silva".',
        fechaReporte: DateTime.now().subtract(const Duration(days: 2)),
        horaDePerdida: '20:00',
        correoUsuario: 'test@udec.cl',
        categoria: 'Libros y Útiles',
        dondeReclamar: 'Biblioteca, mostrador de préstamos',
      ),
      ObjetoEncontrado(
        id: '10',
        titulo: 'Reloj Casio Digital',
        ubicacion: 'Baño 2do piso Ingeniería',
        descripcion:
            'Reloj Casio digital plateado con correa negra. Marca las 15:42.',
        fechaReporte: DateTime.now().subtract(const Duration(hours: 6)),
        horaDePerdida: '11:00',
        correoUsuario: 'test@udec.cl',
        categoria: 'Joyas',
        dondeReclamar: 'Conserjería Edificio Ingeniería',
      ),
      ObjetoEncontrado(
        id: '11',
        titulo: 'Botella de Agua Metálica',
        ubicacion: 'Sala de Computación',
        descripcion:
            'Botella metálica azul con calcomanías de bandas de rock. Marca "Hydroflask".',
        fechaReporte: DateTime.now().subtract(const Duration(hours: 2)),
        horaDePerdida: '16:00',
        correoUsuario: 'test@udec.cl',
        categoria: 'Otros',
        dondeReclamar: 'Secretaría del departamento',
      ),
    ]);
  }

  UnmodifiableListView<Reporte> get objetos => UnmodifiableListView(_objetos);

  List<Reporte> obtenerReportesPorUsuario(String correo) {
    return _objetos.where((obj) => obj.correoUsuario == correo).toList();
  }

  List<Reporte> filtrarObjetos({String? busqueda, String? categoria}) {
    var resultados = _objetos;

    if (categoria != null && categoria.isNotEmpty && categoria != 'Todas') {
      resultados = resultados
          .where((obj) => obj.categoria == categoria)
          .toList();
    }

    if (busqueda != null && busqueda.isNotEmpty) {
      final busquedaLower = busqueda.toLowerCase();
      resultados = resultados.where((obj) {
        return obj.titulo.toLowerCase().contains(busquedaLower) ||
            obj.descripcion.toLowerCase().contains(busquedaLower) ||
            obj.ubicacion.toLowerCase().contains(busquedaLower);
      }).toList();
    }

    return resultados;
  }

  void agregarObjeto(Reporte objeto) {
    _objetos.add(objeto);
    notifyListeners();
  }

  void eliminarObjeto(Reporte objeto) {
    _objetos.remove(objeto);
    notifyListeners();
  }

  void editarObjeto(Reporte objetoEditado) {
    final index = _objetos.indexWhere((obj) => obj.id == objetoEditado.id);

    if (index != -1) {
      _objetos[index] = objetoEditado;
      notifyListeners();
    } else {
      print("Error: No se encontró el objeto con id ${objetoEditado
          .id} para editar.");
    }
  }

  Reporte? obtenerObjetoPorId(String id) {
    try {
      return _objetos.firstWhere((obj) => obj.id == id);
    } catch (e) {
      return null;
    }
  }

  void vincularObjetos(String idPerdido, String idEncontrado) {
    final index = _objetos.indexWhere((obj) => obj.id == idPerdido);

    if (index != -1 && _objetos[index] is ObjetoPerdido) {
      final objActual = _objetos[index] as ObjetoPerdido;
      objActual.idObjetoVinculado = idEncontrado;

      notifyListeners();
    }
  }

  List<Reporte> get objetosVisibles {
    return _objetos.where((obj) => obj.estado != 'ARCHIVADO').toList();
  }

  void cambiarEstado(String id, String nuevoEstado) {
    final index = _objetos.indexWhere((obj) => obj.id == id);
    if (index != -1) {
      _objetos[index].estado = nuevoEstado;
      notifyListeners();
    }
  }

  void marcarComoResuelto(String id) {
    cambiarEstado(id, 'RESUELTO');
  }

  void archivarObjeto(String id) {
    cambiarEstado(id, 'ARCHIVADO');
    final index = _objetos.indexWhere((obj) => obj.id == id);

    if (index != -1) {
      final obj = _objetos[index];
      if (obj is ObjetoPerdido && obj.idObjetoVinculado != null) {
        cambiarEstado(obj.idObjetoVinculado!, 'ARCHIVADO');
        print("Se ha archivado automáticamente el objeto vinculado: ${obj.idObjetoVinculado}");
      }
    }
  }
}
