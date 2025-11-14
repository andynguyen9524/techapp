import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:techapp/News/article_model.dart';

class NewsRepository {
  // === CẬP NHẬT QUAN TRỌNG ===

  // 1. Cập nhật Base URL
  final String _baseUrl = 'https://real-time-news-data.p.rapidapi.com/search';

  // 2. Thêm các Headers bắt buộc của RapidAPI
  final Map<String, String> _headers = {
    // THAY THẾ KEY CỦA BẠN VÀO ĐÂY
    'X-RapidAPI-Key': '92c708b985mshf441688a08bbcc3p143eb1jsn420f130265f2',
    'X-RapidAPI-Host': 'real-time-news-data.p.rapidapi.com',
  };

  Future<List<Article>> fetchNews() async {
    // 3. Tạo URL với tham số truy vấn (query)
    // Ví dụ: tìm tin tức về "Flutter"
    final url = Uri.parse('$_baseUrl?query=ducati&country=US&lang=en');

    try {
      // 4. Thêm 'headers' vào lời gọi API
      final response = await http.get(url, headers: _headers);

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        // 5. Cập nhật cách đọc JSON
        // API này trả về danh sách trong key 'data' (thay vì 'articles')
        final List articlesJson = body['data'];

        final List<Article> articles = articlesJson
            .map((json) => Article.fromJson(json))
            .toList();
        return articles;
      } else {
        // In ra lỗi từ API để dễ gỡ lỗi
        print('API Error Body: ${response.body}');
        throw Exception(
          'Failed to load news (Status code: ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }
}
