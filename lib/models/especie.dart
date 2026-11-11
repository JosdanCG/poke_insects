const gruposEspecies = <String>[
  'Mantis',
  'Escarabajos',
  'Fásmidos',
  'Cucarachas',
  'Grillos y saltamontes',
  'Mariposas y polillas',
];

class Especie {
  final String id;
  final String nombreComun;
  final String nombreCientifico;
  final String grupo;
  final String descripcion;
  final String temperatura;
  final String humedad;
  final String dieta;
  final String mudas;
  final String dificultad;
  final String imagen; // enlace de la foto

  const Especie({
    required this.id,
    required this.nombreComun,
    required this.nombreCientifico,
    required this.grupo,
    required this.descripcion,
    required this.temperatura,
    required this.humedad,
    required this.dieta,
    required this.mudas,
    required this.dificultad,
    this.imagen = '',
  });

  factory Especie.fromMap(String id, Map<String, dynamic> map) {
    return Especie(
      id: id,
      nombreComun: (map['nombreComun'] ?? '') as String,
      nombreCientifico: (map['nombreCientifico'] ?? '') as String,
      grupo: (map['grupo'] ?? '') as String,
      descripcion: (map['descripcion'] ?? '') as String,
      temperatura: (map['temperatura'] ?? '') as String,
      humedad: (map['humedad'] ?? '') as String,
      dieta: (map['dieta'] ?? '') as String,
      mudas: (map['mudas'] ?? '') as String,
      dificultad: (map['dificultad'] ?? '') as String,
      imagen: (map['imagen'] ?? '') as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombreComun': nombreComun,
      'nombreCientifico': nombreCientifico,
      'grupo': grupo,
      'descripcion': descripcion,
      'temperatura': temperatura,
      'humedad': humedad,
      'dieta': dieta,
      'mudas': mudas,
      'dificultad': dificultad,
      'imagen': imagen,
    };
  }
}
