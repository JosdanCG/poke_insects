import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';

class Publicacion {
  final String id;
  final String uid;
  final String duenoNombre;
  final String ejemplarId;
  final String ejemplarNombre;
  final String especieNombre;
  final String comentario;
  final String foto; // imagen en texto base64
  final DateTime fecha;
  final bool publico;

  // Se convierte una sola vez para mostrar la imagen
  late final Uint8List? bytes = foto.isEmpty ? null : base64Decode(foto);

  Publicacion({
    required this.id,
    required this.uid,
    required this.duenoNombre,
    required this.ejemplarId,
    required this.ejemplarNombre,
    required this.especieNombre,
    required this.comentario,
    required this.foto,
    required this.fecha,
    required this.publico,
  });

  factory Publicacion.fromMap(String id, Map<String, dynamic> map) {
    return Publicacion(
      id: id,
      uid: map['uid'] ?? '',
      duenoNombre: map['duenoNombre'] ?? 'Anónimo',
      ejemplarId: map['ejemplarId'] ?? '',
      ejemplarNombre: map['ejemplarNombre'] ?? '',
      especieNombre: map['especieNombre'] ?? '',
      comentario: map['comentario'] ?? '',
      foto: map['foto'] ?? '',
      fecha: (map['fecha'] as Timestamp?)?.toDate() ?? DateTime.now(),
      publico: map['publico'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'duenoNombre': duenoNombre,
      'ejemplarId': ejemplarId,
      'ejemplarNombre': ejemplarNombre,
      'especieNombre': especieNombre,
      'comentario': comentario,
      'foto': foto,
      'fecha': Timestamp.fromDate(fecha),
      'publico': publico,
    };
  }
}
