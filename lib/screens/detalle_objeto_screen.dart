import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_semestral_ing_software/models/reporte.dart';
import 'package:proyecto_semestral_ing_software/models/objeto_perdido.dart';
import 'package:proyecto_semestral_ing_software/models/objeto_encontrado.dart';
import 'package:proyecto_semestral_ing_software/providers/auth_provider.dart';
import 'package:proyecto_semestral_ing_software/providers/objetos_provider.dart';
import 'package:proyecto_semestral_ing_software/screens/form_obj_perdido.dart';
import 'package:proyecto_semestral_ing_software/screens/form_obj_encontrado.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalleObjetoScreen extends StatefulWidget {
  final Reporte objeto;

  const DetalleObjetoScreen({super.key, required this.objeto});

  @override
  State<DetalleObjetoScreen> createState() => _DetalleObjetoScreenState();
}

class _DetalleObjetoScreenState extends State<DetalleObjetoScreen> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // --- LÓGICA DE PERMISOS ---
  bool _esCreador(AuthProvider auth) =>
      widget.objeto.correoUsuario == auth.correo;
  bool _esAdmin(AuthProvider auth) => auth.esAdmin;

  bool _puedeEditar(AuthProvider auth) {
    return (_esCreador(auth) || _esAdmin(auth)) &&
        widget.objeto.estado != 'Cerrado' &&
        widget.objeto.estado != 'Entregado';
  }

  bool _puedeMarcarEntregado(AuthProvider auth) {
    return _esAdmin(auth) &&
        widget.objeto is ObjetoEncontrado &&
        widget.objeto.estado == 'Activo';
  }

  bool _puedeCerrar(AuthProvider auth, bool estaCerrado) {
    return (_esCreador(auth) || _esAdmin(auth)) && !estaCerrado;
  }

  // --- UTILIDADES ---
  String _formatearFechaHora() {
    return DateFormat('dd/MM/yyyy - HH:mm').format(widget.objeto.fechaReporte);
  }

  String _obtenerTelefono() {
    if (widget.objeto is ObjetoPerdido) {
      return (widget.objeto as ObjetoPerdido).infoContacto;
    } else if (widget.objeto is ObjetoEncontrado) {
      return widget.objeto.correoUsuario;
    }
    return 'No disponible';
  }

  // --- ACCIONES ---
  void _ampliarImagen(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImagenFullScreen(
          imagen: widget.objeto.imagenes[index],
          titulo: widget.objeto.titulo,
        ),
      ),
    );
  }

  Future<void> _llamarTelefono() async {
    final telefono = _obtenerTelefono();
    final url = Uri.parse('tel:$telefono');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo realizar la llamada'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navegarAEdicion() {
    if (widget.objeto is ObjetoPerdido) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              FormObjPerdido(objetoEditar: widget.objeto as ObjetoPerdido),
        ),
      ).then((_) => setState(() {}));
    } else if (widget.objeto is ObjetoEncontrado) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FormObjEncontrado(
            objetoEditar: widget.objeto as ObjetoEncontrado,
          ),
        ),
      ).then((_) => setState(() {}));
    }
  }

  // --- LÓGICA DE MATCH (VINCULAR) ---
  void _mostrarDialogoMatch() {
    final provider = Provider.of<ObjetosProvider>(context, listen: false);

    // 1. Determinar qué buscar (lo opuesto a lo que estamos viendo)
    final esPerdido = widget.objeto is ObjetoPerdido;

    final candidatos = provider.objetosVisibles.where((obj) {
      // Si estamos viendo un PERDIDO, buscamos ENCONTRADOS (y viceversa)
      return esPerdido ? (obj is ObjetoEncontrado) : (obj is ObjetoPerdido);
    }).toList();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.link, color: Colors.blue),
            const SizedBox(width: 10),
            const Text("Vincular con..."),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: candidatos.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("No hay candidatos disponibles para vincular."),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: candidatos.length,
                  itemBuilder: (ctx, index) {
                    final candidato = candidatos[index];
                    return ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                          image: candidato.imagenes.isNotEmpty
                              ? DecorationImage(
                                  image: MemoryImage(candidato.imagenes.first),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: candidato.imagenes.isEmpty
                            ? const Icon(Icons.image_not_supported, size: 20)
                            : null,
                      ),
                      title: Text(
                        candidato.titulo,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        DateFormat('dd/MM/yyyy').format(candidato.fechaReporte),
                        style: const TextStyle(fontSize: 12),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        // 2. Realizar la vinculación
                        if (esPerdido) {
                          provider.vincularObjetos(
                            widget.objeto.id,
                            candidato.id,
                          );
                        } else {
                          provider.vincularObjetos(
                            candidato.id,
                            widget.objeto.id,
                          );
                        }

                        Navigator.pop(ctx);
                        setState(
                          () {},
                        ); // Actualizamos la pantalla para ver el banner

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Vinculado con '${candidato.titulo}'",
                            ),
                            backgroundColor: Colors.blue,
                          ),
                        );
                      },
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _confirmarCerrarReporte() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Cerrar este reporte?'),
        content: const Text(
          'El reporte se marcará como cerrado y dejará de mostrarse en búsquedas activas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final provider = Provider.of<ObjetosProvider>(
                context,
                listen: false,
              );
              provider.cambiarEstado(widget.objeto.id, 'Cerrado');
              Navigator.pop(ctx);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Reporte cerrado correctamente'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Cerrar Reporte'),
          ),
        ],
      ),
    );
  }

  void _confirmarMarcarEntregado() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('¿Marcar como entregado?'),
        content: const Text(
          '¿Confirmas que este objeto fue entregado a su propietario?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              final provider = Provider.of<ObjetosProvider>(
                context,
                listen: false,
              );
              provider.cambiarEstado(widget.objeto.id, 'Entregado');
              Navigator.pop(ctx);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Objeto marcado como entregado'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Confirmar Entrega'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final esPerdido = widget.objeto is ObjetoPerdido;
    final estaCerrado =
        widget.objeto.estado == 'Cerrado' ||
        widget.objeto.estado == 'Entregado';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.objeto.titulo,
          style: const TextStyle(color: Colors.white, fontSize: 18),
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: const Color.fromARGB(255, 0, 57, 102),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          // 1. Botón MATCH (Solo Admin y si está activo)
          if (_esAdmin(auth) && !estaCerrado)
            IconButton(
              icon: const Icon(Icons.link),
              tooltip: 'Vincular Objeto',
              onPressed: _mostrarDialogoMatch,
            ),

          // 2. Botón Editar
          if (_puedeEditar(auth))
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Editar',
              onPressed: _navegarAEdicion,
            ),

          // 3. Botón Entregado (Solo Admin)
          if (_puedeMarcarEntregado(auth))
            IconButton(
              icon: const Icon(Icons.check_circle_outline),
              tooltip: 'Marcar como Entregado',
              onPressed: _confirmarMarcarEntregado,
            ),

          // 4. Botón Cerrar (Creator o Admin)
          if (_puedeCerrar(auth, estaCerrado))
            IconButton(
              icon: const Icon(Icons.lock_outline),
              tooltip: 'Cerrar Reporte',
              onPressed: _confirmarCerrarReporte,
            ),

          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Carrusel
            _buildCarruselImagenes(),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Banner de Estado Cerrado
                  if (estaCerrado) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.lock, color: Colors.grey.shade700),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Este reporte está cerrado o archivado.',
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // 3. NUEVO: Banner de Match (Si existe vinculación)
                  _buildMatchInfo(context),

                  // 4. Título y badges
                  Text(
                    widget.objeto.titulo,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildBadge(
                        text: esPerdido ? 'Perdido' : 'Encontrado',
                        color: esPerdido ? Colors.red : Colors.green,
                        icon: esPerdido ? Icons.search : Icons.check_circle,
                      ),
                      _buildBadge(
                        text: widget.objeto.categoria,
                        color: Colors.purple.shade400,
                        icon: Icons.category,
                      ),
                      _buildBadge(
                        text: widget.objeto.estado ?? 'Activo',
                        color: _getEstadoColor(),
                        icon: Icons.info_outline,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 5. Secciones de información
                  _buildSeccion(
                    icon: Icons.description_outlined,
                    titulo: 'Descripción',
                    contenido: widget.objeto.descripcion.isNotEmpty
                        ? widget.objeto.descripcion
                        : 'Sin descripción',
                  ),
                  const SizedBox(height: 20),
                  _buildSeccion(
                    icon: Icons.place_outlined,
                    titulo: esPerdido ? 'Dónde se perdió' : 'Dónde se encontró',
                    contenido: widget.objeto.ubicacion,
                  ),
                  const SizedBox(height: 20),
                  _buildSeccion(
                    icon: Icons.access_time,
                    titulo: 'Fecha de reporte',
                    contenido: _formatearFechaHora(),
                  ),
                  if (widget.objeto is ObjetoPerdido) ...[
                    const SizedBox(height: 20),
                    _buildSeccion(
                      icon: Icons.schedule,
                      titulo: 'Hora aproximada de pérdida',
                      contenido: (widget.objeto as ObjetoPerdido).horaDePerdida,
                    ),
                  ],
                  if (widget.objeto is ObjetoEncontrado) ...[
                    const SizedBox(height: 20),
                    _buildSeccion(
                      icon: Icons.location_on,
                      titulo: 'Dónde reclamar',
                      contenido:
                          (widget.objeto as ObjetoEncontrado).dondeReclamar,
                    ),
                  ],

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),

                  // 6. Contacto
                  _buildSeccionContacto(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET PARA VER LA VINCULACIÓN (MATCH) ---
  Widget _buildMatchInfo(BuildContext context) {
    if (widget.objeto is! ObjetoPerdido) return const SizedBox.shrink();

    final perdido = widget.objeto as ObjetoPerdido;
    if (perdido.idObjetoVinculado == null) return const SizedBox.shrink();

    final provider = Provider.of<ObjetosProvider>(context, listen: false);
    final encontrado = provider.obtenerObjetoPorId(perdido.idObjetoVinculado!);

    if (encontrado == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        border: Border.all(color: Colors.green.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetalleObjetoScreen(objeto: encontrado),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.link, color: Colors.green, size: 30),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "¡POSIBLE HALLAZGO VINCULADO!",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        encontrado.titulo,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        "Ubicación: ${encontrado.ubicacion}",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.green,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGETS DE UI AUXILIARES ---
  Widget _buildCarruselImagenes() {
    if (widget.objeto.imagenes.isEmpty) {
      return Container(
        height: 300,
        color: Colors.grey.shade200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                'Sin imágenes disponibles',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 300,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.objeto.imagenes.length,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _ampliarImagen(context, index),
                child: Container(
                  color: Colors.black,
                  child: Image.memory(
                    widget.objeto.imagenes[index],
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
          if (widget.objeto.imagenes.length > 1)
            Positioned(
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    widget.objeto.imagenes.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentImageIndex == index
                            ? Colors.white
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (widget.objeto.imagenes.length > 1)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${_currentImageIndex + 1} / ${widget.objeto.imagenes.length}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          if (_currentImageIndex > 0)
            Positioned(
              left: 10,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () => _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                  ),
                ),
              ),
            ),
          if (_currentImageIndex < widget.objeto.imagenes.length - 1)
            Positioned(
              right: 10,
              top: 0,
              bottom: 0,
              child: Center(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () => _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBadge({
    required String text,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getEstadoColor() {
    switch (widget.objeto.estado?.toLowerCase()) {
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

  Widget _buildSeccion({
    required IconData icon,
    required String titulo,
    required String contenido,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 57, 102).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: const Color.fromARGB(255, 0, 57, 102),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                contenido,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSeccionContacto() {
    final telefono = _obtenerTelefono();
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.contact_phone,
                    size: 20,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Información de Contacto',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.phone, size: 18, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Text(
                  telefono,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _llamarTelefono,
                icon: const Icon(Icons.phone, size: 18),
                label: const Text('Llamar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImagenFullScreen extends StatelessWidget {
  final Uint8List imagen;
  final String titulo;

  const ImagenFullScreen({
    super.key,
    required this.imagen,
    required this.titulo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(titulo, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Image.memory(imagen),
        ),
      ),
    );
  }
}
