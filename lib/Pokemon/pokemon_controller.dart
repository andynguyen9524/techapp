import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techapp/Model/pokemon_model.dart';
import 'package:techapp/Model/pokemon_repository.dart';
import 'package:techapp/Pokemon/pokemon_state.dart';

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

    final List<Pokemon> newPokemons = await repository.fetchPokemons(
      limit: 10,
      offset: currentPokemons.length,
    );

    // Tải chi tiết song song cho danh sách mới
    final List<Pokemon> detailedPokemons = await Future.wait(
      newPokemons.map((pokemon) => repository.fetchPokemonDetail(pokemon)),
    );

    currentPokemons.addAll(detailedPokemons);
    emit(
      PokemonLoadSuccess(
        pokemons: currentPokemons,
        length: currentPokemons.length,
        loadingFlag: true,
      ),
    );
    await repository.saveLocalPokemonList(currentPokemons);
    _loadingFlag = false;
  }

  Future getPokemonFromCache() async {
    currentPokemons.clear();
    emit(PokemonLoading());
    currentPokemons = await repository.getLocalPokemonList();
    if (currentPokemons.isEmpty) {
      fetchPokemon();
    } else {
      emit(
        PokemonLoadSuccess(
          pokemons: currentPokemons,
          length: currentPokemons.length,
          loadingFlag: true,
        ),
      );
    }
  }
}
