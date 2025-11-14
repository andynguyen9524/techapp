import 'package:techapp/News/article_model.dart';

abstract class HomeState {}

class LoadingHomeState extends HomeState {}

class InfoHomeState extends HomeState {}

class ErrorHomeState extends HomeState {
  final String message;

  ErrorHomeState(this.message);
}

class ArticleLoadedState extends HomeState {
  final List<Article> articles;
  final bool isLoadingMore = true;
  final bool hasReachedMax = false;

  ArticleLoadedState({
    required this.articles,
    required isLoadMore,
    required hasReachedMax,
  });
}

class FullLoadingState extends HomeState {}

class NeedLoadMoreState extends HomeState {}

// class ArticleLoadedState extends HomeState {
//   final List<Article> articles;
//   final bool hasReachedMax;
//   final bool isLoadingMore;

//   ArticleLoadedState({
//     required this.articles,
//     this.hasReachedMax = false,
//     this.isLoadingMore = false,
//   });

//   ArticleLoadedState copyWith({
//     List<Article>? articles,
//     bool? hasReachedMax,
//     bool? isLoadingMore,
//   }) {
//     return ArticleLoadedState(
//       articles: articles ?? this.articles,
//       hasReachedMax: hasReachedMax ?? this.hasReachedMax,
//       isLoadingMore: isLoadingMore ?? this.isLoadingMore,
//     );
//   }
// }
