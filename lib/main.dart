import 'package:flutter/material.dart';
import 'package:project_1/providers/books_provider.dart';
import 'package:provider/provider.dart';
import 'pages/home.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'hive_models/books_hive_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Hive.initFlutter();
  Hive.registerAdapter(BooksHiveModelAdapter());
  await Hive.openBox<BooksHiveModel>('booksBox');
  runApp(
    ChangeNotifierProvider(
      create: (context) => BooksProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: HomePage(),
    );
  }
}

//Next steps:
// 1. Create UI for the home page
// 2. Implement a detailed view for each book with more information with notes and ratings
// 3. Features to add ratings.
// 4. Add filters for books in Library(favourites, read, to read)
// 4. (Done) Fix notes change not updating in the popup without refreshing.
// 7. (Done) Pop Up info for search results
// 3. (Done) Feature to add notes and favourites.

//Ideas for the app:
// 1. (Done)use apis from rawg, tmdb, google books to fetch data
// 2. (Done using Hive, SP)use firebase to store data or store locally using hive and shared preferences
// 3. add currently, playing movies, games, books
// 4. add previously played movies, games, books
// 5. (Done)add movies, games, books to your watch/play/read list
// 6. (Done)add movie, game, book details page
// 8. (Done)add movie, game, book search functionality
// 10. add notes, reviews, ratings for movies, games, books
// 11. add filters for favorites, movies, games, books, etc
// 12. (For future)add a profile page
// 13. (for future)authentication with firebase
// 14. separate pages for books, games, movies
// 15. (Advanced) add a recommendation system based on user preferences
