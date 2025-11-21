import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techapp/HomeScreen/home_state.dart';
import 'package:techapp/Model/article_model.dart';
import 'package:techapp/Model/news_repository.dart';

class HomeController extends Cubit<HomeState> {
  HomeController() : super(LoadingHomeState());
  final repository = NewsRepository();

  final _pageSize = 3;
  bool _isLoadingMore = false;
  final List<Article> articles = [];
  List<Article> _allArticles = [];

  Future initArticles() async {
    emit(LoadingHomeState());
    _allArticles = await repository.fetchNews();
    final newArticles = _allArticles
        .skip(articles.length)
        .take(_pageSize)
        .toList();
    articles.addAll(newArticles);
    emit(
      ArticleLoadedState(
        articles: articles,
        length: articles.length,
        hasReachedMax: newArticles.length < _pageSize,
      ),
    );
  }

  Future loadArticles() async {
    if (_isLoadingMore) return;
    _isLoadingMore = true;
    await Future.delayed(const Duration(milliseconds: 800));
    if (state is! ArticleLoadedState) return;
    final newArticles = _allArticles
        .skip(articles.length)
        .take(_pageSize)
        .toList();
    articles.addAll(newArticles);

    emit(
      ArticleLoadedState(
        articles: articles,
        length: articles.length,
        hasReachedMax: newArticles.length < _pageSize,
      ),
    );
    _isLoadingMore = false;
  }
}
