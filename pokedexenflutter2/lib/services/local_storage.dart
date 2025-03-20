import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> saveFavorite(int id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    if (!favorites.contains(id.toString())) {
      favorites.add(id.toString());
      await prefs.setStringList('favorites', favorites);
    }
  }

  static Future<List<int>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList('favorites') ?? []).map(int.parse).toList();
  }

  static Future<void> removeFavorite(int id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];
    favorites.remove(id.toString());
    await prefs.setStringList('favorites', favorites);
  }
}