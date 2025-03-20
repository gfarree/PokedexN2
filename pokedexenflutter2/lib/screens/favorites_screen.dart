import 'package:flutter/material.dart';
import 'package:pokedexenflutter2/models/pokemon.dart';
import 'package:pokedexenflutter2/services/api_service.dart';
import 'package:pokedexenflutter2/services/local_storage.dart';
import 'package:pokedexenflutter2/widgets/pokemon_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Pokemon> _favoritePokemons = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() async {
    final favoriteIds = await LocalStorage.getFavorites();
    List<Pokemon> pokemons = [];
    for (int id in favoriteIds) {
      try {
        final response = await ApiService.fetchPokemonById(id);
        pokemons.add(response);
      } catch (e) {
        // Ignorar errores si no se puede cargar un Pokémon
      }
    }
    setState(() {
      _favoritePokemons = pokemons;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon Favoritos'),
      ),
      body: _favoritePokemons.isEmpty
          ? const Center(child: Text('No hay Pokémon favoritos'))
          : GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.9,
        ),
        itemCount: _favoritePokemons.length,
        itemBuilder: (context, index) {
          return PokemonCard(
            pokemon: _favoritePokemons[index],
            onFavoriteChanged: () {
              setState(() {
                _loadFavorites(); // Recargar la lista de favoritos
              });
            },
          );
        },
      ),
    );
  }
}