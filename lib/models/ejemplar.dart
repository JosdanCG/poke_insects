import 'package:cloud_firestore/cloud_firestore.dart';

class Ejemplar {
  final String id;
  final String uid;
  final String duenoNombre;
  final String nombre;
  final String especieId;
  final String especieNombre;
  final DateTime fecha;
  final String notas;
  final bool publico;

  Ejemplar({
    required this.id,
    required this.uid,
    required this.duenoNombre,
    required this.nombre,
    required this.especieId,
    required this.especieNombre,
    required this.fecha,
    required this.notas,
    required this.publico,
  });

  factory Ejemplar.fromMap(String id, Map<String, dynamic> map) {
    return Ejemplar(
      id: id,
      uid: map['uid'] ?? '',
      duenoNombre: map['duenoNombre'] ?? 'Anónimo',
      nombre: map['nombre'] ?? '',
      especieId: map['especieId'] ?? '',
      especieNombre: map['especieNombre'] ?? '',
      fecha: (map['fecha'] as Timestamp?)?.toDate() ?? DateTime.now(),
      notas: map['notas'] ?? '',
      publico: map['publico'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'duenoNombre': duenoNombre,
      'nombre': nombre,
      'especieId': especieId,
      'especieNombre': especieNombre,
      'fecha': Timestamp.fromDate(fecha),
      'notas': notas,
      'publico': publico,
    };
  }
}
