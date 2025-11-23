import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_semestral_ing_software/providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _correoController = TextEditingController();
  final _nombreController = TextEditingController();
  final _matriculaController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _correoController.dispose();
    _nombreController.dispose();
    _matriculaController.dispose();
    _telefonoController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegistro() async {
    final correo = _correoController.text.trim();
    final nombre = _nombreController.text.trim();
    final matricula = _matriculaController.text.trim();
    final telefono = _telefonoController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (correo.isEmpty ||
        nombre.isEmpty ||
        matricula.isEmpty ||
        telefono.isEmpty ||
        password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa todos los campos'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (!correo.endsWith("@udec.cl")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes usar un correo @udec.cl'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La contraseña debe tener al menos 6 caracteres'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Las contraseñas no coinciden'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final auth = Provider.of<AuthProvider>(context, listen: false);

      await auth.registrarUsuario(
        correo: correo,
        nombre: nombre,
        matricula: matricula,
        telefono: telefono,
        password: password,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Cuenta creada! Ahora inicia sesión'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Cuenta'), elevation: 0),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            Icon(Icons.school, size: 80, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16),
            Text(
              'Registro UdeC',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Completa tus datos institucionales',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            TextField(
              controller: _correoController,
              decoration: InputDecoration(
                labelText: 'Correo Institucional',
                hintText: 'tu.nombre@udec.cl',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre Completo',
                hintText: 'Juan Pérez',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _matriculaController,
              decoration: InputDecoration(
                labelText: 'Matrícula',
                hintText: '2024123456',
                prefixIcon: const Icon(Icons.badge_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _telefonoController,
              decoration: InputDecoration(
                labelText: 'Teléfono',
                hintText: '+56912345678',
                prefixIcon: const Icon(Icons.phone_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                hintText: 'Mínimo 6 caracteres',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              obscureText: _obscurePassword,
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirmar Contraseña',
                hintText: 'Repite tu contraseña',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(
                      () => _obscureConfirmPassword = !_obscureConfirmPassword,
                    );
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              obscureText: _obscureConfirmPassword,
              onSubmitted: (_) => _handleRegistro(),
            ),
            const SizedBox(height: 24),

            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleRegistro,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Crear Cuenta'),
              ),
            ),
            const SizedBox(height: 16),

            // Link a login
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('¿Ya tienes cuenta? Inicia sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
