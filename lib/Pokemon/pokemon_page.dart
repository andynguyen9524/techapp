import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techapp/Pokemon/pokemon_controler.dart';
import 'package:techapp/Pokemon/pokemon_screen.dart';

class PokemonPage extends StatelessWidget {
  const PokemonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PokemonControler()..fetchPokemon(),
      child: PokemonScreen(),
    );
  }
}
