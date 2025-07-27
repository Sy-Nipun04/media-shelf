import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/books_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BookService {
  static final apiKey = dotenv.env['BOOKS_API_KEY'] ?? '';

  static Future<List<Book>> searchBooks(String query) async {
    final url =
        'https://www.googleapis.com/books/v1/volumes?q=$query&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List items = data['items'] ?? [];

      return items.map((item) => Book.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }
}
