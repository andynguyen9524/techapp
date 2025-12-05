import 'package:equatable/equatable.dart';
import 'package:techapp/model/pokemon_model.dart';

abstract class PokemonState extends Equatable {
  const PokemonState();
  @override
  List<Object> get props => [];
}

class PokemonInitial extends PokemonState {}

class PokemonLoading extends PokemonState {}

class PokemonLoadSuccess extends PokemonState {
  final List<Pokemon> pokemons;
  final int length;
  final bool loadingFlag;
  const PokemonLoadSuccess({
    this.pokemons = const [],
    this.length = 0,
    this.loadingFlag = false,
  });

  @override
  List<Object> get props => [pokemons, length, loadingFlag];
}

class PokemonDetail extends PokemonState {
  final Pokemon pokemon;
  const PokemonDetail({required this.pokemon});

  @override
  List<Object> get props => [pokemon];
}

class PokemonLoadFailure extends PokemonState {
  final String message;
  const PokemonLoadFailure({required this.message});
}

class SelectPokemonState extends PokemonState {
  final Pokemon selectedPokemon;
  const SelectPokemonState({required this.selectedPokemon});

  @override
  List<Object> get props => [selectedPokemon];
}

class ClearSelection extends PokemonState {}
