import 'package:flutter/material.dart';
import 'package:project_1/models/books_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../providers/books_provider.dart';
import 'book info/book_details.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Save layout preference
Future<void> saveLayoutSetting(bool isGrid) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isGridLayout', isGrid);
}

// Load layout preference
Future<bool> loadLayoutSetting() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isGridLayout') ?? false; // default to list
}

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  bool isGrid = false;
  Timer? _debounce;
  Book? selectedBook;

  @override
  void initState() {
    super.initState();
    loadLayoutSetting().then((value) {
      setState(() {
        isGrid = value;
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<BooksProvider>(context, listen: false);
      await provider.loadSortPreference();
      provider.sortLibrary(provider.sortOption);
      provider.searchLibrary('');
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BooksProvider>(context);
    final library =
        provider.searchLibraryResults.isNotEmpty
            ? provider.searchLibraryResults
            : provider.userLibrary;

    return Scaffold(
      appBar: appBar1(context),
      backgroundColor: const Color.fromARGB(255, 238, 244, 254),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            searchBarLibrary(library, provider, context),
            Expanded(
              child:
                  library.isEmpty
                      ? const Center(child: Text('No books added yet'))
                      : (isGrid
                          ? libraryGrid(library, provider, context)
                          : libraryList(library, provider, context)),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchBarLibrary(
    List<Book> library,
    BooksProvider provider,
    BuildContext context,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(29, 22, 23, 0.11),
            blurRadius: 40,
            spreadRadius: 0.0,
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search books by title or author',
          filled: true,
          fillColor: Colors.white,
          hintStyle: const TextStyle(color: Color.fromARGB(255, 153, 153, 153)),
          contentPadding: const EdgeInsets.all(15),
          prefixIcon: const Icon(
            Icons.search,
            color: Color.fromARGB(255, 153, 153, 153),
          ),

          suffixIcon: Container(
            width: 80,
            margin: const EdgeInsets.only(right: 10),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  VerticalDivider(
                    indent: 10,
                    endIndent: 10,
                    color: Color.fromARGB(255, 153, 153, 153),
                    thickness: 0.1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: IconButton(
                      icon: Icon(
                        Icons.tune,
                        color: Color.fromARGB(255, 153, 153, 153),
                      ),
                      onPressed: () {
                        sortBottomSheet(context, provider);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          if (_debounce?.isActive ?? false) _debounce!.cancel();
          _debounce = Timer(const Duration(milliseconds: 300), () {
            setState(() {
              provider.searchLibrary(value);
            });
          });
        },
      ),
    );
  }

  Future<dynamic> sortBottomSheet(
    BuildContext context,
    BooksProvider provider,
  ) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Row(
                    children: const [
                      Icon(Icons.arrow_back),
                      SizedBox(width: 12),
                      Text(
                        'Sort by',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.schedule),
                    title: const Text('Recently Added'),
                    onTap: () {
                      setState(() {
                        provider.setSortOption('Recently Added');
                      });
                    },
                    trailing:
                        provider.sortOption == 'Recently Added'
                            ? const Icon(Icons.check, color: Colors.blue)
                            : null,
                  ),
                  ListTile(
                    leading: const Icon(Icons.title),
                    title: const Text('Title'),
                    onTap: () {
                      setState(() {
                        provider.setSortOption('Title');
                      });
                    },
                    trailing:
                        provider.sortOption == 'Title'
                            ? const Icon(Icons.check, color: Colors.blue)
                            : null,
                  ),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Author'),
                    onTap: () {
                      setState(() {
                        provider.setSortOption('Author');
                      });
                    },
                    trailing:
                        provider.sortOption == 'Author'
                            ? const Icon(Icons.check, color: Colors.blue)
                            : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  GridView libraryGrid(
    List<Book> library,
    BooksProvider provider,
    BuildContext context,
  ) {
    return GridView.builder(
      itemCount: library.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        final book = library[index];
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                bookPopUpInfo(context, book, library, provider);
              },
              child: Container(
                color: Color.fromRGBO(0xf7, 0xf8, 0xf8, 0.5),
                margin: const EdgeInsets.all(2),
                child: CachedNetworkImage(
                  imageUrl: book.thumbnail,
                  width: 110,
                  height: 160,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                  errorWidget:
                      (context, url, error) => Container(
                        height: 160,
                        width: 110,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.grey),
                onPressed: () async {
                  final confirm = await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Remove Book'),
                        content: Text(
                          'Are you sure you want to remove ${book.title} from your library?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
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
                          content: Text('${book.title} removed from library'),
                        ),
                      );
                    } else {
                      return;
                    }
                  } else {
                    return;
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  ListView libraryList(
    List<Book> library,
    BooksProvider provider,
    BuildContext context,
  ) {
    return ListView.separated(
      itemCount: library.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, index) {
        final book = library[index];
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                bookPopUpInfo(context, book, library, provider);
              },
              child: Container(
                color: Color.fromRGBO(0xf7, 0xf8, 0xf8, 0.5),
                //margin: const EdgeInsets.all(0),
                child: Row(
                  children: [
                    Flexible(
                      flex: 2,
                      child: CachedNetworkImage(
                        imageUrl: book.thumbnail,
                        width: 110,
                        height: 160,
                        fit: BoxFit.cover,
                        placeholder:
                            (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                        errorWidget:
                            (context, url, error) => Container(
                              height: 160,
                              width: 110,
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Flexible(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            book.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          Text(
                            book.authors.join(', '),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                              color: Color.fromARGB(255, 129, 129, 129),
                              overflow: TextOverflow.ellipsis,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.grey),
                onPressed: () async {
                  final confirm = await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Remove Book'),
                        content: Text(
                          'Are you sure you want to remove ${book.title} from your library?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
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
                          content: Text('${book.title} removed from library'),
                        ),
                      );
                    } else {
                      return;
                    }
                  } else {
                    return;
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  AppBar appBar1(BuildContext context) {
    return AppBar(
      title: const Text(
        'Your Library',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      elevation: 0.0,
      backgroundColor: const Color.fromRGBO(0xf7, 0xf8, 0xf8, 0.5),
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
        Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xffF7F8F8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: PopupMenuButton<int>(
            icon: const Icon(
              Icons.more_horiz,
              color: Color.fromARGB(255, 153, 153, 153),
              size: 20,
            ),
            onSelected: (value) {
              setState(() {
                isGrid = value == 1;
                saveLayoutSetting(isGrid);
              });
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: isGrid ? 0 : 1,
                    child: Row(
                      children: [
                        Icon(
                          isGrid ? Icons.list : Icons.grid_view,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 10),
                        isGrid
                            ? const Text('Layout: List')
                            : const Text('Layout: Grid'),
                      ],
                    ),
                  ),
                ],
          ),
        ),
      ],
    );
  }
}
