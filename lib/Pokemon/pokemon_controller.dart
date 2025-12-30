import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techapp/model/pokemon_model.dart';
import 'package:techapp/model/pokemon_repository.dart';
import 'package:techapp/pokemon/pokemon_state.dart';

class PokemonController extends Cubit<PokemonState> {
  PokemonController() : super(PokemonInitial());
  bool _loadingFlag = false;
  final repository = PokemonRepository();
  List<Pokemon> currentPokemons = [];
  Pokemon? selectedPokemon;

  Future selectPokemon(Pokemon pokemon) async {
    // return await repository.fetchPokemonDetail(pokemon);
    try {
      emit(PokemonLoading());
      emit(SelectPokemonState(selectedPokemon: pokemon));
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

  List<Pokemon> _allCachedPokemons = [];

  Future fetchPokemon() async {
    if (currentPokemons.isEmpty) {
      emit(PokemonLoading());
    } else {
      emit(
        PokemonLoadSuccess(
          pokemons: currentPokemons,
          length: currentPokemons.length,
          loadingFlag: true,
        ),
      );
    }
    if (_loadingFlag) return;
    _loadingFlag = true;

    if (currentPokemons.length < _allCachedPokemons.length) {
      final int remaining = _allCachedPokemons.length - currentPokemons.length;
      final int takeCount = remaining > 10 ? 10 : remaining;
      Future.delayed(const Duration(milliseconds: 2000));
      final nextChunk = _allCachedPokemons.sublist(
        currentPokemons.length,
        currentPokemons.length + takeCount,
      );

      currentPokemons.addAll(nextChunk);
      _emitSuccess();
      _loadingFlag = false;
      return;
    }

    try {
      final List<Pokemon> newPokemons = await repository.fetchPokemons(
        limit: 10,
        offset: currentPokemons.length,
      );

      final List<Pokemon> detailedPokemons = await Future.wait(
        newPokemons.map((pokemon) => repository.fetchPokemonDetail(pokemon)),
      );

      // Append to both lists
      currentPokemons.addAll(detailedPokemons);
      _allCachedPokemons.addAll(detailedPokemons);

      _emitSuccess();

      // Save updated full list to disk
      await repository.saveLocalPokemonList(_allCachedPokemons);
    } catch (e) {
      // Handle error appropriately
    } finally {
      _loadingFlag = false;
    }
  }

  void _emitSuccess() {
    emit(
      PokemonLoadSuccess(
        pokemons: currentPokemons,
        length: currentPokemons.length,
        loadingFlag: true,
      ),
    );
  }

  Future getPokemonFromCache() async {
    currentPokemons.clear();
    _allCachedPokemons.clear();
    emit(PokemonLoading());

    final localList = await repository.getLocalPokemonList();
    _allCachedPokemons = localList;

    await fetchPokemon();
  }
}
