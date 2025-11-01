import 'package:flutter/material.dart';
import 'package:project_1/models/books_model.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../providers/books_provider.dart';
import '../../hive_models/books_hive_model.dart';
import '../../Widgets/star_rating.dart';
import 'book_details.dart';
import 'add_note_dialog.dart';

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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        elevation: 10,
        insetPadding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 24,
              right: 24,
              top: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: book.thumbnail.replaceAll(
                            'http:',
                            'https:',
                          ),
                          width: 90,
                          height: 135,
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) => Container(
                                width: 90,
                                height: 135,
                                color: Colors.grey[200],
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                          errorWidget:
                              (context, url, error) => Container(
                                height: 135,
                                width: 90,
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(
                                    Icons.book_outlined,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                              height: 1.3,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  book.authors.join(', '),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
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
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color:
                                isFavourite
                                    ? const Color.fromARGB(255, 255, 183, 0)
                                    : Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color:
                                  isFavourite
                                      ? const Color.fromARGB(255, 255, 183, 0)
                                      : Colors.grey[300]!,
                              width: 1.5,
                            ),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.star,
                              color:
                                  isFavourite ? Colors.white : Colors.grey[400],
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
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color:
                                isInLibrary
                                    ? Colors.green[50]
                                    : Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color:
                                  isInLibrary
                                      ? Colors.green[400]!
                                      : Colors.grey[300]!,
                              width: 1.5,
                            ),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              isInLibrary ? Icons.check : Icons.add,
                              color:
                                  isInLibrary
                                      ? Colors.green[700]
                                      : Colors.grey[600],
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
                    return const SizedBox(height: 14);
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

                        String selectedOption = updatedBook.readingStatus;

                        return StatefulBuilder(
                          builder: (context, setState) {
                            return Container(
                              height: 36,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color:
                                      selectedOption == 'Reading'
                                          ? Colors.blue[300]!
                                          : (selectedOption == 'To Read'
                                              ? Colors.orange[300]!
                                              : (selectedOption == 'Read'
                                                  ? Colors.green[300]!
                                                  : Colors.grey[300]!)),
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: (selectedOption == 'Reading'
                                            ? Colors.blue
                                            : (selectedOption == 'To Read'
                                                ? Colors.orange
                                                : (selectedOption == 'Read'
                                                    ? Colors.green
                                                    : Colors.grey)))
                                        .withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: DropdownButton<String>(
                                value: selectedOption,
                                underline: const SizedBox(),
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color:
                                      selectedOption == 'Reading'
                                          ? Colors.blue[600]
                                          : (selectedOption == 'To Read'
                                              ? Colors.orange[600]
                                              : (selectedOption == 'Read'
                                                  ? Colors.green[600]
                                                  : Colors.grey[600])),
                                ),
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
                const SizedBox(height: 16),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  constraints: const BoxConstraints(
                    maxHeight: 150,
                    maxWidth: double.infinity,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border.all(color: Colors.grey.shade200, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.description_outlined,
                            size: 16,
                            color: Colors.grey[700],
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Flexible(
                        child: SingleChildScrollView(
                          physics: const ClampingScrollPhysics(),
                          child: Text(
                            (book.description.isEmpty)
                                ? 'No description available'
                                : book.description,
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  (book.description.isEmpty)
                                      ? Colors.grey[500]
                                      : Colors.black87,
                              height: 1.5,
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
                    return const SizedBox(height: 14);
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
                        maxHeight: 130,
                        maxWidth: double.infinity,
                      ),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF9E6),
                        border: Border.all(
                          color: Colors.amber[200]!,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.sticky_note_2_outlined,
                                size: 16,
                                color: Colors.amber[800],
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                "Your Sticky Note",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  addNoteDialog(context, updatedBook, provider);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Icon(
                                    Icons.edit,
                                    size: 16,
                                    color: Colors.amber[800],
                                  ),
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
                                    : 'Tap the edit icon to add your personal notes...',
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      updatedBook.note?.isNotEmpty == true
                                          ? Colors.black87
                                          : Colors.grey[600],
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.blue[50],
                          foregroundColor: Colors.blue[700],
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => BookInfoPage(selectedBook: book),
                            ),
                          );
                        },
                        icon: const Icon(Icons.info_outline, size: 20),
                        label: const Text(
                          "More Info",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.grey[100],
                          foregroundColor: Colors.grey[700],
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, size: 20),
                        label: const Text(
                          "Close",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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
