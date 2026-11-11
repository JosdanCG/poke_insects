import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/publicacion.dart';

class PublicacionService {
  final CollectionReference<Map<String, dynamic>> _col = FirebaseFirestore
      .instance
      .collection('publicaciones');

  // Convierte los documentos en lista y deja primero las más nuevas
  List<Publicacion> _aLista(QuerySnapshot<Map<String, dynamic>> snap) {
    final lista = snap.docs
        .map((d) => Publicacion.fromMap(d.id, d.data()))
        .toList();
    lista.sort((a, b) => b.fecha.compareTo(a.fecha));
    return lista;
  }

  // Feed de Comunidad: solo las publicaciones compartidas
  Stream<List<Publicacion>> feed() {
    return _col.where('publico', isEqualTo: true).snapshots().map(_aLista);
  }

  // Publicaciones de un ejemplar mío
  Stream<List<Publicacion>> deEjemplar(String uid, String ejemplarId) {
    return _col
        .where('uid', isEqualTo: uid)
        .where('ejemplarId', isEqualTo: ejemplarId)
        .snapshots()
        .map(_aLista);
  }

  Future<void> agregar(Publicacion p) => _col.add(p.toMap());

  Future<void> eliminar(String id) => _col.doc(id).delete();
}

final publicacionService = PublicacionService();
