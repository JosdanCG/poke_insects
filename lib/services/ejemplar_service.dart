import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/ejemplar.dart';

class EjemplarService {
  final CollectionReference<Map<String, dynamic>> _col = FirebaseFirestore
      .instance
      .collection('ejemplares');

  // Se ordena aquí para no pedir índices en Firestore
  Stream<List<Ejemplar>> misEjemplares(String uid) {
    return _col.where('uid', isEqualTo: uid).snapshots().map((snap) {
      final lista = snap.docs
          .map((d) => Ejemplar.fromMap(d.id, d.data()))
          .toList();
      lista.sort(
        (a, b) => a.nombre.toLowerCase().compareTo(b.nombre.toLowerCase()),
      );
      return lista;
    });
  }

  // Ejemplares que sus dueños marcaron como públicos
  Stream<List<Ejemplar>> publicos() {
    return _col.where('publico', isEqualTo: true).snapshots().map((snap) {
      final lista = snap.docs
          .map((d) => Ejemplar.fromMap(d.id, d.data()))
          .toList();
      lista.sort((a, b) => b.fecha.compareTo(a.fecha));
      return lista;
    });
  }

  Future<void> agregar(Ejemplar e) => _col.add(e.toMap());

  Future<void> actualizar(Ejemplar e) => _col.doc(e.id).update(e.toMap());

  Future<void> eliminar(String id) => _col.doc(id).delete();
}

final ejemplarService = EjemplarService();
