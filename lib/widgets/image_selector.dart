import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:proyecto_semestral_ing_software/theme/app_theme.dart';

class ImageSelector extends StatelessWidget {
  final Uint8List? imagenBytes;
  final VoidCallback onTap;
  final String texto;
  final Color? iconColor;

  const ImageSelector({
    super.key,
    required this.imagenBytes,
    required this.onTap,
    this.texto = "Toca para agregar una foto",
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
        ),
        child: imagenBytes == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_outlined,
                    size: 50,
                    color: iconColor ?? AppTheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(texto, style: TextStyle(color: Colors.grey[600])),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(imagenBytes!, fit: BoxFit.cover),
              ),
      ),
    );
  }
}
