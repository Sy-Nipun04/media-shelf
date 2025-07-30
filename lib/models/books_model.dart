import 'dart:convert';

class Book {
  final String id;
  final String title;
  final List<String> authors;
  final String description;
  final String thumbnail;
  final DateTime addedAt;
  final String? publishedDate;
  final String? publisher;
  final int? pageCount;
  final String? mainCategory;
  final List<String> category;
  final String language;
  final List<String> isbn;
  int? rating;
  String? note;
  bool favourite;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.description,
    required this.thumbnail,
    required this.addedAt,
    this.publishedDate,
    this.publisher,
    this.pageCount,
    this.mainCategory,
    this.category = const [],
    this.language = '',
    this.isbn = const [],
    this.rating,
    this.note,
    this.favourite = false,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] ?? {};
    return Book(
      id: json['id'] ?? '',
      title: volumeInfo['title'] ?? '',
      authors:
          (volumeInfo['authors'] as List<dynamic>?)
              ?.map((a) => a as String)
              .toList() ??
          [],
      description: volumeInfo['description'] ?? '',
      thumbnail:
          (volumeInfo['imageLinks'] != null)
              ? volumeInfo['imageLinks']['thumbnail'] ?? ''
              : '',
      addedAt: DateTime.now(),
      publishedDate: volumeInfo['publishedDate'] ?? '',
      publisher: volumeInfo['publisher'] ?? '',
      pageCount: volumeInfo['pageCount'] ?? 0,
      mainCategory: volumeInfo['mainCategory'] ?? '',
      category:
          volumeInfo['categories'] != null
              ? (volumeInfo['categories'] as List<dynamic>)
                  .map((c) => c as String)
                  .toList()
              : [],
      language: volumeInfo['language'] ?? '',
      isbn:
          volumeInfo['industryIdentifiers'] != null
              ? (volumeInfo['industryIdentifiers'] as List<dynamic>)
                  .map((id) => id['identifier'] as String)
                  .toList()
              : [],
    );
  }

  static List<Book> listFromJson(String jsonStr) {
    final data = jsonDecode(jsonStr);
    final items = data['items'] as List<dynamic>? ?? [];
    return items.map((item) => Book.fromJson(item)).toList();
  }
}
