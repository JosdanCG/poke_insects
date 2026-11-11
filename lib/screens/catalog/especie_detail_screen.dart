import 'package:flutter/material.dart';

import '../../models/especie.dart';
import '../../widgets/especie_imagen.dart';

class EspecieDetailScreen extends StatelessWidget {
  final Especie especie;

  const EspecieDetailScreen({super.key, required this.especie});

  Widget dato(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(valor),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(especie.nombreComun)),
      body: ListView(
        children: [
          SizedBox(height: 240, child: EspecieImagen(especie: especie)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  especie.nombreCientifico,
                  style: const TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),
                Text('Grupo: ${especie.grupo}'),
                Text('Dificultad: ${especie.dificultad}'),
                const SizedBox(height: 16),
                Text(especie.descripcion),
                const Divider(height: 32),
                dato('Temperatura', especie.temperatura),
                dato('Humedad', especie.humedad),
                dato('Dieta', especie.dieta),
                dato('Mudas', especie.mudas),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
