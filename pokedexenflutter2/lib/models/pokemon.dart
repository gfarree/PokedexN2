class Pokemon {
  final String name;
  final String imageUrl;
  final int id;
  final double height;
  final double weight;
  final List<String> types;
  final Map<String, int> stats;

  Pokemon({
    required this.name,
    required this.imageUrl,
    required this.id,
    required this.height,
    required this.weight,
    required this.types,
    required this.stats,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      id: json['id'],
      imageUrl: json['sprites']['other']['official-artwork']['front_default'] ?? '',
      height: (json['height'] ?? 0) / 10.0,
      weight: (json['weight'] ?? 0) / 10.0,
      types: (json['types'] as List)
          .map((t) => t['type']['name'] as String)
          .toList(),
      stats: {
        for (var stat in json['stats'])
          stat['stat']['name']: stat['base_stat'],
      },
    );
  }
}
