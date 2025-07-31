import 'package:flutter/material.dart';
import '../models/books_model.dart';
import '../services/books_service.dart';
import 'package:project_1/hive_models/books_hive_model.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BooksProvider extends ChangeNotifier {
  final Map<String, List<Book>> cache = {};
  String lastQuery = '';
  String currentSortOption = 'Recently Added';
  String get sortOption => currentSortOption;
  String currentFilter = 'None';
  bool isLoading = false;

  List<Book> searchResults = [];
  List<Book> userLibrary = [];
  List<Book> searchLibraryResults = [];

  void setFilter(String filter) {
    currentFilter = filter;
    notifyListeners();
  }

  List<Book> get filteredLibrary {
    switch (currentFilter) {
      case 'None':
        return userLibrary;
      case 'Favourites':
        return userLibrary.where((b) => b.favourite).toList();
      case 'Reading':
        return userLibrary.where((b) => b.readingStatus == 'Reading').toList();
      case 'To Read':
        return userLibrary.where((b) => b.readingStatus == 'To Read').toList();
      case 'Read':
        return userLibrary.where((b) => b.readingStatus == 'Read').toList();
      case 'Unread':
        return userLibrary.where((b) => b.readingStatus == 'Unread').toList();
      default:
        return userLibrary;
    }
  }

  final Box<BooksHiveModel> booksBox = Hive.box<BooksHiveModel>('booksBox');

  BooksProvider() {
    _initProvider();
  }

  Future<void> _initProvider() async {
    await loadSortPreference();
    await loadLibrary();
  }

  Future<void> loadLibrary() async {
    userLibrary =
        booksBox.values
            .map(
              (hiveModel) => Book(
                id: hiveModel.id,
                title: hiveModel.title,
                authors: hiveModel.authors,
                description: hiveModel.description,
                thumbnail: hiveModel.thumbnail,
                addedAt: hiveModel.addedAt,
                publishedDate: hiveModel.publishedDate,
                publisher: hiveModel.publisher,
                pageCount: hiveModel.pageCount,
                mainCategory: hiveModel.mainCategory,
                category: hiveModel.category,
                language: hiveModel.language,
                isbn: hiveModel.isbn,
                rating: hiveModel.rating,
                note: hiveModel.note,
                favourite: hiveModel.favourite,
                readingStatus: hiveModel.readingStatus,
              ),
            )
            .toList();

    await sortLibrary(currentSortOption, notify: false);
    notifyListeners();
  }

  Future<void> search(String query) async {
    if (isLoading) return;

    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty || trimmedQuery == lastQuery) return;

    isLoading = true;
    notifyListeners();

    lastQuery = trimmedQuery;

    if (cache.containsKey(trimmedQuery)) {
      searchResults = cache[trimmedQuery]!;
    } else {
      searchResults = await BookService.searchBooks(trimmedQuery);
      if (cache.length >= 50) cache.remove(cache.keys.first);
      cache[trimmedQuery] = searchResults;
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> addToLibrary(BooksHiveModel book) async {
    if (!booksBox.containsKey(book.id)) {
      await booksBox.put(book.id, book);
      await loadLibrary();
      searchLibraryResults = [];
      notifyListeners();
    }
  }

  Future<void> removeFromLibrary(String bookId) async {
    await booksBox.delete(bookId);
    await loadLibrary();
    searchLibraryResults = [];
    notifyListeners();
  }

  Future<void> searchLibrary(String query) async {
    if (query.isEmpty) {
      searchLibraryResults = userLibrary;
    } else {
      searchLibraryResults =
          userLibrary
              .where(
                (book) =>
                    book.title.toLowerCase().contains(query.toLowerCase()) ||
                    book.authors.any(
                      (author) =>
                          author.toLowerCase().contains(query.toLowerCase()),
                    ),
              )
              .toList();
    }
    notifyListeners();
  }

  Future<void> loadSortPreference() async {
    final prefs = await SharedPreferences.getInstance();
    currentSortOption = prefs.getString('sortBy') ?? 'Recently Added';
  }

  Future<void> setSortOption(String option) async {
    currentSortOption = option;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sortBy', option);
    await sortLibrary(option);
  }

  Future<void> sortLibrary(String criteria, {bool notify = true}) async {
    if (criteria == 'Title') {
      userLibrary.sort((a, b) => a.title.compareTo(b.title));
    } else if (criteria == 'Author') {
      userLibrary.sort(
        (a, b) => a.authors.join(', ').compareTo(b.authors.join(', ')),
      );
    } else if (criteria == 'Rating') {
      userLibrary.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
    } else {
      // Recently Added
      userLibrary.sort((a, b) => b.addedAt.compareTo(a.addedAt));
    }

    if (notify) notifyListeners();
  }

  bool isBookInFavorites(Book book) {
    return userLibrary.any((b) => b.id == book.id && b.favourite);
  }

  bool toggleFavorite(Book book) {
    final index = userLibrary.indexWhere((b) => b.id == book.id);
    if (index != -1) {
      final updatedFavorite = !userLibrary[index].favourite;
      final hiveBook = booksBox.get(book.id);
      if (hiveBook != null) {
        hiveBook.favourite = updatedFavorite;
        hiveBook.save();
      }
      userLibrary[index].favourite = updatedFavorite;
      notifyListeners();
      return updatedFavorite;
    }
    return false;
  }

  Future<void> updateBookNote(String bookId, String note) async {
    final book = booksBox.get(bookId);
    if (book != null) {
      book.note = note;
      await book.save();

      final index = userLibrary.indexWhere((b) => b.id == bookId);
      if (index != -1) {
        userLibrary[index].note = note;
        notifyListeners();
      }
    }
  }

  Future<void> updateBookRating(String bookId, int? rating) async {
    final book = booksBox.get(bookId);
    if (book != null) {
      book.rating = rating;
      await book.save();

      final index = userLibrary.indexWhere((b) => b.id == bookId);
      if (index != -1) {
        userLibrary[index].rating = rating;
        notifyListeners();
      }
    }
  }

  Future<void> updateBookReadingStatus(String bookId, String status) async {
    final book = booksBox.get(bookId);
    if (book != null) {
      book.readingStatus = status;
      await book.save();

      final index = userLibrary.indexWhere((b) => b.id == bookId);
      if (index != -1) {
        userLibrary[index].readingStatus = status;
        notifyListeners();
      }
    }
  }
}
