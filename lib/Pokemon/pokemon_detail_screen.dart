import 'package:flutter/material.dart';
import 'package:techapp/Model/pokemon_model.dart';

class PokemonDetailScreen extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonDetailScreen({super.key, required this.pokemon});

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  String capitalize(String s) =>
      s.isNotEmpty ? '${s[0].toUpperCase()}${s.substring(1)}' : s;

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
        return Colors.orangeAccent;
      case 'water':
        return Colors.blueAccent;
      case 'grass':
        return Colors.green;
      case 'electric':
        return Colors.yellow[700]!;
      case 'psychic':
        return Colors.purpleAccent;
      case 'poison':
        return Colors.purple;
      case 'ground':
        return Colors.brown;
      case 'rock':
        return Colors.grey;
      case 'fairy':
        return Colors.pinkAccent;
      default:
        return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor =
        widget.pokemon.types != null && widget.pokemon.types!.isNotEmpty
        ? _getTypeColor(widget.pokemon.types!.first)
        : Colors.blue;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          capitalize(widget.pokemon.name),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100),
            Container(
              height: 250,
              // decoration: BoxDecoration(
              //   color: primaryColor,
              //   borderRadius: const BorderRadius.only(
              //     bottomLeft: Radius.circular(30),
              //     bottomRight: Radius.circular(30),
              //   ),
              // ),
              child: Column(
                children: [
                  Image.network(
                    widget.pokemon.imageUrl ?? '',
                    height: 200,
                    fit: BoxFit.contain,

                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 6,
                          backgroundColor: Color.fromARGB(255, 255, 0, 4),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.error, size: 100, color: Colors.white),
                  ),
                ],
              ),
            ),

            // const SizedBox(height: 20),

            // --- PHẦN 2: THÔNG TIN CƠ BẢN (Type, Height, Weight) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // List Types
                  if (widget.pokemon.types != null)
                    Wrap(
                      spacing: 8.0,
                      children: widget.pokemon.types!.map((type) {
                        return Chip(
                          label: Text(
                            capitalize(type),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: _getTypeColor(type),
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 20),

                  // Height & Weight Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildInfoColumn(
                            "Chiều cao",
                            "${(widget.pokemon.height ?? 0) / 10} m",
                          ),
                          Container(
                            height: 40,
                            width: 1,
                            color: Colors.grey[300],
                          ),
                          _buildInfoColumn(
                            "Cân nặng",
                            "${(widget.pokemon.weight ?? 0) / 10} kg",
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- PHẦN 3: BASE STATS ---
            if (widget.pokemon.stats != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Chỉ số cơ bản (Base Stats)",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: widget.pokemon.stats!.map((statMap) {
                            String statName = statMap['name'];
                            int statValue = statMap['value'];
                            return _buildStatRow(
                              statName,
                              statValue,
                              primaryColor,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            // --- PHẦN 4: KHẢ NĂNG ĐẶC BIỆT (Abilities) ---
            Container(child: showSpike(widget.pokemon)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildStatRow(String name, int value, Color color) {
    String displayName = name;
    if (name == 'hp') displayName = 'HP';
    if (name == 'attack') displayName = 'ATK';
    if (name == 'defense') displayName = 'DEF';
    if (name == 'special-attack') displayName = 'S-ATK';
    if (name == 'special-defense') displayName = 'S-DEF';
    if (name == 'speed') displayName = 'SPD';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              displayName.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              "$value",
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: LinearProgressIndicator(
                value: value / 200, // Giả sử max stat là 200
                backgroundColor: Colors.grey[200],
                color: value > 100
                    ? Colors.green
                    : (value > 50 ? color : Colors.red),
                minHeight: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget showSpike(Pokemon pokemon) {
    final List<String> sprites =
        [
              pokemon.frontDefault,
              pokemon.backDefault,
              pokemon.frontShiny,
              pokemon.backShiny,
              pokemon.frontFemale,
              pokemon.backFemale,
              pokemon.frontShinyFemale,
              pokemon.backShinyFemale,
            ]
            .whereType<String>()
            .toList(); // .whereType<String>() sẽ tự động loại bỏ null

    // Nếu không có ảnh nào thì không hiển thị gì cả
    if (sprites.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Sprites",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: sprites.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              return Container(
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Image.network(
                  sprites[index],
                  fit: BoxFit.contain,
                  // Hiển thị icon mặc định nếu ảnh lỗi
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.catching_pokemon, color: Colors.grey),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
