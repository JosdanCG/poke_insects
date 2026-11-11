import 'package:flutter/material.dart';

import '../data/imagenes_especies.dart';
import '../models/especie.dart';

class EspecieImagen extends StatelessWidget {
  final Especie especie;

  const EspecieImagen({super.key, required this.especie});

  // Se muestra si no hay enlace o la imagen no carga
  Widget sinImagen() {
    return Container(
      color: Colors.green.shade100,
      child: const Center(
        child: Icon(Icons.bug_report, size: 64, color: Colors.green),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Primero el enlace de Firestore (si existe) y si no, el del archivo
    final url = especie.imagen.isNotEmpty
        ? especie.imagen
        : (imagenesEspecies[especie.id] ?? '');

    if (url.isEmpty) return sinImagen();

    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progreso) {
        if (progreso == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) => sinImagen(),
    );
  }
}
