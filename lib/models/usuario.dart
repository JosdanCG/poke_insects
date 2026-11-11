import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  final String uid;
  final String nombre;
  final String email;
  final String? fotoUrl;
  final DateTime? creadoEn;

  const Usuario({
    required this.uid,
    required this.nombre,
    required this.email,
    this.fotoUrl,
    this.creadoEn,
  });

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      uid: map['uid'] as String,
      nombre: (map['nombre'] ?? '') as String,
      email: (map['email'] ?? '') as String,
      fotoUrl: map['fotoUrl'] as String?,
      creadoEn: (map['creadoEn'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'nombre': nombre, 'email': email, 'fotoUrl': fotoUrl};
  }
}
