import 'package:techapp/News/article_model.dart';
import 'package:equatable/equatable.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object> get props => [];
}

class LoadingHomeState extends HomeState {}

class ErrorHomeState extends HomeState {
  final String message;

  const ErrorHomeState(this.message);
}

class ArticleLoadedState extends HomeState {
  final List<Article> articles;
  final int length;
  final bool hasReachedMax;

  const ArticleLoadedState({
    this.articles = const [],
    this.length = 0,
    this.hasReachedMax = false,
  });
  @override
  List<Object> get props => [articles, length, hasReachedMax];
}
// learn const in this file