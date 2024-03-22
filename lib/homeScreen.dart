import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'article_screen.dart';
import 'detail_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String selectedCategory;
  String searchQuery = '';
  @override
  void initState() {
    super.initState();
    selectedCategory = 'general'; 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 28,
            ),

            //Ngay thang
            Text(
              DateFormat('EEE, dd\'th\' MMMM yyyy').format(DateTime.now()),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            //Title
            const Text(
              'Explore',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),

            const SizedBox(
              height: 32,
            ),

            //TextFormField

            Container(
              margin: const EdgeInsets.only(right: 16.0),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.0)),
              clipBehavior: Clip.antiAlias,
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(fillColor: Colors.grey.shade300, filled: true, border: InputBorder.none, prefixIcon: const Icon(Icons.search), hintText: "Search for articles..."),
                onTap: () {},
              ),
            ),
            const SizedBox(
              height: 32,
            ),

            //Danh sach the loai
            SizedBox(
                height: 40,
                child: CategoriesBar(
                  onCategorySelected: (category) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                )),

            //Danh sach bai bao

            const SizedBox(height: 24),

            Expanded(
                child: ArticleList(
              category: selectedCategory,
              searchQuery: searchQuery,
            )),
          ],
        )),
      ),
    );
  }
}

class CategoriesBar extends StatefulWidget {
  final Function(String) onCategorySelected;
  const CategoriesBar({super.key, required this.onCategorySelected});

  @override
  State<CategoriesBar> createState() => _CategoriesBarState();
}

class _CategoriesBarState extends State<CategoriesBar> {
  List<String> categories = [
    'General',
    'Science',
    'Sports',
    'Health',
    'Entertainment',
    'Technology',
    'Business',
  ];

  int selectedCategory = 0;

  get http => null;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // selectedCategory = index;
            setState(() {
              selectedCategory = index;
            });
            widget.onCategorySelected(categories[index]);
          },
          child: Container(
            margin: const EdgeInsets.only(right: 8.0),
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 20.0,
            ),
            decoration: BoxDecoration(
              color: selectedCategory == index ? Colors.black : Colors.white,
              border: Border.all(),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Center(
              child: Text(
                categories.elementAt(index),
                style: TextStyle(
                  color: selectedCategory == index ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ArticleList extends StatefulWidget {
  final String category;
  final String searchQuery;
  const ArticleList({Key? key, required this.category, required this.searchQuery}) : super(key: key);

  @override
  _ArticleListState createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {
  late Future<List<Article>> futureArticles;

  @override
  void initState() {
    super.initState();
    futureArticles = getArticles(widget.category, widget.searchQuery); // Pass searchQuery to getArticles
  }

  @override
  void didUpdateWidget(covariant ArticleList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.category != oldWidget.category || widget.searchQuery != oldWidget.searchQuery) {
      setState(() {
        futureArticles = getArticles(widget.category, widget.searchQuery);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureArticles,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.active:
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            final data = snapshot.data as List<Article>;
            return ListView.builder(
              //padding: const EdgeInsets.only(right: 8.0),
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ArticleTitle(
                  article: data[index],
                );
              },
            );
        }
      },
    );
  }

  Future<List<Article>> getArticles(String category, String searchQuery) async {
    var url = 'https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=0efae46792d94f8998baf86c5f2ceb5f';

    if (searchQuery.isNotEmpty) {
      url += '&q=$searchQuery';
    }
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as Map<String, dynamic>;
      final List<Article> result = [];

      for (final article in body['articles']) {
        result.add(Article(
          title: article['title'] ?? '',
          urlToImage: article['urlToImage'] ?? '',
          author: article['author'] ?? '',
          content: article['content'] ?? '',
          description: article['description'] ?? '',
        ));
      }
      return result;
    } else {
      throw Exception('Failed to load articles');
    }
  }
}

class ArticleTitle extends StatelessWidget {
  const ArticleTitle({Key? key, required this.article}) : super(key: key);

  final Article article;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NewsDetailPage(article: article),
        ));
      },
      child: Container(
        height: 150,
        // margin: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NewsDetailPage(article: article),
                ));
              },
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  article.urlToImage ?? '',
                  fit: BoxFit.cover,
                  height: 100,
                  width: 100,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 100,
                      width: 100,
                      color: Colors.blue,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    maxLines: 3,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    article.author!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
