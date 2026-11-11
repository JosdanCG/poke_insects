import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/usuario.dart';

class UserService {
  final CollectionReference<Map<String, dynamic>> _col = FirebaseFirestore
      .instance
      .collection('usuarios');

  Future<void> guardarSiNoExiste(User user) async {
    final ref = _col.doc(user.uid);
    final doc = await ref.get();

    if (!doc.exists) {
      final nuevo = Usuario(
        uid: user.uid,
        nombre: user.displayName ?? 'Sin nombre',
        email: user.email ?? '',
        fotoUrl: user.photoURL,
      );
      await ref.set({
        ...nuevo.toMap(),
        'creadoEn': FieldValue.serverTimestamp(),
        'ultimoAcceso': FieldValue.serverTimestamp(),
      });
    } else {
      await ref.update({'ultimoAcceso': FieldValue.serverTimestamp()});
    }
  }

  Future<Usuario?> obtener(String uid) async {
    final doc = await _col.doc(uid).get();
    if (!doc.exists) return null;
    return Usuario.fromMap(doc.data()!);
  }
}

final userService = UserService();
