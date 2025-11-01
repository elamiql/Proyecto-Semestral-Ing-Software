import 'package:flutter/material.dart';
import 'dart:collection';

import 'package:proyecto_semestral_ing_software/models/reporte.dart';

class ObjetosProvider with ChangeNotifier {
  final List<Reporte> _objetos = [];

  UnmodifiableListView<Reporte> get objetos => UnmodifiableListView(_objetos);

  void agregarObjeto(Reporte objeto) {
    _objetos.add(objeto);
    notifyListeners();
  }

    void eliminarObjeto(Reporte objeto){
        //TO DO
    }
}
