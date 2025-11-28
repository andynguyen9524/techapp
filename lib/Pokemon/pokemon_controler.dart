import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techapp/Model/pokemon_model.dart';
import 'package:techapp/Model/pokemon_repository.dart';
import 'package:techapp/Pokemon/pokemon_state.dart';

class PokemonControler extends Cubit<PokemonState> {
  PokemonControler() : super(PokemonInitial());
  bool _loadingFlag = false;
  final repository = PokemonRepository();
  List<Pokemon> currentPokemons = [];

  Pokemon? selectedPokemon;

  Future selectPokemon(Pokemon pokemon) async {
    // return await repository.fetchPokemonDetail(pokemon);
    try {
      final detailedPokemon = await repository.fetchPokemonDetail(pokemon);
      selectedPokemon = detailedPokemon;
      emit(SelectPokemonState(selectedPokemon: detailedPokemon));
    } catch (e) {
      throw Exception('Error fetching details: $e');
    }
  }

  Future cleanSelection() async {
    selectedPokemon = null;
    emit(ClearSelection());
  }

  void currentListPokemons() {
    emit(
      PokemonLoadSuccess(
        pokemons: currentPokemons,
        length: currentPokemons.length,
        loadingFlag: true,
      ),
    );
  }

  Future fetchPokemon() async {
    // emit(PokemonLoading());
    if (_loadingFlag) return;
    _loadingFlag = true;

    if (currentPokemons.isEmpty) {
      final List<Pokemon> pokemons = await repository.fetchPokemons(
        limit: 15,
        offset: 0,
      );
      currentPokemons.addAll(pokemons);
    } else {
      final List<Pokemon> pokemons = await repository.fetchPokemons(
        limit: 2,
        offset: currentPokemons.length,
      );
      currentPokemons.addAll(pokemons);
    }

    await Future.delayed(const Duration(milliseconds: 900));
    emit(
      PokemonLoadSuccess(
        pokemons: currentPokemons,
        length: currentPokemons.length,
        loadingFlag: true,
      ),
    );

    _loadingFlag = false;
  }
}
