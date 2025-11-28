class Pokemon {
  final String name;
  final String url;
  final int? height;
  final int? weight;
  final List<String>? types;
  final List<Map<String, dynamic>>? stats;
  final String? imageUrl;

  // Các sprites bổ sung
  final String? backDefault;
  final String? backFemale;
  final String? backShiny;
  final String? backShinyFemale;
  final String? frontDefault;
  final String? frontFemale;
  final String? frontShiny;
  final String? frontShinyFemale;

  Pokemon({
    required this.name,
    required this.url,
    this.height,
    this.weight,
    this.types,
    this.stats,
    this.imageUrl,

    this.backDefault,
    this.backFemale,
    this.backShiny,
    this.backShinyFemale,
    this.frontDefault,
    this.frontFemale,
    this.frontShiny,
    this.frontShinyFemale,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(name: json['name'], url: json['url']);
  }

  Pokemon copyWithDetail(Map<String, dynamic> json) {
    final sprites = json['sprites'];
    String imgUrl = '';
    try {
      imgUrl = sprites['other']['official-artwork']['front_default'];
    } catch (e) {
      imgUrl = sprites['front_default'] ?? '';
    }

    return Pokemon(
      name: name,
      url: url,
      imageUrl: imgUrl,
      height: json['height'],
      weight: json['weight'],
      types: (json['types'] as List)
          .map((e) => e['type']['name'] as String)
          .toList(),
      stats: (json['stats'] as List).map((e) {
        return {'name': e['stat']['name'], 'value': e['base_stat']};
      }).toList(),
      backDefault: sprites['back_default'],
      backFemale: sprites['back_female'],
      backShiny: sprites['back_shiny'],
      backShinyFemale: sprites['back_shiny_female'],
      frontDefault: sprites['front_default'],
      frontFemale: sprites['front_female'],
      frontShiny: sprites['front_shiny'],
      frontShinyFemale: sprites['front_shiny_female'],
    );
  }

  int get id {
    final parts = url.split('/');
    return int.tryParse(parts[parts.length - 2]) ?? 0;
  }

  String get imageAvatarUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
}
