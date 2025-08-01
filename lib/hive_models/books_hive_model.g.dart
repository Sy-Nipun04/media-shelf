// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'books_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BooksHiveModelAdapter extends TypeAdapter<BooksHiveModel> {
  @override
  final int typeId = 0;

  @override
  BooksHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BooksHiveModel(
      id: fields[0] as String,
      title: fields[1] as String,
      authors: (fields[2] as List).cast<String>(),
      description: fields[3] as String,
      thumbnail: fields[4] as String,
      addedAt:
          fields[5] != null
              ? DateTime.parse(fields[5] as String)
              : DateTime.now(),
      publishedDate: fields[6] as String?,
      publisher: fields[7] as String?,
      pageCount: fields[8] as int?,
      mainCategory: fields[9] as String?,
      category: (fields[10] != null) ? (fields[10] as List).cast<String>() : [],
      language: fields[11] as String? ?? '',
      isbn: (fields[12] as List?)?.cast<String>() ?? [],
      rating: fields[13] as int?,
      note: fields[14] as String?,
      favourite: fields[15] as bool? ?? false,
      readingStatus: fields[16] as String? ?? 'Unread',
    );
  }

  @override
  void write(BinaryWriter writer, BooksHiveModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.authors)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.thumbnail)
      ..writeByte(5)
      ..write(obj.addedAt.toIso8601String())
      ..writeByte(6)
      ..write(obj.publishedDate)
      ..writeByte(7)
      ..write(obj.publisher)
      ..writeByte(8)
      ..write(obj.pageCount)
      ..writeByte(9)
      ..write(obj.mainCategory)
      ..writeByte(10)
      ..write(obj.category)
      ..writeByte(11)
      ..write(obj.language)
      ..writeByte(12)
      ..write(obj.isbn)
      ..writeByte(13)
      ..write(obj.rating)
      ..writeByte(14)
      ..write(obj.note)
      ..writeByte(15)
      ..write(obj.favourite)
      ..writeByte(16)
      ..write(obj.readingStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BooksHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
