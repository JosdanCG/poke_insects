import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/ejemplar.dart';
import '../../models/publicacion.dart';
import '../../services/publicacion_service.dart';
import '../../widgets/publicacion_card.dart';
import 'ejemplar_form_screen.dart';
import 'nueva_publicacion_screen.dart';

class EjemplarDetailScreen extends StatelessWidget {
  final Ejemplar ejemplar;

  const EjemplarDetailScreen({super.key, required this.ejemplar});

  String formatoFecha(DateTime f) => '${f.day}/${f.month}/${f.year}';

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(ejemplar.nombre),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EjemplarFormScreen(ejemplar: ejemplar),
                ),
              );
              // Al volver de editar, regresamos a la lista para ver los cambios
              if (!context.mounted) return;
              Navigator.pop(context);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NuevaPublicacionScreen(ejemplar: ejemplar),
            ),
          );
        },
        child: const Icon(Icons.add_a_photo),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ejemplar.especieNombre,
                  style: const TextStyle(fontSize: 18),
                ),
                Text('Adquirido: ${formatoFecha(ejemplar.fecha)}'),
                if (ejemplar.notas.isNotEmpty) Text('Notas: ${ejemplar.notas}'),
              ],
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Mis publicaciones',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Publicacion>>(
              stream: publicacionService.deEjemplar(uid, ejemplar.id),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final lista = snapshot.data!;
                if (lista.isEmpty) {
                  return const Center(child: Text('Aún no has publicado nada'));
                }

                return ListView.builder(
                  itemCount: lista.length,
                  itemBuilder: (context, i) {
                    final p = lista[i];
                    return PublicacionCard(
                      publicacion: p,
                      onEliminar: () => publicacionService.eliminar(p.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
