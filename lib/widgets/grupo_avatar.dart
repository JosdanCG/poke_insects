import 'package:flutter/material.dart';

class GrupoAvatar extends StatelessWidget {
  final String grupo;
  final double radius;

  const GrupoAvatar({super.key, required this.grupo, this.radius = 24});

  Color _color() {
    switch (grupo) {
      case 'Mantis':
        return Colors.green;
      case 'Escarabajos':
        return Colors.brown;
      case 'Fásmidos':
        return Colors.lightGreen.shade700;
      case 'Cucarachas':
        return Colors.deepOrange;
      case 'Grillos y saltamontes':
        return Colors.amber.shade800;
      case 'Mariposas y polillas':
        return Colors.purple;
      default:
        return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: _color(),
      child: Icon(Icons.bug_report, color: Colors.white, size: radius),
    );
  }
}
