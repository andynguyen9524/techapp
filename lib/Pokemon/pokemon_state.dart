import 'package:equatable/equatable.dart';
import 'package:techapp/Model/pokemon_model.dart';

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

class PokemonLoadFailure extends PokemonState {
  final String message;
  const PokemonLoadFailure({required this.message});
}
