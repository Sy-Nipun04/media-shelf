import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/category_models.dart';
import '../models/yourlist_models.dart';
import '../providers/books_provider.dart';
import 'package:provider/provider.dart';
import 'search_result.dart';
import 'books_library.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CategoryModel> categories = [];
  List<YourListModels> yourList = [];
  final TextEditingController searchController = TextEditingController();

  void _getInitalInfo() {
    categories = CategoryModel.getCategories();
    yourList = YourListModels.getYourList();
  }

  @override
  void initState() {
    super.initState();
    _getInitalInfo();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BooksProvider>(context);
    return Scaffold(
      appBar: appBar(),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          searchBar(provider),
          InkWell(
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromRGBO(29, 22, 23, 0.11),
                    blurRadius: 40,
                    spreadRadius: 0.0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Your Library",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LibraryScreen()),
              );
            },
          ),
          const SizedBox(height: 10),
          categoriesSection(),
          SizedBox(height: 20),
          yourlistSection(),
        ],
      ),
    );
  }

  Column yourlistSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(left: 20),
          child: Text(
            "Your List",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: 15),
        Container(
          height: 220,
          child: ListView.separated(
            itemCount: yourList.length,
            separatorBuilder: (context, index) => SizedBox(width: 5),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Container(
                width: 150,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: yourList[index].boxColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      yourList[index].iconPath,
                      width: 60,
                      height: 60,
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        yourList[index].title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        yourList[index].author,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Column categoriesSection() {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(left: 20),
          child: Text(
            "Category",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: 15),
        Container(
          height: 170,
          //Try ListView.separated next time
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: categories[index].boxColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                width: 120,
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        categories[index].icon.icon,
                        size: 40,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Text(
                        categories[index].name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Container searchBar(provider) {
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
                      if (mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SearchResultPage()),
                        );
                      }
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
          searchController.clear();
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SearchResultPage()),
            );
          }
        },
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: const Text(
        'Home Page',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      elevation: 0.0,
      backgroundColor: Colors.white,
      leading: GestureDetector(
        onTap: () {},
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
