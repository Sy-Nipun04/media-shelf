import 'package:flutter/material.dart';

class CategoryModel {
  String name;
  Icon icon;
  Color boxColor;

  CategoryModel({
    required this.name,
    required this.icon,
    required this.boxColor,
  });

  static List<CategoryModel> getCategories() {
    List<CategoryModel> categories = [];

    categories.add(
      CategoryModel(
        name: "Books",
        icon: Icon(Icons.book),
        boxColor: const Color.fromARGB(255, 177, 206, 255),
      ),
    );

    categories.add(
      CategoryModel(
        name: "Games",
        icon: Icon(Icons.sports_esports),
        boxColor: const Color.fromARGB(255, 182, 241, 212),
      ),
    );

    categories.add(
      CategoryModel(
        name: "Movies & TV",
        icon: Icon(Icons.theaters),
        boxColor: const Color.fromARGB(255, 233, 181, 178),
      ),
    );

    categories.add(
      CategoryModel(
        name: "Songs",
        icon: Icon(Icons.music_note),
        boxColor: const Color.fromARGB(255, 255, 228, 192),
      ),
    );

    return categories;
  }
}
