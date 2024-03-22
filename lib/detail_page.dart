import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:newsapi/article_screen.dart';
import 'package:newsapi/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsDetailPage extends StatelessWidget {
  final Article article;

  const NewsDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              provider.toggleFavorite(article);
            },
            
            child: Icon(
              provider.isExist(article) ? Icons.favorite : Icons.favorite_border_outlined,
              color: Colors.red,
            ),
          )
         
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(article.urlToImage ?? ''),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '#Politics',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'By ${article.author ?? ''}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.content ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addToFavorites(List<Article> articles) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteArticles = articles.map((article) => json.encode(article.toJson())).toList();
    prefs.setStringList('favorite_articles', favoriteArticles);
  }
}
