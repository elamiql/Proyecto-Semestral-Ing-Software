import 'package:flutter/material.dart';
import 'package:proyecto_semestral_ing_software/models/reporte.dart';
import 'package:proyecto_semestral_ing_software/models/objeto_perdido.dart';
import 'package:proyecto_semestral_ing_software/screens/detalle_objeto_screen.dart';
import 'package:intl/intl.dart';

class ObjetoCard extends StatelessWidget {
  final Reporte obj;

  const ObjetoCard({super.key, required this.obj});

  IconData _getCategoriaIcon() {
    switch (obj.categoria.toLowerCase()) {
      case 'electrónica':
      case 'electronica':
        return Icons.phone_android;
      case 'documentos':
        return Icons.description;
      case 'ropa':
        return Icons.checkroom;
      case 'accesorios':
        return Icons.watch;
      case 'llaves':
        return Icons.vpn_key;
      case 'varios':
      default:
        return Icons.inventory_2;
    }
  }

  Color _getTipoColor() {
    return obj is ObjetoPerdido ? Colors.red : Colors.green;
  }

  Color _getEstadoColor() {
    switch (obj.estado?.toLowerCase()) {
      case 'activo':
        return Colors.blue;
      case 'cerrado':
        return Colors.grey;
      case 'entregado':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  String _formatearFecha() {
    return DateFormat('dd/MM/yyyy').format(obj.fechaReporte);
  }

  @override
  Widget build(BuildContext context) {
    final esPerdido = obj is ObjetoPerdido;
    final tipoTexto = esPerdido ? 'Perdido' : 'Encontrado';
    final estadoTexto = obj.estado ?? 'Activo';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetalleObjetoScreen(objeto: obj),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Miniatura arreglada
              _buildThumbnail(),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            obj.titulo,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _buildBadge(
                          text: tipoTexto,
                          color: _getTipoColor(),
                          icon: esPerdido ? Icons.search : Icons.check_circle,
                        ),
                        _buildBadge(
                          text: obj.categoria,
                          color: Colors.purple.shade400,
                          icon: Icons.category,
                        ),
                        _buildBadge(
                          text: estadoTexto,
                          color: _getEstadoColor(),
                          icon: Icons.info_outline,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Icon(
                          Icons.place_outlined,
                          size: 18,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            obj.ubicacion,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _formatearFecha(),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- AQUÍ ESTÁ EL ARREGLO ---
  Widget _buildThumbnail() {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        // Verificamos si la lista NO está vacía
        child: obj.imagenes.isNotEmpty
            ? Image.memory(
                obj.imagenes.first, // Tomamos la PRIMERA imagen de la lista
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              )
            : Center(
                child: Icon(
                  _getCategoriaIcon(),
                  size: 40,
                  color: Colors.grey.shade500,
                ),
              ),
      ),
    );
  }

  Widget _buildBadge({
    required String text,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
