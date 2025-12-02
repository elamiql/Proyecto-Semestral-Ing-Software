import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_semestral_ing_software/providers/objetos_provider.dart';
import 'package:proyecto_semestral_ing_software/widgets/objeto_card.dart';
import 'package:proyecto_semestral_ing_software/utils/categorias.dart';
import 'package:proyecto_semestral_ing_software/models/objeto_perdido.dart';
import 'package:proyecto_semestral_ing_software/models/objeto_encontrado.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class VerObjetosScreen extends StatefulWidget {
  const VerObjetosScreen({super.key});

  @override
  State<VerObjetosScreen> createState() => _VerObjetosScreenState();
}

class _VerObjetosScreenState extends State<VerObjetosScreen> {
  final _busquedaController = TextEditingController();
  String _textoBusqueda = '';
  Timer? _debounceTimer;

  String? _categoriaFiltro = 'Todas';
  String _tipoFiltro = 'Todos';
  String _estadoFiltro = 'Todos';
  DateTime? _fechaDesde;
  DateTime? _fechaHasta;
  String _ordenamiento = 'Más recientes';

  bool _mostrarFiltros = true;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _busquedaController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _textoBusqueda = value.toLowerCase();
      });
    });
  }

  void _limpiarBusqueda() {
    setState(() {
      _busquedaController.clear();
      _textoBusqueda = '';
    });
  }

  void _limpiarTodosFiltros() {
    setState(() {
      _busquedaController.clear();
      _textoBusqueda = '';
      _categoriaFiltro = 'Todas';
      _tipoFiltro = 'Todos';
      _estadoFiltro = 'Todos';
      _fechaDesde = null;
      _fechaHasta = null;
      _ordenamiento = 'Más recientes';
    });
  }

  void _limpiarFechas() {
    setState(() {
      _fechaDesde = null;
      _fechaHasta = null;
    });
  }

  Future<void> _seleccionarFechaDesde() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaDesde ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'ES'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 0, 57, 102),
            ),
          ),
          child: child!,
        );
      },
    );

    if (fecha != null) {
      setState(() {
        _fechaDesde = fecha;
        if (_fechaHasta != null && _fechaHasta!.isBefore(fecha)) {
          _fechaHasta = fecha;
        }
      });
    }
  }

  Future<void> _seleccionarFechaHasta() async {
    final fecha = await showDatePicker(
      context: context,
      initialDate: _fechaHasta ?? DateTime.now(),
      firstDate: _fechaDesde ?? DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'ES'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 0, 57, 102),
            ),
          ),
          child: child!,
        );
      },
    );

    if (fecha != null) {
      setState(() {
        _fechaHasta = fecha;
      });
    }
  }

  List<dynamic> _aplicarFiltros(List<dynamic> objetos) {
    var resultado = objetos;

    if (_textoBusqueda.isNotEmpty) {
      resultado = resultado.where((obj) {
        return obj.titulo.toLowerCase().contains(_textoBusqueda) ||
            obj.descripcion.toLowerCase().contains(_textoBusqueda) ||
            obj.ubicacion.toLowerCase().contains(_textoBusqueda);
      }).toList();
    }

    if (_categoriaFiltro != null && _categoriaFiltro != 'Todas') {
      resultado = resultado
          .where((obj) => obj.categoria == _categoriaFiltro)
          .toList();
    }

    if (_tipoFiltro == 'Perdido') {
      resultado = resultado.where((obj) => obj is ObjetoPerdido).toList();
    } else if (_tipoFiltro == 'Encontrado') {
      resultado = resultado.where((obj) => obj is ObjetoEncontrado).toList();
    }

    if (_estadoFiltro != 'Todos') {
      resultado = resultado
          .where((obj) => obj.estado == _estadoFiltro)
          .toList();
    }

    if (_fechaDesde != null) {
      resultado = resultado.where((obj) {
        return obj.fechaReporte.isAfter(_fechaDesde!) ||
            obj.fechaReporte.isAtSameMomentAs(_fechaDesde!);
      }).toList();
    }

    if (_fechaHasta != null) {
      final fechaHastaFin = DateTime(
        _fechaHasta!.year,
        _fechaHasta!.month,
        _fechaHasta!.day,
        23,
        59,
        59,
      );
      resultado = resultado.where((obj) {
        return obj.fechaReporte.isBefore(fechaHastaFin) ||
            obj.fechaReporte.isAtSameMomentAs(fechaHastaFin);
      }).toList();
    }

    if (_ordenamiento == 'Más recientes') {
      resultado.sort((a, b) => b.fechaReporte.compareTo(a.fechaReporte));
    } else if (_ordenamiento == 'Más antiguos') {
      resultado.sort((a, b) => a.fechaReporte.compareTo(b.fechaReporte));
    } else if (_ordenamiento == 'A-Z') {
      resultado.sort(
        (a, b) => a.titulo.toLowerCase().compareTo(b.titulo.toLowerCase()),
      );
    }

    return resultado;
  }

  bool get _hayFiltrosActivos {
    return _textoBusqueda.isNotEmpty ||
        _categoriaFiltro != 'Todas' ||
        _tipoFiltro != 'Todos' ||
        _estadoFiltro != 'Todos' ||
        _fechaDesde != null ||
        _fechaHasta != null ||
        _ordenamiento != 'Más recientes';
  }

  int get _contadorFiltrosActivos {
    int count = 0;
    if (_textoBusqueda.isNotEmpty) count++;
    if (_categoriaFiltro != 'Todas') count++;
    if (_tipoFiltro != 'Todos') count++;
    if (_estadoFiltro != 'Todos') count++;
    if (_fechaDesde != null || _fechaHasta != null) count++;
    if (_ordenamiento != 'Más recientes') count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final objetosProvider = Provider.of<ObjetosProvider>(context);
    final todoLosObjetos = objetosProvider.objetosVisibles;
    final objetosFiltrados = _aplicarFiltros(todoLosObjetos);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ver Objetos', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 0, 57, 102),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _mostrarFiltros ? Icons.filter_list_off : Icons.filter_list,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _mostrarFiltros = !_mostrarFiltros;
              });
            },
            tooltip: _mostrarFiltros ? 'Ocultar filtros' : 'Mostrar filtros',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _busquedaController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Buscar por título, descripción o ubicación...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
                  suffixIcon: _busquedaController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.grey.shade600),
                          onPressed: _limpiarBusqueda,
                          tooltip: 'Limpiar búsqueda',
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 0, 57, 102),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),

          if (_mostrarFiltros) _buildPanelFiltros(),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.grey.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.list_alt, size: 20, color: Colors.grey.shade700),
                    const SizedBox(width: 8),
                    Text(
                      '${objetosFiltrados.length} ${objetosFiltrados.length == 1 ? 'resultado' : 'resultados'}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    if (_hayFiltrosActivos) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 0, 57, 102),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$_contadorFiltrosActivos',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (_hayFiltrosActivos)
                  TextButton.icon(
                    onPressed: _limpiarTodosFiltros,
                    icon: const Icon(Icons.clear_all, size: 18),
                    label: const Text(
                      'Limpiar',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color.fromARGB(255, 0, 57, 102),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          Expanded(
            child: objetosFiltrados.isEmpty
                ? _buildEstadoVacio()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: objetosFiltrados.length,
                    itemBuilder: (context, index) {
                      final obj = objetosFiltrados[index];
                      return ObjetoCard(obj: obj);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPanelFiltros() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(
                      255,
                      0,
                      57,
                      102,
                    ).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.tune,
                    size: 20,
                    color: Color.fromARGB(255, 0, 57, 102),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Filtros',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                if (_hayFiltrosActivos)
                  TextButton(
                    onPressed: _limpiarTodosFiltros,
                    child: const Text('Limpiar todos'),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildFiltroDropdown(
                  label: 'Categoría',
                  icon: Icons.category_outlined,
                  value: _categoriaFiltro,
                  items: ['Todas', ...Categorias.lista],
                  onChanged: (value) {
                    setState(() {
                      _categoriaFiltro = value;
                    });
                  },
                ),
                _buildFiltroDropdown(
                  label: 'Tipo',
                  icon: Icons.label_outline,
                  value: _tipoFiltro,
                  items: ['Todos', 'Perdido', 'Encontrado'],
                  onChanged: (value) {
                    setState(() {
                      _tipoFiltro = value!;
                    });
                  },
                ),
                _buildFiltroDropdown(
                  label: 'Estado',
                  icon: Icons.info_outline,
                  value: _estadoFiltro,
                  items: ['Todos', 'Activo', 'Cerrado'],
                  onChanged: (value) {
                    setState(() {
                      _estadoFiltro = value!;
                    });
                  },
                ),

                _buildFiltroDropdown(
                  label: 'Ordenar',
                  icon: Icons.sort,
                  value: _ordenamiento,
                  items: ['Más recientes', 'Más antiguos', 'A-Z'],
                  onChanged: (value) {
                    setState(() {
                      _ordenamiento = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildFiltroFecha(
                    label: 'Desde',
                    fecha: _fechaDesde,
                    onTap: _seleccionarFechaDesde,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFiltroFecha(
                    label: 'Hasta',
                    fecha: _fechaHasta,
                    onTap: _seleccionarFechaHasta,
                  ),
                ),
                if (_fechaDesde != null || _fechaHasta != null)
                  IconButton(
                    icon: const Icon(Icons.clear, size: 20),
                    onPressed: _limpiarFechas,
                    tooltip: 'Limpiar fechas',
                    color: Colors.red,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltroDropdown({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      width: (MediaQuery.of(context).size.width - 56) / 2,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                isDense: true,
                style: const TextStyle(fontSize: 13, color: Colors.black87),
                items: items.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item, style: const TextStyle(fontSize: 13)),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltroFecha({
    required String label,
    required DateTime? fecha,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: fecha != null
                ? const Color.fromARGB(255, 0, 57, 102)
                : Colors.grey.shade300,
            width: fecha != null ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 16,
              color: fecha != null
                  ? const Color.fromARGB(255, 0, 57, 102)
                  : Colors.grey.shade600,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                  Text(
                    fecha != null
                        ? DateFormat('dd/MM/yyyy').format(fecha)
                        : 'Seleccionar',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: fecha != null
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: fecha != null
                          ? Colors.black87
                          : Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstadoVacio() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _hayFiltrosActivos ? Icons.search_off : Icons.inbox_outlined,
                size: 80,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _hayFiltrosActivos
                  ? 'No se encontraron resultados'
                  : 'No hay objetos reportados',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            if (_textoBusqueda.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '"$_textoBusqueda"',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
            if (_hayFiltrosActivos) ...[
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Colors.blue.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Sugerencias:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSugerencia('Intenta con menos palabras'),
                    const SizedBox(height: 8),
                    _buildSugerencia('Verifica la ortografía'),
                    const SizedBox(height: 8),
                    _buildSugerencia('Prueba con filtros diferentes'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _limpiarTodosFiltros,
                icon: const Icon(Icons.refresh),
                label: const Text('Limpiar filtros'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 57, 102),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSugerencia(String texto) {
    return Row(
      children: [
        Icon(Icons.check_circle_outline, size: 16, color: Colors.blue.shade700),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            texto,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
        ),
      ],
    );
  }
}
