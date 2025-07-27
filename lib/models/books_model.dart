import 'dart:convert';

class Book {
  final String id;
  final String title;
  final List<String> authors;
  final String description;
  final String thumbnail;
  final DateTime addedAt;
  final int? rating;
  final String? note;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.description,
    required this.thumbnail,
    required this.addedAt,
    this.rating,
    this.note,
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
    );
  }

  static List<Book> listFromJson(String jsonStr) {
    final data = jsonDecode(jsonStr);
    final items = data['items'] as List<dynamic>? ?? [];
    return items.map((item) => Book.fromJson(item)).toList();
  }
}
