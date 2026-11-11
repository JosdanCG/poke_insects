import 'package:flutter/material.dart';

import '../models/publicacion.dart';

class PublicacionCard extends StatelessWidget {
  final Publicacion publicacion;
  final VoidCallback? onEliminar; // solo se pasa en mis publicaciones

  const PublicacionCard({
    super.key,
    required this.publicacion,
    this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    final p = publicacion;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(p.duenoNombre),
            subtitle: Text('${p.ejemplarNombre} • ${p.especieNombre}'),
            trailing: onEliminar == null
                ? null
                : IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: onEliminar,
                  ),
          ),
          if (p.bytes != null)
            Image.memory(
              p.bytes!,
              width: double.infinity,
              height: 260,
              fit: BoxFit.cover,
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (p.comentario.isNotEmpty) Text(p.comentario),
                const SizedBox(height: 4),
                Text(
                  '${p.fecha.day}/${p.fecha.month}/${p.fecha.year}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
