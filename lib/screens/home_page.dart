import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_semestral_ing_software/providers/objetos_provider.dart';
import 'package:proyecto_semestral_ing_software/providers/auth_provider.dart';
import 'package:proyecto_semestral_ing_software/screens/detalle_objeto_screen.dart';
import 'package:proyecto_semestral_ing_software/screens/perfil_screen.dart';
import 'package:proyecto_semestral_ing_software/widgets/objeto_card.dart';
import 'package:proyecto_semestral_ing_software/screens/form_obj_encontrado.dart';
import 'package:proyecto_semestral_ing_software/screens/form_obj_perdido.dart';
import 'ver_objetos_screen.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final auth = Provider.of<AuthProvider>(context);
    if (auth.correo == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      });
    }
  }

  void _mostrarDialogoLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Cerrar Sesión?'),
          content: const Text('Tendrás que ingresar tus datos nuevamente.'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                await Provider.of<AuthProvider>(
                  context,
                  listen: false,
                ).logout();
                if (context.mounted) {
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
              child: const Text('Salir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final objetosProvider = Provider.of<ObjetosProvider>(context);

    // Obtenemos los últimos 5 para mostrar, invirtiendo la lista para ver los nuevos primero
    final ultimosObjetos = objetosProvider.objetosVisibles.reversed
        .take(5)
        .toList();

    if (auth.correo == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.grey[50], // Fondo un poco más claro que blanco
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 0, 57, 102),
        title: Row(
          children: [
            // Icono de la app o Logo pequeño
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.travel_explore, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Text(
              "Recüper UdeC",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                auth.nombre?[0].toUpperCase() ?? "U",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003966),
                ),
              ),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PerfilScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _mostrarDialogoLogout,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. SECCIÓN DE BIENVENIDA (Header)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 0, 57, 102),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hola, ${auth.nombre?.split(' ')[0] ?? 'Estudiante'}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    auth.esAdmin
                        ? "Panel de Administrador"
                        : "¿Qué necesitas hacer hoy?",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // 2. TARJETAS DE ACCIÓN (Transformado para subir un poco sobre el header)
            Transform.translate(
              offset: const Offset(0, -20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    // Fila de Botones Principales
                    Row(
                      children: [
                        // Botón: PERDÍ ALGO
                        Expanded(
                          child: _buildActionCard(
                            context,
                            title: "Perdí algo",
                            icon: Icons.search_off,
                            color: Colors.orange.shade700,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const FormObjPerdido(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Botón: VER OBJETOS (Catálogo)
                        Expanded(
                          child: _buildActionCard(
                            context,
                            title: "Buscar Objetos",
                            icon: Icons.manage_search,
                            color: Colors.blue.shade700,
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const VerObjetosScreen(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Botón de ADMIN (Solo visible si es admin)
                    if (auth.esAdmin) ...[
                      const SizedBox(height: 12),
                      _buildActionCard(
                        context,
                        title: "Reportar Hallazgo (Admin)",
                        icon: Icons.add_location_alt,
                        color: Colors.green.shade700,
                        isFullWidth: true, // Ocupa todo el ancho
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FormObjEncontrado(),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // 3. SECCIÓN "ACTIVIDAD RECIENTE"
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Actividad Reciente",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const VerObjetosScreen(),
                      ),
                    ),
                    child: const Text("Ver todo"),
                  ),
                ],
              ),
            ),

            // 4. LISTA DE OBJETOS (Integrada verticalmente)
            ultimosObjetos.isEmpty
                ? Container(
                    height: 150,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox,
                            size: 40,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "No hay reportes recientes",
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shrinkWrap:
                        true, // Importante para que funcione dentro del SingleChildScrollView
                    physics:
                        const NeverScrollableScrollPhysics(), // Desactiva scroll interno
                    itemCount: ultimosObjetos.length,
                    itemBuilder: (context, index) {
                      // Reutilizamos tu ObjetoCard, pero con GestureDetector para navegar
                      final obj = ultimosObjetos[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetalleObjetoScreen(objeto: obj),
                            ),
                          );
                        },
                        child: ObjetoCard(obj: obj),
                      );
                    },
                  ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- WIDGET PARA LAS TARJETAS DE ACCIÓN ---
  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isFullWidth = false,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 100, // Altura fija para uniformidad
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.8), color],
            ),
          ),
          child: isFullWidth
              ? Row(
                  // Diseño horizontal para tarjeta ancha
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 32, color: Colors.white),
                    const SizedBox(width: 16),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              : Column(
                  // Diseño vertical para tarjetas cuadradas
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 32, color: Colors.white),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
