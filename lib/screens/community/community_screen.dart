import 'package:flutter/material.dart';

import '../../models/publicacion.dart';
import '../../services/publicacion_service.dart';
import '../../widgets/publicacion_card.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comunidad')),
      body: StreamBuilder<List<Publicacion>>(
        stream: publicacionService.feed(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final lista = snapshot.data!;
          if (lista.isEmpty) {
            return const Center(child: Text('Aún no hay publicaciones'));
          }

          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, i) {
              return PublicacionCard(publicacion: lista[i]);
            },
          );
        },
      ),
    );
  }
}
