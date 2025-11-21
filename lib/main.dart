import 'package:flutter/material.dart';
import 'package:techapp/Detail/article_detail_screen.dart';
import 'package:techapp/HomeScreen/home_page.dart';
import 'package:techapp/Login/login_screen.dart';
import 'package:techapp/Model/article_model.dart';
import 'package:techapp/Pokemon/pokemon_page.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/PokemonPage',
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
          case '/PokemonPage':
            return MaterialPageRoute(builder: (context) => PokemonPage());
          default:
            return null;
        }
      },
    );
  }
}
