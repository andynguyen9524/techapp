import 'package:flutter/material.dart';
import 'package:techapp/pokemon_detail/pokemon_detail_screen.dart';
import 'package:techapp/pokemon/pokemon_screen.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/PokemonScreen',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/PokemonScreen':
            return MaterialPageRoute(builder: (context) => PokemonScreen());
          case '/PokemonDetailScreen':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) =>
                  PokemonDetailScreen(pokemon: args['pokemon']),
            );
          default:
            return null;
        }
      },
    );
  }
}
