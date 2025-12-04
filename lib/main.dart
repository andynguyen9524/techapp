import 'package:flutter/material.dart';
import 'package:techapp/Detail/article_detail_screen.dart';
import 'package:techapp/HomeScreen/home_page.dart';
import 'package:techapp/Login/login_screen.dart';
import 'package:techapp/Model/article_model.dart';
import 'package:techapp/Pokemon/pokemon_screen.dart';
import 'PokemonDetail/pokemon_detail_screen.dart';

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
          case '/LoginScreen':
            return MaterialPageRoute(builder: (context) => LoginScreen());
          case '/HomePage':
            return MaterialPageRoute(builder: (context) => HomePage());
          case '/ArticleDetailScreen':
            final args = settings.arguments as Article;
            return MaterialPageRoute(
              builder: (context) => ArticleDetailScreen(article: args),
            );
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
