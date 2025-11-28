import 'package:techapp/Model/pokemon_model.dart';
import 'package:dio/dio.dart';

class PokemonRepository {
  final Dio _dio;
  PokemonRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<List<Pokemon>> fetchPokemons({int limit = 100, int offset = 0}) async {
    try {
      final response = await _dio.get(
        'https://pokeapi.co/api/v2/pokemon',
        queryParameters: {'limit': limit, 'offset': offset},
      );
      if (response.statusCode == 200) {
        final List<dynamic> results = response.data['results'];
        return results.map((json) => Pokemon.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load pokemon list');
      }
    } catch (e) {
      throw Exception('Error fetching list: $e');
    }
  }

  Future<Pokemon> fetchPokemonDetail(Pokemon pokemon) async {
    try {
      final response = await _dio.get(pokemon.url);

      if (response.statusCode == 200) {
        return pokemon.copyWithDetail(response.data);
      } else {
        throw Exception('Failed to load details');
      }
    } catch (e) {
      throw Exception('Error fetching details: $e');
    }
  }
}
