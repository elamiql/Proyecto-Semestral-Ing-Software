import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_semestral_ing_software/providers/objetos_provider.dart';
import 'package:proyecto_semestral_ing_software/widgets/objeto_card.dart';
import 'package:proyecto_semestral_ing_software/utils/categorias.dart';

class VerObjetosScreen extends StatefulWidget {
  const VerObjetosScreen({super.key});

  @override
  State<VerObjetosScreen> createState() => _VerObjetosScreenState();
}

class _VerObjetosScreenState extends State<VerObjetosScreen> {
  final _busquedaController = TextEditingController();
  String? _categoriaFiltro = 'Todas';
  String _textoBusqueda = '';

  @override
  void dispose() {
    _busquedaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final objetosProvider = Provider.of<ObjetosProvider>(context);

    // Aplicar filtros
    final objetosFiltrados = objetosProvider.filtrarObjetos(
      busqueda: _textoBusqueda,
      categoria: _categoriaFiltro,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Ver Objetos'), centerTitle: true),
      body: Column(
        children: [
          // Barra de búsqueda y filtros
          Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Campo de búsqueda
                TextField(
                  controller: _busquedaController,
                  decoration: InputDecoration(
                    hintText: 'Buscar por título, descripción o ubicación...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _busquedaController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _busquedaController.clear();
                                _textoBusqueda = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _textoBusqueda = value;
                    });
                  },
                ),
                const SizedBox(height: 12),

                // Filtro por categoría
                Row(
                  children: [
                    const Icon(Icons.filter_list, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Filtrar por:',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _categoriaFiltro,
                            isExpanded: true,
                            items: [
                              const DropdownMenuItem(
                                value: 'Todas',
                                child: Text('Todas las categorías'),
                              ),
                              ...Categorias.lista.map((categoria) {
                                return DropdownMenuItem<String>(
                                  value: categoria,
                                  child: Text(categoria),
                                );
                              }),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _categoriaFiltro = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Resultados
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Resultados: ${objetosFiltrados.length}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_textoBusqueda.isNotEmpty || _categoriaFiltro != 'Todas')
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _busquedaController.clear();
                        _textoBusqueda = '';
                        _categoriaFiltro = 'Todas';
                      });
                    },
                    icon: const Icon(Icons.clear_all, size: 18),
                    label: const Text('Limpiar filtros'),
                  ),
              ],
            ),
          ),

          // Lista de objetos
          Expanded(
            child: objetosFiltrados.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _textoBusqueda.isNotEmpty ||
                                  _categoriaFiltro != 'Todas'
                              ? 'No se encontraron resultados'
                              : 'No hay objetos reportados',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (_textoBusqueda.isNotEmpty ||
                            _categoriaFiltro != 'Todas')
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _busquedaController.clear();
                                  _textoBusqueda = '';
                                  _categoriaFiltro = 'Todas';
                                });
                              },
                              child: const Text('Ver todos los objetos'),
                            ),
                          ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
}
