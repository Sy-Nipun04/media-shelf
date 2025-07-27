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
  int? rating;

  @HiveField(7)
  String? note;

  @HiveField(8)
  bool favourite = false;

  BooksHiveModel({
    required this.id,
    required this.title,
    required this.authors,
    required this.description,
    required this.thumbnail,
    required this.addedAt,
    this.rating,
    this.note,
    this.favourite = false,
  });
}
