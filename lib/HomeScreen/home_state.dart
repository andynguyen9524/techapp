import 'package:techapp/News/article_model.dart';

abstract class HomeState {}

class LoadingHomeState extends HomeState {}

class InfoHomeState extends HomeState {}

class ErrorHomeState extends HomeState {
  final String message;

  ErrorHomeState(this.message);
}

class ArticleLoadedState extends HomeState {
  final Article articles;

  ArticleLoadedState(this.articles);
}
