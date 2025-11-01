import 'package:flutter/material.dart';
import 'package:project_1/models/books_model.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../../providers/books_provider.dart';
import '../../hive_models/books_hive_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../Widgets/star_rating.dart';
import 'add_note_dialog.dart';

// Export bookPopUpInfo so it's accessible from other files
export 'book_popup_info.dart' show bookPopUpInfo;

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image Section with Blurred Background
            Stack(
              children: [
                // Blurred background image
                Container(
                  height: 380,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: selectedBook.thumbnail.replaceAll(
                      'http:',
                      'https:',
                    ),
                    fit: BoxFit.cover,
                    errorWidget:
                        (context, url, error) =>
                            Container(color: Colors.blue.shade50),
                  ),
                ),
                // Blur effect
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      height: 380,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
                // Gradient overlay for smooth transition
                Container(
                  height: 380,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.8),
                        Colors.white,
                      ],
                      stops: const [0.0, 0.7, 1.0],
                    ),
                  ),
                ),
                // Book Cover
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: selectedBook.thumbnail.replaceAll(
                                'http:',
                                'https:',
                              ),
                              height: 280,
                              width: 190,
                              fit: BoxFit.cover,
                              placeholder:
                                  (context, url) => Container(
                                    height: 280,
                                    width: 190,
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                              errorWidget:
                                  (context, url, error) => Container(
                                    height: 280,
                                    width: 190,
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.book,
                                      size: 80,
                                      color: Colors.grey,
                                    ),
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Action Buttons
                        Consumer<BooksProvider>(
                          builder: (context, provider, child) {
                            final isInLibrary = provider.userLibrary.any(
                              (b) => b.id == selectedBook.id,
                            );
                            final isFavourite =
                                isInLibrary &&
                                provider.userLibrary.any(
                                  (b) => b.id == selectedBook.id && b.favourite,
                                );

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Add to Library Button
                                ElevatedButton.icon(
                                  onPressed: () async {
                                    if (isInLibrary) {
                                      final confirm = await showDialog(
                                        context: context,
                                        builder:
                                            (context) => AlertDialog(
                                              title: const Text('Remove Book?'),
                                              content: Text(
                                                'Do you want to remove ${selectedBook.title} from your library?',
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
                                        provider.removeFromLibrary(
                                          selectedBook.id,
                                        );
                                        if (context.mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                '${selectedBook.title} removed from library',
                                              ),
                                              duration: const Duration(
                                                milliseconds: 500,
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    } else {
                                      provider.addToLibrary(
                                        BooksHiveModel(
                                          id: selectedBook.id,
                                          title: selectedBook.title,
                                          authors: selectedBook.authors,
                                          description: selectedBook.description,
                                          thumbnail: selectedBook.thumbnail,
                                          addedAt: selectedBook.addedAt,
                                          publishedDate:
                                              selectedBook.publishedDate,
                                          publisher: selectedBook.publisher,
                                          pageCount: selectedBook.pageCount,
                                          mainCategory:
                                              selectedBook.mainCategory,
                                          category: selectedBook.category,
                                          language: selectedBook.language,
                                          isbn: selectedBook.isbn,
                                          rating: null,
                                          note: null,
                                          favourite: false,
                                          readingStatus: 'Unread',
                                        ),
                                      );
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              '${selectedBook.title} added to library',
                                            ),
                                            duration: const Duration(
                                              milliseconds: 700,
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        isInLibrary
                                            ? Colors.green[600]
                                            : Colors.blue[600],
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 16,
                                    ),
                                    elevation: isInLibrary ? 0 : 4,
                                    shadowColor:
                                        isInLibrary
                                            ? Colors.transparent
                                            : Colors.blue.withOpacity(0.4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  icon: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(
                                      isInLibrary ? Icons.check : Icons.add,
                                      size: 20,
                                    ),
                                  ),
                                  label: Text(
                                    isInLibrary
                                        ? 'In Library'
                                        : 'Add to Library',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                                if (isInLibrary) ...[
                                  const SizedBox(width: 10),
                                  // Favourite Button
                                  Container(
                                    height: 48,
                                    width: 48,
                                    decoration: BoxDecoration(
                                      color:
                                          isFavourite
                                              ? const Color.fromARGB(
                                                255,
                                                255,
                                                183,
                                                0,
                                              )
                                              : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: Icon(
                                        Icons.star,
                                        color:
                                            isFavourite
                                                ? Colors.white
                                                : Colors.grey,
                                        size: 28,
                                      ),
                                      onPressed: () {
                                        provider.toggleFavorite(selectedBook);
                                      },
                                    ),
                                  ),
                                ],
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Book Details
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    selectedBook.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Authors
                  if (selectedBook.authors.isNotEmpty)
                    Text(
                      'by ${selectedBook.authors.join(', ')}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  const SizedBox(height: 20),

                  // Rating and Reading Status for Library Books
                  Consumer<BooksProvider>(
                    builder: (context, provider, child) {
                      final isInLibrary = provider.userLibrary.any(
                        (b) => b.id == selectedBook.id,
                      );
                      if (!isInLibrary) return const SizedBox.shrink();

                      final updatedBook = provider.userLibrary.firstWhere(
                        (b) => b.id == selectedBook.id,
                      );

                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Rating
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Your Rating',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                StarRating(
                                  rating: updatedBook.rating,
                                  onRatingChanged: (newRating) {
                                    provider.updateBookRating(
                                      selectedBook.id,
                                      newRating,
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Reading Status
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Reading Status',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                StatefulBuilder(
                                  builder: (context, setState) {
                                    String selectedOption =
                                        updatedBook.readingStatus;
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color:
                                              selectedOption == 'Reading'
                                                  ? Colors.blue
                                                  : (selectedOption == 'To Read'
                                                      ? Colors.orange
                                                      : (selectedOption ==
                                                              'Read'
                                                          ? Colors.green
                                                          : Colors.grey)),
                                        ),
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: DropdownButton<String>(
                                        value: selectedOption,
                                        underline: const SizedBox(),
                                        icon: const Icon(Icons.arrow_drop_down),
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
                                                      size: 12,
                                                      color:
                                                          option == 'Reading'
                                                              ? Colors.blue
                                                              : (option ==
                                                                      'To Read'
                                                                  ? Colors
                                                                      .orange
                                                                  : (option ==
                                                                          'Read'
                                                                      ? Colors
                                                                          .green
                                                                      : Colors
                                                                          .grey)),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      option,
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color:
                                                            option == 'Reading'
                                                                ? Colors
                                                                    .blue[600]
                                                                : (option ==
                                                                        'To Read'
                                                                    ? Colors
                                                                        .orange[600]
                                                                    : (option ==
                                                                            'Read'
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
                                            selectedBook.id,
                                            selectedOption,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Book Information Cards
                  _buildInfoCard(
                    'Publisher',
                    selectedBook.publisher ?? 'Unknown',
                    Icons.business,
                  ),

                  if (selectedBook.publishedDate != null &&
                      selectedBook.publishedDate!.isNotEmpty)
                    _buildInfoCard(
                      'Published Date',
                      selectedBook.publishedDate!,
                      Icons.calendar_today,
                    ),

                  if (selectedBook.pageCount != null &&
                      selectedBook.pageCount! > 0)
                    _buildInfoCard(
                      'Pages',
                      '${selectedBook.pageCount} pages',
                      Icons.menu_book,
                    ),

                  if (selectedBook.language.isNotEmpty)
                    _buildInfoCard(
                      'Language',
                      _getLanguageName(selectedBook.language),
                      Icons.language,
                    ),

                  if (selectedBook.category.isNotEmpty)
                    _buildInfoCard(
                      'Categories',
                      selectedBook.category.join(', '),
                      Icons.category,
                    ),

                  if (selectedBook.isbn.isNotEmpty)
                    _buildInfoCard(
                      'ISBN',
                      selectedBook.isbn.first,
                      Icons.qr_code,
                    ),

                  const SizedBox(height: 10),

                  // Description Section
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.description_outlined,
                          size: 20,
                          color: Colors.blue[700],
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'About this Book',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue[50]!.withOpacity(0.3),
                          Colors.purple[50]!.withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.blue[100]!, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child:
                        selectedBook.description.isEmpty
                            ? Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 20,
                                  color: Colors.grey[500],
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'No description available for this book.',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            )
                            : Text(
                              selectedBook.description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                height: 1.7,
                                letterSpacing: 0.2,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                  ),

                  const SizedBox(height: 20),

                  // Notes Section (Only for Library Books)
                  Consumer<BooksProvider>(
                    builder: (context, provider, child) {
                      final isInLibrary = provider.userLibrary.any(
                        (b) => b.id == selectedBook.id,
                      );
                      if (!isInLibrary) return const SizedBox.shrink();

                      final updatedBook = provider.userLibrary.firstWhere(
                        (b) => b.id == selectedBook.id,
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Your Notes',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  addNoteDialog(context, updatedBook, provider);
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(minHeight: 100),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF9C4),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.amber.shade200,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              updatedBook.note?.isNotEmpty == true
                                  ? updatedBook.note!
                                  : 'Tap the edit icon to add your personal notes about this book...',
                              style: TextStyle(
                                fontSize: 14,
                                color:
                                    updatedBook.note?.isNotEmpty == true
                                        ? Colors.black87
                                        : Colors.grey[600],
                                height: 1.6,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.blue, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getLanguageName(String code) {
    final languages = {
      'en': 'English',
      'es': 'Spanish',
      'fr': 'French',
      'de': 'German',
      'it': 'Italian',
      'pt': 'Portuguese',
      'ru': 'Russian',
      'ja': 'Japanese',
      'zh': 'Chinese',
      'ko': 'Korean',
      'ar': 'Arabic',
      'hi': 'Hindi',
    };
    return languages[code] ?? code.toUpperCase();
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
