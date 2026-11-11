import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/ejemplar.dart';
import '../../models/especie.dart';
import '../../services/ejemplar_service.dart';
import '../../services/especie_service.dart';

class EjemplarFormScreen extends StatefulWidget {
  final Ejemplar? ejemplar; // si viene null, es un ejemplar nuevo

  const EjemplarFormScreen({super.key, this.ejemplar});

  @override
  State<EjemplarFormScreen> createState() => _EjemplarFormScreenState();
}

class _EjemplarFormScreenState extends State<EjemplarFormScreen> {
  final formKey = GlobalKey<FormState>();
  final nombreCtrl = TextEditingController();
  final notasCtrl = TextEditingController();

  List<Especie> especies = [];
  bool cargado = false;
  String? especieId;
  DateTime fecha = DateTime.now();
  bool publico = false;
  bool guardando = false;

  bool get editando => widget.ejemplar != null;

  @override
  void initState() {
    super.initState();
    final e = widget.ejemplar;
    if (e != null) {
      nombreCtrl.text = e.nombre;
      notasCtrl.text = e.notas;
      especieId = e.especieId;
      fecha = e.fecha;
      publico = e.publico;
    }
    cargarEspecies();
  }

  @override
  void dispose() {
    nombreCtrl.dispose();
    notasCtrl.dispose();
    super.dispose();
  }

  Future<void> cargarEspecies() async {
    final lista = await especieService.escuchar().first;
    if (!mounted) return;
    setState(() {
      especies = lista;
      cargado = true;
    });
  }

  Future<void> elegirFecha() async {
    final elegida = await showDatePicker(
      context: context,
      initialDate: fecha,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (elegida != null) setState(() => fecha = elegida);
  }

  Future<void> guardar() async {
    if (!formKey.currentState!.validate()) return;

    final especie = especies.firstWhere((e) => e.id == especieId);
    final ejemplar = Ejemplar(
      id: widget.ejemplar?.id ?? '',
      uid: FirebaseAuth.instance.currentUser!.uid,
      duenoNombre:
          FirebaseAuth.instance.currentUser!.displayName ?? 'Sin nombre',
      nombre: nombreCtrl.text.trim(),
      especieId: especie.id,
      especieNombre: especie.nombreComun,
      fecha: fecha,
      notas: notasCtrl.text.trim(),
      publico: publico,
    );

    setState(() => guardando = true);
    try {
      if (editando) {
        await ejemplarService.actualizar(ejemplar);
      } else {
        await ejemplarService.agregar(ejemplar);
      }
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => guardando = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
    }
  }

  Future<void> eliminar() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar ejemplar'),
        content: Text(
          '¿Seguro que quieres eliminar a ${widget.ejemplar!.nombre}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await ejemplarService.eliminar(widget.ejemplar!.id);
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(editando ? 'Editar ejemplar' : 'Nuevo ejemplar'),
        actions: [
          if (editando)
            IconButton(onPressed: eliminar, icon: const Icon(Icons.delete)),
        ],
      ),
      body: !cargado
          ? const Center(child: CircularProgressIndicator())
          : especies.isEmpty
          ? const Center(child: Text('Primero carga el catálogo de especies'))
          : Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: nombreCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => v == null || v.trim().isEmpty
                        ? 'Escribe un nombre'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: especieId,
                    decoration: const InputDecoration(
                      labelText: 'Especie',
                      border: OutlineInputBorder(),
                    ),
                    items: especies
                        .map(
                          (e) => DropdownMenuItem(
                            value: e.id,
                            child: Text(e.nombreComun),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => especieId = v),
                    validator: (v) => v == null ? 'Elige una especie' : null,
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Fecha de adquisición'),
                    subtitle: Text('${fecha.day}/${fecha.month}/${fecha.year}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: elegirFecha,
                  ),
                  TextFormField(
                    controller: notasCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Notas',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  guardando
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: guardar,
                          child: Text(editando ? 'Guardar cambios' : 'Agregar'),
                        ),
                ],
              ),
            ),
    );
  }
}
