import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techapp/HomeScreen/home_state.dart';
import 'package:techapp/News/article_model.dart';
import 'package:techapp/News/news_repository.dart';

class HomeController extends Cubit<HomeState> {
  HomeController() : super(LoadingHomeState());
  final repository = NewsRepository();

  Future<void> onfetchHome() async {
    emit(LoadingHomeState());
    repository
        .fetchNews()
        .then((articles) {
          // You can pass articles to InfoHomeState if needed
          emit(ArticleLoadedState(articles as Article));
        })
        .catchError((error) {
          // Handle error state if necessary
          emit(ErrorHomeState(error)); // Placeholder for error state
        });
  }
}
