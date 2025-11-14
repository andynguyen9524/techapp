import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techapp/Detail/article_detail_screen.dart';
import 'package:techapp/HomeScreen/home_controller.dart';
import 'package:techapp/HomeScreen/home_screen.dart';
import 'package:techapp/Login/login_screen.dart';
import 'package:techapp/News/article_model.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/LoginScreen',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/LoginScreen':
            return MaterialPageRoute(builder: (context) => LoginScreen());
          case '/HomeScreen':
            return MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => HomeController()..onfetchHome(),
                child: HomeScreen(),
              ),
            );
          case '/ArticleDetailScreen':
            final args = settings.arguments as Article;
            return MaterialPageRoute(
              builder: (context) => ArticleDetailScreen(article: args),
            );
          default:
            return null;
        }
      },
    );
  }
}
