import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class ApiService {
  static const String baseUrl = 'https://pokeapi.co/api/v2';

  // Método para obtener una lista de Pokémon
  static Future<List<Pokemon>> fetchPokemons({int limit = 20}) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon?limit=$limit'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> results = data['results'];

      List<Pokemon> pokemons = [];
      for (int i = 0; i < results.length; i++) {
        final pokemonResponse = await http.get(Uri.parse(results[i]['url']));
        if (pokemonResponse.statusCode == 200) {
          final pokemonData = jsonDecode(pokemonResponse.body);
          pokemons.add(Pokemon.fromJson(pokemonData));
        }
      }

      return pokemons;
    } else {
      throw Exception('Error al obtener los Pokémon');
    }
  }

  // Método para obtener un Pokémon por su ID
  static Future<Pokemon> fetchPokemonById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/pokemon/$id'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Pokemon.fromJson(data);
    } else {
      throw Exception('Error al obtener el Pokémon con ID $id');
    }
  }
}