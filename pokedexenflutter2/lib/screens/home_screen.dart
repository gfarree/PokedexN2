import 'package:flutter/material.dart';
import 'package:pokedexenflutter2/models/pokemon.dart';
import 'package:pokedexenflutter2/services/api_service.dart';
import 'package:pokedexenflutter2/widgets/pokemon_card.dart';
import 'package:pokedexenflutter2/screens/favorites_screen.dart';
import 'package:pokedexenflutter2/screens/details_screen.dart'; // Importar DetailsScreen
import 'package:pokedexenflutter2/services/local_storage.dart';
import 'package:provider/provider.dart';
import 'package:pokedexenflutter2/providers/theme_provider.dart';
import 'package:pokedexenflutter2/utils/pokemon_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Pokemon> _pokemons = [];
  List<Pokemon> _filteredPokemons = [];
  bool _isLoading = true;
  bool _isGridView = false; // Modo de vista
  String _selectedType = 'Todos'; // Tipo seleccionado para filtrar

  @override
  void initState() {
    super.initState();
    _fetchPokemons();
  }

  void _fetchPokemons() async {
    try {
      List<Pokemon> pokemons = await ApiService.fetchPokemons(limit: 50);
      setState(() {
        _pokemons = pokemons;
        _filteredPokemons = _reorganizePokemons(pokemons);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _searchPokemon(String query) async {
    final favorites = await LocalStorage.getFavorites();
    setState(() {
      _filteredPokemons = _reorganizePokemons(
        _pokemons.where((p) => p.name.toLowerCase().contains(query.toLowerCase())).toList(),
        favorites: favorites,
      );
    });
  }

  List<Pokemon> _reorganizePokemons(List<Pokemon> pokemons, {List<int>? favorites}) {
    favorites ??= [];
    List<Pokemon> favoritePokemons = pokemons.where((p) => favorites!.contains(p.id)).toList();
    List<Pokemon> nonFavoritePokemons = pokemons.where((p) => !favorites!.contains(p.id)).toList();
    return [...favoritePokemons, ...nonFavoritePokemons];
  }

  void _filterByType(String type) {
    setState(() {
      _selectedType = type;
      if (type == 'Todos') {
        _filteredPokemons = _reorganizePokemons(_pokemons);
      } else {
        _filteredPokemons = _reorganizePokemons(
          _pokemons.where((p) => p.types.map((t) => t.toLowerCase()).contains(type.toLowerCase())).toList(),
        );
      }
    });
  }

  void _showRandomPokemon() {
    if (_pokemons.isNotEmpty) {
      final random = _pokemons[DateTime.now().millisecondsSinceEpoch % _pokemons.length];
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailsScreen(pokemon: random)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay Pokémon disponibles')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Pokedex en Flutter'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.casino), // Ícono de casino para "aleatorio"
            onPressed: _showRandomPokemon,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: _searchPokemon,
                    decoration: InputDecoration(
                      hintText: 'Buscar un Pokémon...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                      filled: true,
                      fillColor: isDarkMode ? Colors.grey[900] : Colors.grey[200],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  ),
                  onPressed: () => _filterByType('Todos'),
                  child: const Text('Ver Todos'),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                for (var type in ['Todos', ...typeColors.keys])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(type),
                      selected: _selectedType == type,
                      onSelected: (_) => _filterByType(type),
                      backgroundColor: isDarkMode ? Colors.grey[800] : Colors.transparent,
                      selectedColor: typeColors[type.toLowerCase()] ?? Colors.grey,
                      labelStyle: TextStyle(
                        color: _selectedType == type
                            ? Colors.white
                            : isDarkMode
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: _selectedType == type ? Colors.transparent : isDarkMode ? Colors.white : Colors.grey,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _isGridView
                ? GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              itemCount: _filteredPokemons.length,
              itemBuilder: (context, index) {
                final pokemon = _filteredPokemons[index];
                return PokemonCard(
                  pokemon: pokemon,
                  onFavoriteChanged: () {
                    setState(() {
                      _filteredPokemons = _reorganizePokemons(_pokemons);
                    });
                  },
                );
              },
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredPokemons.length,
              itemBuilder: (context, index) {
                final pokemon = _filteredPokemons[index];
                return PokemonCard(
                  pokemon: pokemon,
                  onFavoriteChanged: () {
                    setState(() {
                      _filteredPokemons = _reorganizePokemons(_pokemons);
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}