import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techapp/HomeScreen/home_controller.dart';
import 'package:techapp/HomeScreen/home_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeController()..initArticles(),
      child: HomeScreen(),
    );
  }
}
