import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techapp/HomeScreen/home_state.dart';
import 'package:techapp/News/article_model.dart';
import 'package:techapp/News/news_repository.dart';

class HomeController extends Cubit<HomeState> {
  HomeController() : super(LoadingHomeState());
  final repository = NewsRepository();

  int currentPage = 2;
  int pageSize = 5;
  List<Article> _currentArticles = [];
  List<Article> totalArticles = [];
  Future<void> onfetchHome() async {
    emit(LoadingHomeState());
    try {
      final articles = await repository.fetchNews();
      totalArticles = articles;
      _currentArticles = totalArticles.skip(0).take(5).toList();
      emit(
        ArticleLoadedState(
          articles: _currentArticles,
          isLoadMore: true,
          hasReachedMax: false,
        ),
      );
    } catch (error) {
      emit(ErrorHomeState(error.toString()));
    }
  }

  Future<void> needLoadHomeMore() async {
    await Future.delayed(const Duration(milliseconds: 900));
    List<Article> moreArticles = totalArticles
        .skip((currentPage - 1) * pageSize)
        .take(pageSize)
        .toList();
    _currentArticles.addAll(moreArticles);
    currentPage++;
    if (currentPage * pageSize >= totalArticles.length) {
      emit(
        ArticleLoadedState(
          articles: _currentArticles,
          isLoadMore: false,
          hasReachedMax: true,
        ),
      );
    } else {
      emit(
        ArticleLoadedState(
          articles: _currentArticles,
          isLoadMore: true,
          hasReachedMax: false,
        ),
      );
    }
  }
  // Future<void> onLoadMore() async {
  //   await Future.delayed(const Duration(milliseconds: 500));
  //   if (totalArticles.isNotEmpty &&
  //       totalArticles.length > _currentArticles.length) {
  //     _currentArticles = totalArticles
  //         .skip((currentPage - 1) * pageSize)
  //         .take(pageSize)
  //         .toList();
  //     currentPage++;
  //     emit(
  //       ArticleLoadedState(
  //         articles: _currentArticles,
  //         isLoadMore: totalArticles.length > _currentArticles.length,
  //         hasReachedMax: totalArticles.length = _currentArticles.length,
  //       ),
  //     );
  //   } else {
  //     emit(FullLoadingState());
  //   }
  // }

  // Future<void> onLoadMore() async {
  //   if (state is ArticleLoadedState) {
  //     final currentState = state as ArticleLoadedState;
  //     if (currentState.hasReachedMax || currentState.isLoadingMore) return;

  //     emit(currentState.copyWith(isLoadingMore: true));

  //     try {
  //       _currentPage++;
  //       final articles = await repository.fetchNews(page: _currentPage);

  //       final allArticles = List<Article>.from(_currentArticles)
  //         ..addAll(articles);

  //       emit(
  //         ArticleLoadedState(
  //           articles: allArticles,
  //           hasReachedMax: articles.length < 100,
  //         ),
  //       );
  //       _currentArticles = allArticles;
  //     } catch (error) {
  //       emit(ErrorHomeState(error.toString()));
  //     }
  //   }
  // }
}
