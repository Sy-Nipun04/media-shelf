import 'package:hive/hive.dart';

part 'books_hive_model.g.dart';

@HiveType(typeId: 0)
class BooksHiveModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  List<String> authors;

  @HiveField(3)
  String description;

  @HiveField(4)
  String thumbnail;

  @HiveField(5)
  DateTime addedAt;

  @HiveField(6)
  String? publishedDate;

  @HiveField(7)
  String? publisher;

  @HiveField(8)
  int? pageCount;

  @HiveField(9)
  String? mainCategory;

  @HiveField(10)
  List<String> category;

  @HiveField(11)
  String language;

  @HiveField(12)
  List<String> isbn;

  @HiveField(12)
  int? rating;

  @HiveField(13)
  String? note;

  @HiveField(14)
  bool favourite = false;

  @HiveField(15)
  String readingStatus = 'Unread';

  BooksHiveModel({
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
    this.readingStatus = 'Unread',
  });
}
