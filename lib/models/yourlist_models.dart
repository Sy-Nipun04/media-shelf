import 'package:flutter/material.dart';

class YourListModels {
  String title;
  String iconPath;
  String author;
  Color boxColor;

  YourListModels({
    required this.title,
    required this.iconPath,
    required this.author,
    required this.boxColor,
  });

  static List<YourListModels> getYourList() {
    List<YourListModels> yourlist = [];
    yourlist.add(
      YourListModels(
        title: "Counter-Strike",
        iconPath: "assets/icons/counter-strike.svg",
        author: "Valve",
        boxColor: const Color.fromARGB(255, 182, 241, 212),
      ),
    );

    yourlist.add(
      YourListModels(
        title: "Lord of the Rings",
        iconPath: "assets/icons/lotr.svg",
        author: "J.R.R. Tolkien",
        boxColor: const Color.fromARGB(255, 177, 206, 255),
      ),
    );

    yourlist.add(
      YourListModels(
        title: "The Witcher",
        iconPath: "assets/icons/witcher.svg",
        author: "Andrzej Sapkowski",
        boxColor: const Color.fromARGB(255, 177, 206, 255),
      ),
    );

    yourlist.add(
      YourListModels(
        title: "Breaking Bad",
        iconPath: "assets/icons/brba.svg",
        author: "Vince Gilligan",
        boxColor: const Color.fromARGB(255, 233, 181, 178),
      ),
    );

    yourlist.add(
      YourListModels(
        title: "Assassin's Creed",
        iconPath: "assets/icons/ac.svg",
        author: "Ubisoft",
        boxColor: const Color.fromARGB(255, 182, 241, 212),
      ),
    );

    return yourlist;
  }
}
