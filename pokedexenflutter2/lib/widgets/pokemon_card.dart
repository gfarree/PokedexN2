import 'package:flutter/material.dart';
import 'package:pokedexenflutter2/models/pokemon.dart';
import 'package:pokedexenflutter2/utils/pokemon_colors.dart';
import 'package:pokedexenflutter2/services/local_storage.dart';
import 'package:pokedexenflutter2/screens/details_screen.dart';

class PokemonCard extends StatefulWidget {
  final Pokemon pokemon;
  final VoidCallback onFavoriteChanged;

  const PokemonCard({super.key, required this.pokemon, required this.onFavoriteChanged});

  @override
  _PokemonCardState createState() => _PokemonCardState();
}

class _PokemonCardState extends State<PokemonCard> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  void _checkIfFavorite() async {
    final favorites = await LocalStorage.getFavorites();
    setState(() {
      _isFavorite = favorites.contains(widget.pokemon.id);
    });
  }

  void _toggleFavorite() async {
    if (_isFavorite) {
      await LocalStorage.removeFavorite(widget.pokemon.id);
    } else {
      await LocalStorage.saveFavorite(widget.pokemon.id);
    }
    widget.onFavoriteChanged(); // Notificar cambio en favoritos
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = (widget.pokemon.types.isNotEmpty)
        ? typeColors[widget.pokemon.types.first.toLowerCase()] ?? Colors.grey
        : Colors.grey;

    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: backgroundColor, width: 2),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsScreen(pokemon: widget.pokemon),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Image.network(
                    widget.pokemon.imageUrl,
                    height: 60, // Ajustar tamaño de la imagen
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error, size: 30, color: Colors.white);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.star : Icons.star_border,
                      color: Colors.yellow,
                      size: 24, // Aumentar tamaño del ícono
                    ),
                    onPressed: _toggleFavorite,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '#${widget.pokemon.id.toString().padLeft(3, '0')} ${widget.pokemon.name}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}