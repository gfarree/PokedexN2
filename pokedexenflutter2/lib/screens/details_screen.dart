import 'package:flutter/material.dart';
import 'package:pokedexenflutter2/models/pokemon.dart';
import 'package:pokedexenflutter2/utils/pokemon_colors.dart';

class DetailsScreen extends StatelessWidget {
  final Pokemon pokemon;

  const DetailsScreen({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = (pokemon.types.isNotEmpty)
        ? typeColors[pokemon.types.first.toLowerCase()] ?? Colors.grey
        : Colors.grey;

    return Scaffold(
      backgroundColor: backgroundColor.withOpacity(0.8),
      body: Stack(
        children: [
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 30, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(
                    tag: pokemon.id,
                    child: Image.network(
                      pokemon.imageUrl,
                      height: 200,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error, size: 100, color: Colors.white);
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '#${pokemon.id.toString().padLeft(3, '0')} ${pokemon.name}',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Altura: ${pokemon.height} m | Peso: ${pokemon.weight} kg',
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 8,
                    children: pokemon.types
                        .map((type) => Chip(
                      label: Text(type, style: const TextStyle(color: Colors.white)),
                      backgroundColor: typeColors[type.toLowerCase()]?.withOpacity(0.8) ?? Colors.grey,
                    ))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Estadísticas',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        ...pokemon.stats.entries.map((stat) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(stat.key, style: const TextStyle(fontSize: 16, color: Colors.white)),
                              Text(
                                stat.value.toString(),
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
