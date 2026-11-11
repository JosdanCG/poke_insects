import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/ejemplar.dart';
import '../../models/publicacion.dart';
import '../../services/publicacion_service.dart';

class NuevaPublicacionScreen extends StatefulWidget {
  final Ejemplar ejemplar;

  const NuevaPublicacionScreen({super.key, required this.ejemplar});

  @override
  State<NuevaPublicacionScreen> createState() => _NuevaPublicacionScreenState();
}

class _NuevaPublicacionScreenState extends State<NuevaPublicacionScreen> {
  final comentarioCtrl = TextEditingController();
  Uint8List? fotoBytes;
  bool compartir = true;
  bool guardando = false;

  @override
  void dispose() {
    comentarioCtrl.dispose();
    super.dispose();
  }

  // La foto se reduce para que quepa en Firestore
  Future<void> elegirFoto(ImageSource origen) async {
    final imagen = await ImagePicker().pickImage(
      source: origen,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 60,
    );
    if (imagen == null) return;
    final bytes = await imagen.readAsBytes();
    if (!mounted) return;
    setState(() => fotoBytes = bytes);
  }

  void mostrarMensaje(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  Future<void> publicar() async {
    if (fotoBytes == null) {
      mostrarMensaje('Agrega una foto');
      return;
    }
    if (fotoBytes!.length > 700000) {
      mostrarMensaje('La foto es muy pesada, elige otra');
      return;
    }

    final user = FirebaseAuth.instance.currentUser!;
    final e = widget.ejemplar;

    setState(() => guardando = true);
    try {
      await publicacionService.agregar(
        Publicacion(
          id: '',
          uid: user.uid,
          duenoNombre: user.displayName ?? 'Sin nombre',
          ejemplarId: e.id,
          ejemplarNombre: e.nombre,
          especieNombre: e.especieNombre,
          comentario: comentarioCtrl.text.trim(),
          foto: base64Encode(fotoBytes!),
          fecha: DateTime.now(),
          publico: compartir,
        ),
      );
      if (!mounted) return;
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      setState(() => guardando = false);
      mostrarMensaje('Error al publicar: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Publicar de ${widget.ejemplar.nombre}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 240,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: fotoBytes == null
                ? const Center(child: Text('Aún no hay foto'))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      fotoBytes!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => elegirFoto(ImageSource.gallery),
                  icon: const Icon(Icons.photo),
                  label: const Text('Galería'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => elegirFoto(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Cámara'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: comentarioCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: '¿Qué hiciste hoy con tu ejemplar?',
              border: OutlineInputBorder(),
            ),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Compartir en Comunidad'),
            subtitle: const Text('Si lo apagas, solo tú la verás'),
            value: compartir,
            onChanged: (v) => setState(() => compartir = v),
          ),
          const SizedBox(height: 8),
          guardando
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: publicar,
                  child: const Text('Publicar'),
                ),
        ],
      ),
    );
  }
}
