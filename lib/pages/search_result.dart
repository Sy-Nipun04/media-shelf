import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/books_provider.dart';
import '../models/books_model.dart';
import '../hive_models/books_hive_model.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({super.key});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BooksProvider>(context);
    List<Book> userLibrary = provider.userLibrary;

    return Scaffold(
      appBar: AppBar(title: const Text('Search Results')),
      body: Column(
        children: [
          searchBar1(provider, context),
          provider.searchResults.isEmpty
              ? const Center(child: Text('No results found'))
              : searchList(userLibrary, provider),
        ],
      ),
    );
  }

  Expanded searchList(userLibrary, BooksProvider provider) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: provider.searchResults.length,
        itemBuilder: (context, index) {
          Book book = provider.searchResults[index];
          return ListTile(
            leading:
                book.thumbnail.isNotEmpty
                    ? Image.network(
                      book.thumbnail,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 100,
                          width: 60,
                          color: Colors.grey[300],
                          child: Center(
                            child: const Icon(Icons.book, color: Colors.grey),
                          ),
                        );
                      },
                      fit: BoxFit.cover,
                    )
                    : const Icon(Icons.book),
            title: Text(
              book.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(book.authors.join(', ')),
            trailing:
                (!userLibrary.any((b) => b.id == book.id))
                    ? Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
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
                            ),
                          );
                        },
                      ),
                    )
                    : Container(
                      decoration: BoxDecoration(
                        color: Colors.green[200],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () async {
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
                                        () => Navigator.of(context).pop(false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(true),
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
                        },
                      ),
                    ),
          );
        },
      ),
    );
  }

  Container searchBar1(BooksProvider provider, BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
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
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Search',
          filled: true,
          fillColor: Colors.white,
          hintStyle: const TextStyle(color: Color.fromARGB(255, 153, 153, 153)),
          contentPadding: const EdgeInsets.all(15),
          prefixIcon:
              provider.isLoading
                  ? Padding(
                    padding: const EdgeInsets.all(14),
                    child: const CircularProgressIndicator(color: Colors.grey),
                  )
                  : IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Color.fromARGB(255, 153, 153, 153),
                    ),
                    onPressed: () async {
                      await provider.search(searchController.text);
                      //searchController.clear();
                      setState(() {});
                    },
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
                        // Add filter functionality here
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
        onSubmitted: (text) async {
          await provider.search(text);
          //searchController.clear();
          setState(() {});
        },
      ),
    );
  }
}
