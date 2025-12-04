import 'package:techapp/Model/pokemon_model.dart';
import 'package:dio/dio.dart';
import 'dart:convert'; // Cần để mã hóa/giải mã JSON
import 'package:shared_preferences/shared_preferences.dart'; // Lưu trữ cục bộ

class PokemonRepository {
  final Dio _dio;
  static const String _listStorageKey = 'pokemon_list_cache';
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

  Future<void> saveLocalPokemonList(List<Pokemon> list) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String jsonString = jsonEncode(
        list.map((e) => e.toJson()).toList(),
      );
      await prefs.setString(_listStorageKey, jsonString);
    } catch (e) {
      print('Lỗi lưu cache list: $e');
    }
  }

  Future<List<Pokemon>> getLocalPokemonList() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString('pokemon_list_cache');

      if (jsonString != null) {
        // 1. Decode chuỗi JSON thành List<dynamic>
        final List<dynamic> jsonList = jsonDecode(jsonString);

        // 2. Dùng .map để biến đổi từng phần tử JSON thành object Pokemon
        return jsonList
            .map((jsonItem) => Pokemon.fromCacheJson(jsonItem))
            .toList();
      }
    } catch (e) {
      print('Lỗi đọc cache: $e');
    }
    return [];
  }
}
