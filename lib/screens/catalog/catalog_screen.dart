import 'package:flutter/material.dart';

import '../../models/especie.dart';
import '../../services/especie_service.dart';
import '../../widgets/especie_imagen.dart';
import 'especie_detail_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final controller = PageController(viewportFraction: 0.8);
  String texto = '';
  String? grupoSeleccionado;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // Al cambiar el filtro, el carrusel vuelve a la primera tarjeta
  void volverAlInicio() {
    if (controller.hasClients) controller.jumpToPage(0);
  }

  List<Especie> filtrar(List<Especie> especies) {
    return especies.where((e) {
      final porGrupo =
          grupoSeleccionado == null || e.grupo == grupoSeleccionado;
      final busqueda = texto.toLowerCase();
      final porTexto =
          e.nombreComun.toLowerCase().contains(busqueda) ||
          e.nombreCientifico.toLowerCase().contains(busqueda);
      return porGrupo && porTexto;
    }).toList();
  }

  Widget filtroGrupo(String nombre, String? valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(nombre),
        selected: grupoSeleccionado == valor,
        onSelected: (_) {
          setState(() => grupoSeleccionado = valor);
          volverAlInicio();
        },
      ),
    );
  }

  Widget tarjeta(Especie especie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EspecieDetailScreen(especie: especie),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.fromLTRB(8, 12, 8, 24),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: EspecieImagen(especie: especie)),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    especie.nombreComun,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    especie.nombreCientifico,
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                  Text('${especie.grupo} • ${especie.dificultad}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catálogo')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar especie',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (valor) {
                setState(() => texto = valor);
                volverAlInicio();
              },
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                filtroGrupo('Todos', null),
                for (final g in gruposEspecies) filtroGrupo(g, g),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Especie>>(
              stream: especieService.escuchar(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final todas = snapshot.data!;

                // Si no hay especies, se cargan las iniciales una sola vez
                if (todas.isEmpty) {
                  return Center(
                    child: ElevatedButton(
                      onPressed: () => especieService.cargarCatalogoInicial(),
                      child: const Text('Cargar catálogo inicial'),
                    ),
                  );
                }

                final lista = filtrar(todas);
                if (lista.isEmpty) {
                  return const Center(
                    child: Text('No se encontraron especies'),
                  );
                }

                return PageView.builder(
                  controller: controller,
                  itemCount: lista.length,
                  itemBuilder: (context, i) => tarjeta(lista[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
