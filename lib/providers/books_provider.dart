import 'package:flutter/material.dart';
import '../models/books_model.dart';
import '../services/books_service.dart';
import 'package:project_1/hive_models/books_hive_model.dart';
import 'package:hive/hive.dart';

class BooksProvider extends ChangeNotifier {
  final Map<String, List<Book>> cache = {};
  String lastQuery = '';
  bool isLoading = false;

  List<Book> searchResults = [];
  List<Book> userLibrary = [];
  List<Book> searchLibraryResults = [];

  final Box<BooksHiveModel> booksBox = Hive.box<BooksHiveModel>('booksBox');

  BooksProvider() {
    loadLibrary();
  }

  void loadLibrary() async {
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
              ),
            )
            .toList();
    notifyListeners();
  }

  Future<void> search(String query) async {
    if (isLoading) return;

    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty || trimmedQuery == lastQuery) return;

    isLoading = true;
    notifyListeners();

    lastQuery = trimmedQuery;

    // Check if result is already cached
    if (cache.containsKey(trimmedQuery)) {
      searchResults = cache[trimmedQuery]!;
      isLoading = false;
      notifyListeners();
      return;
    }

    searchResults = await BookService.searchBooks(trimmedQuery);
    if (cache.length >= 50) {
      cache.remove(cache.keys.first);
    }
    cache[trimmedQuery] = searchResults;
    isLoading = false;
    notifyListeners();
  }

  Future<void> addToLibrary(BooksHiveModel book) async {
    if (!booksBox.containsKey(book.id)) {
      await booksBox.put(book.id, book);
      userLibrary.add(
        Book(
          id: book.id,
          title: book.title,
          authors: book.authors,
          description: book.description,
          thumbnail: book.thumbnail,
          rating: book.rating,
          note: book.note,
          addedAt: DateTime.now(),
        ),
      );
      notifyListeners();
    }
  }

  Future<void> removeFromLibrary(String bookId) async {
    await booksBox.delete(bookId);
    userLibrary.removeWhere((b) => b.id == bookId);
    notifyListeners();
  }

  Future<void> updateBook(String bookId, {int? rating, String? notes}) async {
    final book = booksBox.get(bookId);
    if (book != null) {
      if (rating != null) book.rating = rating;
      if (notes != null) book.note = notes;
      await book.save();
      loadLibrary();
    }
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

  Future<void> sortLibrary(String criteria) async {
    if (criteria == 'Title') {
      userLibrary.sort((a, b) => a.title.compareTo(b.title));
    } else if (criteria == 'Author') {
      userLibrary.sort(
        (a, b) => a.authors.join(', ').compareTo(b.authors.join(', ')),
      );
    } else if (criteria == 'Rating') {
      userLibrary.sort((a, b) {
        final aRating = a.rating ?? 0;
        final bRating = b.rating ?? 0;
        return bRating.compareTo(aRating);
      });
    } else if (criteria == 'Recently Added') {
      userLibrary.sort((a, b) => b.addedAt.compareTo(a.addedAt));
    } else {
      userLibrary.sort((a, b) => a.title.compareTo(b.title));
    }
    notifyListeners();
  }

  bool isBookInFavorites(Book book) {
    return userLibrary.any((b) => b.id == book.id && b.favourite);
  }

  bool toggleFavorite(Book book) {
    final index = userLibrary.indexWhere((b) => b.id == book.id);
    bool isFavourite = false;
    if (index != -1) {
      userLibrary[index].favourite = !userLibrary[index].favourite;
      isFavourite = userLibrary[index].favourite;
      booksBox.put(
        book.id,
        BooksHiveModel(
          id: book.id,
          title: book.title,
          authors: book.authors,
          description: book.description,
          thumbnail: book.thumbnail,
          addedAt: book.addedAt,
          rating: book.rating,
          note: book.note,
          favourite: userLibrary[index].favourite,
        ),
      );
      notifyListeners();
    }
    return isFavourite;
  }

  void updateBookNote(String bookId, String note) {
    final book = booksBox.get(bookId);
    if (book != null) {
      book.note = note;
      book.save();
      loadLibrary();
    }
  }
}
