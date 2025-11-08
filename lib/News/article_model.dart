import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final String title;
  final String description; // Sẽ lấy từ 'snippet'
  final String urlToImage; // Sẽ lấy từ 'image_url'

  const Article({
    required this.title,
    required this.description,
    required this.urlToImage,
  });

  // Factory constructor ĐÃ ĐƯỢC CẬP NHẬT
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      // Lấy 'title', nếu không có thì trả về 'No Title'
      title: json['title'] ?? 'No Title',

      // API này dùng 'snippet' cho mô tả
      description: json['snippet'] ?? 'No Description',

      // API này dùng 'image_url' cho ảnh
      urlToImage: json['image_url'] ?? '',
    );
  }

  @override
  List<Object?> get props => [title, description, urlToImage];
}
