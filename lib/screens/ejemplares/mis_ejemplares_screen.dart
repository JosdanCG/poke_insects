import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/ejemplar.dart';
import '../../services/ejemplar_service.dart';
import 'ejemplar_detail_screen.dart';
import 'ejemplar_form_screen.dart';

class MisEjemplaresScreen extends StatelessWidget {
  const MisEjemplaresScreen({super.key});

  void abrirFormulario(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EjemplarFormScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Mis ejemplares')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => abrirFormulario(context),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Ejemplar>>(
        stream: ejemplarService.misEjemplares(uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final lista = snapshot.data!;
          if (lista.isEmpty) {
            return const Center(child: Text('Aún no tienes ejemplares'));
          }

          return ListView.builder(
            itemCount: lista.length,
            itemBuilder: (context, i) {
              final e = lista[i];
              return ListTile(
                leading: const Icon(Icons.bug_report, color: Colors.green),
                title: Text(e.nombre),
                subtitle: Text(
                  '${e.especieNombre} • ${e.fecha.day}/${e.fecha.month}/${e.fecha.year}',
                ),
                trailing: Icon(e.publico ? Icons.public : Icons.lock_outline),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EjemplarDetailScreen(ejemplar: e),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
