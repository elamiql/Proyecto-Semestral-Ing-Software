import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_semestral_ing_software/screens/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto_semestral_ing_software/providers/auth_provider.dart';
import 'package:proyecto_semestral_ing_software/providers/objetos_provider.dart';
import 'package:proyecto_semestral_ing_software/widgets/objeto_card.dart';
import 'package:proyecto_semestral_ing_software/models/objeto_perdido.dart';
import 'package:proyecto_semestral_ing_software/models/objeto_encontrado.dart';
import 'package:proyecto_semestral_ing_software/screens/form_obj_perdido.dart';
import 'package:proyecto_semestral_ing_software/screens/form_obj_encontrado.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  String? correo;
  String? nombre;
  String? matricula;
  String? telefono;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      correo = prefs.getString('correo');
      nombre = prefs.getString('nombre');
      matricula = prefs.getString('matricula');
      telefono = prefs.getString('telefono');
      _isLoading = false;
    });
  }

  void _confirmarCierreReporte(
    BuildContext context,
    ObjetosProvider provider,
    String idReporte,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("¿Cerrar este reporte?"),
        content: const Text(
          "El reporte se marcará como cerrado y dejará de mostrarse en búsquedas activas.",
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              provider.cambiarEstado(idReporte, 'Cerrado');
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Reporte cerrado correctamente"),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text("Cerrar Reporte"),
          ),
        ],
      ),
    );
  }

  void _navegarAEdicion(BuildContext context, dynamic reporte) {
    if (reporte is ObjetoPerdido) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FormObjPerdido(objetoEditar: reporte),
        ),
      );
    } else if (reporte is ObjetoEncontrado) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FormObjEncontrado(objetoEditar: reporte),
        ),
      );
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final objetosProvider = Provider.of<ObjetosProvider>(context);
    final misReportes = objetosProvider.obtenerReportesPorUsuario(
      auth.correo ?? '',
    );

    // Separar reportes por tipo si es admin
    final reportesPerdidos = misReportes
        .where((r) => r is ObjetoPerdido)
        .toList();
    final reportesEncontrados = misReportes
        .where((r) => r is ObjetoEncontrado)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 0, 57, 102),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Header con gradient
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.fromARGB(255, 0, 57, 102),
                          Color.fromARGB(255, 0, 80, 140),
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        // Avatar
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 60,
                            color: Color.fromARGB(255, 0, 57, 102),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Nombre
                        Text(
                          nombre ?? 'Sin nombre',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Badge de rol
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: auth.esAdmin
                                ? Colors.red.shade400
                                : Colors.blue.shade400,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                auth.esAdmin
                                    ? Icons.admin_panel_settings
                                    : Icons.person,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                auth.esAdmin ? "Administrador" : "Usuario",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),

                  // Contenido principal
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sección: Mis Datos
                        _buildSeccionHeader(
                          icon: Icons.person_outline,
                          title: 'Mis Datos',
                        ),
                        const SizedBox(height: 12),
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                _buildInfoRow(
                                  Icons.email_outlined,
                                  'Correo',
                                  correo ?? 'No disponible',
                                ),
                                const Divider(height: 24),
                                _buildInfoRow(
                                  Icons.phone_outlined,
                                  'Teléfono',
                                  telefono ?? 'No disponible',
                                ),
                                const Divider(height: 24),
                                _buildInfoRow(
                                  Icons.badge_outlined,
                                  'Matrícula',
                                  matricula ?? 'No disponible',
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Sección: Mis Reportes
                        _buildSeccionHeader(
                          icon: Icons.list_alt,
                          title: 'Mis Reportes',
                          contador: misReportes.length,
                        ),
                        const SizedBox(height: 12),

                        // Si no hay reportes
                        if (misReportes.isEmpty)
                          _buildEstadoVacio()
                        // Si hay reportes y es usuario normal
                        else if (!auth.esAdmin)
                          _buildListaReportes(reportesPerdidos, objetosProvider)
                        // Si es admin, mostrar secciones separadas
                        else ...[
                          if (reportesPerdidos.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'Objetos Perdidos (${reportesPerdidos.length})',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                            _buildListaReportes(
                              reportesPerdidos,
                              objetosProvider,
                            ),
                            const SizedBox(height: 16),
                          ],

                          if (reportesEncontrados.isNotEmpty) ...[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                'Objetos Encontrados (${reportesEncontrados.length})',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                            _buildListaReportes(
                              reportesEncontrados,
                              objetosProvider,
                            ),
                          ],
                        ],

                        const SizedBox(height: 32),

                        // Botones de acción
                        _buildBotonAccion(
                          icon: Icons.edit_outlined,
                          label: 'Editar Perfil',
                          color: const Color.fromARGB(255, 0, 57, 102),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Función en desarrollo'),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),

                        _buildBotonAccion(
                          icon: Icons.delete_outline,
                          label: 'Eliminar Cuenta',
                          color: Colors.red,
                          onPressed: _mostrarDialogoEliminarCuenta,
                          isOutlined: true,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSeccionHeader({
    required IconData icon,
    required String title,
    int? contador,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 57, 102).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 24,
            color: const Color.fromARGB(255, 0, 57, 102),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        if (contador != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 0, 57, 102),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$contador',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEstadoVacio() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No tienes reportes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tus reportes aparecerán aquí',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListaReportes(
    List<dynamic> reportes,
    ObjetosProvider objetosProvider,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reportes.length,
      itemBuilder: (context, index) {
        final reporte = reportes[index];
        final estaCerrado =
            reporte.estado == 'Cerrado' || reporte.estado == 'Entregado';

        return Column(
          children: [
            ObjetoCard(obj: reporte),

            // Barra de acciones
            Container(
              margin: const EdgeInsets.only(bottom: 16, left: 4, right: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (estaCerrado)
                      Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.lock_outline,
                              size: 14,
                              color: Colors.red.shade700,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Cerrado",
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // Botón Editar
                    TextButton.icon(
                      icon: Icon(
                        Icons.edit_outlined,
                        size: 18,
                        color: estaCerrado ? Colors.grey : Colors.blue,
                      ),
                      label: Text(
                        "Editar",
                        style: TextStyle(
                          color: estaCerrado ? Colors.grey : Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: estaCerrado
                          ? () => _mostrarError(
                              "No puedes editar reportes cerrados",
                            )
                          : () => _navegarAEdicion(context, reporte),
                    ),

                    // Botón Cerrar
                    TextButton.icon(
                      icon: Icon(
                        Icons.close,
                        size: 18,
                        color: estaCerrado ? Colors.grey : Colors.red,
                      ),
                      label: Text(
                        "Cerrar",
                        style: TextStyle(
                          color: estaCerrado ? Colors.grey : Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: estaCerrado
                          ? null
                          : () => _confirmarCierreReporte(
                              context,
                              objetosProvider,
                              reporte.id,
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 0, 57, 102).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color.fromARGB(255, 0, 57, 102),
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBotonAccion({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    bool isOutlined = false,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: isOutlined
          ? OutlinedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon),
              label: Text(label),
              style: OutlinedButton.styleFrom(
                foregroundColor: color,
                side: BorderSide(color: color, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            )
          : ElevatedButton.icon(
              onPressed: onPressed,
              icon: Icon(icon),
              label: Text(label),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
    );
  }

  void _mostrarDialogoEliminarCuenta() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
              SizedBox(width: 12),
              Text('Eliminar Cuenta'),
            ],
          ),
          content: const Text(
            'Esta acción es permanente. Se eliminarán todos tus datos y reportes.\n\n¿Estás completamente seguro?',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                await Provider.of<AuthProvider>(
                  context,
                  listen: false,
                ).eliminarCuenta();
                if (context.mounted) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Eliminar Definitivamente'),
            ),
          ],
        );
      },
    );
  }
}
