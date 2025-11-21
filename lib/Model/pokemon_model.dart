class Pokemon {
  final String name;
  final String url;
  final int? height;
  final int? weight;
  final List<String>? types;
  final List<Map<String, dynamic>>? stats;

  Pokemon({
    required this.name,
    required this.url,
    this.height,
    this.weight,
    this.types,
    this.stats,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(name: json['name'], url: json['url']);
  }

  Pokemon copyWithDetail(Map<String, dynamic> json) {
    return Pokemon(
      name: name,
      url: url,
      height: json['height'],
      weight: json['weight'],
      types: (json['types'] as List)
          .map((e) => e['type']['name'] as String)
          .toList(),
      stats: (json['stats'] as List).map((e) {
        return {'name': e['stat']['name'], 'value': e['base_stat']};
      }).toList(),
    );
  }

  int get id {
    final parts = url.split('/');
    return int.tryParse(parts[parts.length - 2]) ?? 0;
  }

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
}
