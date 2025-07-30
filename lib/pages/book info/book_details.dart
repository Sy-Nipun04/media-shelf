import 'package:flutter/material.dart';
import 'package:project_1/models/books_model.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../providers/books_provider.dart';
import '../books_library.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../hive_models/books_hive_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

Future<dynamic> bookPopUpLibrary(
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
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            maxWidth: MediaQuery.of(context).size.width * 0.95,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: book.thumbnail,
                      width: 80,
                      height: 120,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) =>
                              const Center(child: CircularProgressIndicator()),
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
                  // Title and Favorite
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 10),
                        Text(
                          book.authors.join(', '),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      5,
                      (index) => const Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 20,
                      ),
                    ),
                  ),
                  Consumer<BooksProvider>(
                    builder: (context, provider, child) {
                      final isInLibrary = userLibrary.any(
                        (b) => b.id == book.id,
                      );
                      return Align(
                        alignment: Alignment.topRight,
                        child: Container(
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
                                  builder:
                                      (context) => AlertDialog(
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
                                      ),
                                );

                                if (confirm == true) {
                                  provider.removeFromLibrary(book.id);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: const Duration(
                                          milliseconds: 500,
                                        ),
                                        content: Text(
                                          '${book.title} removed from library',
                                        ),
                                      ),
                                    );
                                  }
                                }
                              } else {
                                provider.addToLibrary(
                                  BooksHiveModel(
                                    id: book.id,
                                    title: book.title,
                                    authors: book.authors,
                                    description: book.description,
                                    thumbnail: book.thumbnail,
                                    addedAt: book.addedAt,
                                  ),
                                );
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: const Duration(
                                        milliseconds: 700,
                                      ),
                                      content: Text(
                                        '${book.title} added to your library',
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Ratings
              LayoutBuilder(
                builder: (context, constraints) {
                  return ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: double.infinity,
                      minWidth: double.infinity,
                      maxHeight: 134,
                    ),

                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          //const Divider(),
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
                                      (book.note == null)
                                          ? Colors.grey
                                          : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),

              // Notes
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: double.infinity,
                  minWidth: double.infinity,
                  maxHeight: 120,
                ),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Sticky Note",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        book.note ?? 'Add a note',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              (book.note == null) ? Colors.grey : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Book selectedBook = Book(
                        id: book.id,
                        title: book.title,
                        authors: book.authors,
                        description: book.description,
                        thumbnail: book.thumbnail,
                        addedAt: book.addedAt,
                        rating: book.rating,
                        note: book.note,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  BookInfoPage(selectedBook: selectedBook),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(elevation: 0),
                    icon: const Icon(Icons.info, color: Colors.blue),
                    label: Text(
                      "More Info",
                      style: TextStyle(fontSize: 11, color: Colors.blue),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(elevation: 0),
                    icon: const Icon(Icons.close, color: Colors.blue),
                    label: Text(
                      "Close",
                      style: TextStyle(fontSize: 11, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
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
