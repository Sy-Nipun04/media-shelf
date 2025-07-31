import 'package:flutter/material.dart';
import 'package:project_1/models/books_model.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../providers/books_provider.dart';
import '../books_library.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../hive_models/books_hive_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../Widgets/star_rating.dart';

Future<dynamic> bookPopUpInfo(
  BuildContext context,
  Book book,
  List<Book> userLibrary,
  BooksProvider provider,
) async {
  return showDialog<dynamic>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: book.thumbnail,
                        width: 80,
                        height: 120,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                        errorWidget:
                            (context, url, error) => Container(
                              height: 120,
                              width: 80,
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.title,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            book.authors.join(', '),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Consumer<BooksProvider>(
                      builder: (context, provider, child) {
                        final isInLibrary = provider.userLibrary.any(
                          (b) => b.id == book.id,
                        );
                        if (!isInLibrary) return const SizedBox.shrink();
                        return Consumer<BooksProvider>(
                          builder: (context, provider, child) {
                            final updatedBook = provider.userLibrary.firstWhere(
                              (b) => b.id == book.id,
                              orElse: () => book,
                            );

                            return StarRating(
                              rating:
                                  updatedBook
                                      .rating, // int? variable (null means no rating)
                              onRatingChanged: (newRating) {
                                provider.updateBookRating(book.id, newRating);
                              },
                            );
                          },
                        );
                      },
                    ),
                    Consumer<BooksProvider>(
                      builder: (context, provider, child) {
                        final isInLibrary = provider.userLibrary.any(
                          (b) => b.id == book.id,
                        );

                        if (!isInLibrary) return const SizedBox.shrink();

                        final isFavourite = provider.userLibrary.any(
                          (b) => b.id == book.id && b.favourite,
                        );

                        return Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color:
                                isFavourite
                                    ? const Color.fromARGB(255, 255, 183, 0)
                                    : Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.star,
                              color: isFavourite ? Colors.white : Colors.grey,
                              size: 20,
                            ),
                            onPressed: () {
                              provider.toggleFavorite(book);
                            },
                          ),
                        );
                      },
                    ),

                    Consumer<BooksProvider>(
                      builder: (context, provider, child) {
                        final isInLibrary = provider.userLibrary.any(
                          (b) => b.id == book.id,
                        );
                        return Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color:
                                isInLibrary
                                    ? Colors.green[200]
                                    : Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              isInLibrary ? Icons.check : Icons.add,
                              size: 20,
                            ),
                            onPressed: () async {
                              if (isInLibrary) {
                                final confirm = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Remove Book?'),
                                      content: Text(
                                        'Do you want to remove ${book.title} from your library?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.of(
                                                context,
                                              ).pop(false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed:
                                              () => Navigator.of(
                                                context,
                                              ).pop(true),
                                          child: const Text('Remove'),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                if (confirm == true) {
                                  provider.removeFromLibrary(book.id);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: Duration(milliseconds: 500),
                                        content: Text(
                                          '${book.title} removed from library',
                                        ),
                                      ),
                                    );
                                  } else {
                                    return;
                                  }
                                } else {
                                  return;
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: const Duration(milliseconds: 700),
                                    content: Text(
                                      '${book.title} added to your library',
                                    ),
                                  ),
                                );
                                provider.addToLibrary(
                                  BooksHiveModel(
                                    id: book.id,
                                    title: book.title,
                                    authors: book.authors,
                                    description: book.description,
                                    thumbnail: book.thumbnail,
                                    addedAt: book.addedAt,
                                    publishedDate: book.publishedDate,
                                    publisher: book.publisher,
                                    pageCount: book.pageCount,
                                    mainCategory: book.mainCategory,
                                    category: book.category,
                                    language: book.language,
                                    isbn: book.isbn,
                                    rating: null,
                                    note: null,
                                    favourite: false,
                                    readingStatus: 'Unread',
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Consumer<BooksProvider>(
                  builder: (context, provider, child) {
                    final isInLibrary = provider.userLibrary.any(
                      (b) => b.id == book.id,
                    );
                    if (!isInLibrary) return const SizedBox.shrink();
                    return const SizedBox(height: 10);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Consumer<BooksProvider>(
                      builder: (context, provider, child) {
                        final isInLibrary = provider.userLibrary.any(
                          (b) => b.id == book.id,
                        );
                        if (!isInLibrary) return const SizedBox.shrink();

                        final updatedBook = provider.userLibrary.firstWhere(
                          (b) => b.id == book.id,
                          orElse: () => book,
                        );

                        String selectedOption =
                            updatedBook.readingStatus ?? 'Unread';

                        return StatefulBuilder(
                          builder: (context, setState) {
                            return Container(
                              height: 30,
                              width: 120,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color:
                                      selectedOption == 'Reading'
                                          ? Colors.blue
                                          : (selectedOption == 'To Read'
                                              ? Colors.orange
                                              : (selectedOption == 'Read'
                                                  ? Colors.green
                                                  : Colors.grey)),
                                ),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: DropdownButton<String>(
                                value: selectedOption,
                                isExpanded: true,
                                underline: const SizedBox(),
                                icon: const SizedBox.shrink(),
                                items:
                                    [
                                      'Reading',
                                      'To Read',
                                      'Read',
                                      'Unread',
                                    ].map((String option) {
                                      return DropdownMenuItem<String>(
                                        value: option,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.circle,
                                              size: 15,
                                              color:
                                                  option == 'Reading'
                                                      ? Colors.blue
                                                      : (option == 'To Read'
                                                          ? Colors.orange
                                                          : (option == 'Read'
                                                              ? Colors.green
                                                              : Colors.grey)),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              option,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color:
                                                    option == 'Reading'
                                                        ? Colors.blue[600]
                                                        : (option == 'To Read'
                                                            ? Colors.orange[600]
                                                            : (option == 'Read'
                                                                ? Colors
                                                                    .green[600]
                                                                : Colors
                                                                    .grey[600])),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedOption = newValue!;
                                  });
                                  provider.updateBookReadingStatus(
                                    book.id,
                                    selectedOption,
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  constraints: BoxConstraints(
                    maxHeight: 135,
                    maxWidth: double.infinity,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Flexible(
                        child: SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: Text(
                            (book.description.isEmpty)
                                ? 'No description'
                                : book.description,
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  (book.description.isEmpty)
                                      ? Colors.grey
                                      : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Consumer<BooksProvider>(
                  builder: (context, provider, child) {
                    final isInLibrary = provider.userLibrary.any(
                      (b) => b.id == book.id,
                    );
                    if (!isInLibrary) return const SizedBox.shrink();
                    return const SizedBox(height: 12);
                  },
                ),
                //  Notes
                Consumer<BooksProvider>(
                  builder: (context, provider, child) {
                    final isInLibrary = provider.userLibrary.any(
                      (b) => b.id == book.id,
                    );

                    if (!isInLibrary) return const SizedBox.shrink();

                    final updatedBook = provider.userLibrary.firstWhere(
                      (b) => b.id == book.id,
                      orElse: () => book,
                    );

                    return Container(
                      constraints: const BoxConstraints(
                        maxHeight: 120,
                        maxWidth: double.infinity,
                      ),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                "Your Sticky Note",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  addNoteDialog(context, updatedBook, provider);
                                },
                                child: const Icon(
                                  Icons.edit,
                                  size: 15,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Flexible(
                            child: SingleChildScrollView(
                              physics: const ClampingScrollPhysics(),
                              child: Text(
                                updatedBook.note?.isNotEmpty == true
                                    ? updatedBook.note!
                                    : 'Add a note here...',
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      updatedBook.note?.isNotEmpty == true
                                          ? Colors.black
                                          : Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(elevation: 0),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => BookInfoPage(selectedBook: book),
                          ),
                        );
                      },
                      icon: const Icon(Icons.info, color: Colors.blue),
                      label: const Text(
                        "More Info",
                        style: TextStyle(fontSize: 11, color: Colors.blue),
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(elevation: 0),
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.blue),
                      label: const Text(
                        "Close",
                        style: TextStyle(fontSize: 11, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Future<void> addNoteDialog(
  BuildContext context,
  Book book,
  BooksProvider provider,
) async {
  final TextEditingController controller = TextEditingController(
    text: book.note ?? '',
  );

  return showDialog<void>(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.5,
            maxWidth: MediaQuery.of(context).size.width * 0.95,
          ),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add or Edit Note",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: controller,
                  maxLines: 7,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Write your note here...',
                    hintStyle: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        //backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        provider.updateBookNote(book.id, controller.text);
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Save Note",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        //backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class BookInfoPage extends StatefulWidget {
  const BookInfoPage({super.key, required this.selectedBook});
  final Book selectedBook;

  @override
  State<BookInfoPage> createState() => _BookInfoPageState();
}

class _BookInfoPageState extends State<BookInfoPage> {
  @override
  Widget build(BuildContext context) {
    final Book selectedBook = widget.selectedBook;
    return Scaffold(
      appBar: appBar(selectedBook),
      body: Center(child: Text('Book Info Page')),
    );
  }

  AppBar appBar(Book? selectedBook) {
    return AppBar(
      title: Text(
        selectedBook?.title ?? 'Book Info',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      elevation: 0.0,
      backgroundColor: Colors.white,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          margin: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xffF7F8F8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Color.fromARGB(255, 153, 153, 153),
            size: 15,
          ),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xffF7F8F8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.more_horiz,
              color: Color.fromARGB(255, 153, 153, 153),
              size: 15,
            ),
          ),
        ),
      ],
    );
  }
}
