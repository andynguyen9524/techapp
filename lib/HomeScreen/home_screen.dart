import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techapp/HomeScreen/home_controller.dart';
import 'package:techapp/HomeScreen/home_state.dart';
import 'package:techapp/Detail/article_detail_screen.dart';
import 'package:techapp/News/article_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    // need Flag form Bloc !!!
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      context.read<HomeController>().needLoadHomeMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<HomeController, HomeState>(
        builder: (context, state) {
          if (state is LoadingHomeState) {
            return Center(
              child: CircularProgressIndicator(color: Colors.blueGrey),
            );
          } else if (state is ArticleLoadedState) {
            return NewList(
              articles: state.articles,
              isLoadingMore: true,
              hasReachedMax: false,
              scrollController: _scrollController,
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}

class NewList extends StatelessWidget {
  const NewList({
    super.key,
    required this.articles,
    required this.isLoadingMore,
    required this.hasReachedMax,
    required this.scrollController,
  });
  final List<Article> articles;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    if (articles.isEmpty) {
      return const Center(child: Text('Không tìm thấy bài viết nào.'));
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: articles.length,
      itemBuilder: (context, index) {
        if (index >= articles.length) {
          if (isLoadingMore) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (hasReachedMax) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: Text('Đã tải hết bài viết.')),
            );
          } else {
            return SizedBox.shrink();
          }
        }

        final article = articles[index];

        // 2. Sử dụng Card để có hiệu ứng nổi và lề
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArticleDetailScreen(article: article),
              ),
            );
          },
          child: Card(
            elevation: 3, // Thêm bóng đổ
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ), // Lề xung quanh
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 3. Hiển thị ảnh (rất quan trọng)
                if (article.urlToImage.isNotEmpty)
                  Image.network(
                    article.urlToImage,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    // Hiển thị vòng xoay trong khi tải ảnh
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    // Hiển thị icon lỗi nếu không tải được ảnh
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[400],
                          size: 50,
                        ),
                      );
                    },
                  ),

                // 4. Căn chỉnh và tạo kiểu cho Tiêu đề
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold, // Làm đậm tiêu đề
                    ),
                  ),
                ),

                // 5. Căn chỉnh và tạo kiểu cho Mô tả
                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 12.0),
                  child: Text(
                    article.description,
                    style: TextStyle(
                      color: Colors.grey[700],
                    ), // Màu chữ nhạt hơn
                    maxLines: 3, // Giới hạn 3 dòng
                    overflow: TextOverflow.ellipsis, // Thêm dấu ... nếu quá dài
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
