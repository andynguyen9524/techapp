abstract class HomeState {}

class LoadingHomeState extends HomeState {}

class InfoHomeState extends HomeState {}

class ErrorHomeState extends HomeState {
  final String message;

  ErrorHomeState(this.message);
}

class ArticleLoadedState extends HomeState {
  final List articles;

  ArticleLoadedState(this.articles);
}
