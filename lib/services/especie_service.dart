import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/especies_iniciales.dart';
import '../models/especie.dart';

class EspecieService {
  final CollectionReference<Map<String, dynamic>> _col = FirebaseFirestore
      .instance
      .collection('especies');

  /// Escucha el catálogo en tiempo real, ordenado por nombre.
  Stream<List<Especie>> escuchar() {
    return _col
        .orderBy('nombreComun')
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => Especie.fromMap(d.id, d.data())).toList(),
        );
  }

  /// Carga las especies iniciales. Usa IDs fijos, así que si se
  /// ejecuta dos veces no duplica nada.
  Future<void> cargarCatalogoInicial() async {
    final batch = FirebaseFirestore.instance.batch();
    for (final item in especiesIniciales) {
      final id = item['id']!;
      final data = Map<String, dynamic>.from(item)..remove('id');
      batch.set(_col.doc(id), data);
    }
    await batch.commit();
  }
}

final especieService = EspecieService();
