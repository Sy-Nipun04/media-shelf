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
      rating: fields[6] as int?,
      note: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BooksHiveModel obj) {
    writer
      ..writeByte(7)
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
      ..write(obj.rating)
      ..writeByte(6)
      ..write(obj.note);
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
