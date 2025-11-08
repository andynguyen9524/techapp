import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techapp/Detail/article_detail_screen.dart';
import 'package:techapp/HomeScreen/home_screen.dart';
import 'package:techapp/Login/login_controller.dart';
import 'package:techapp/Login/login_screen.dart';

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
      routes: {
        '/LoginScreen': (context) => BlocProvider(
          create: (context) => LoginController()..onfetchLogin(),
          child: LoginScreen(),
        ),
        '/HomeScreen': (context) => HomeScreen(),
      },
    );
  }
}
