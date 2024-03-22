
import 'package:flutter/material.dart';
import 'package:newsapi/article_screen.dart';
import 'package:newsapi/detail_page.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoriteProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite'),
      ),
      body: ListView.builder(
        itemCount: provider.favourites.length,
        itemBuilder: (context, index) {
          final article = provider.favourites[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => NewsDetailPage(article: article),
              ));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 100,
                margin: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
                      clipBehavior: Clip.antiAlias,
                      child: Image.network(
                        article.urlToImage ?? '',
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 128,
                            width: 128,
                            color: Colors.blue,
                          );
                        },
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
                            article.author ?? '',
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
            ),
          );
        },
      ),
    );
  }
}

class FavoriteProvider extends ChangeNotifier {
  final List<Article> _favourites = [];
  List<Article> get favourites => _favourites;

  void toggleFavorite(Article article) {
    if (_favourites.contains(article)) {
      _favourites.remove(article);
    } else {
      _favourites.add(article);
    }
    notifyListeners();
  }

  bool isExist(Article article) {
    return _favourites.contains(article);
  }

  static FavoriteProvider of(
    BuildContext context, {
    bool listen = true,
  }) {
    return Provider.of<FavoriteProvider>(context, listen: listen);
  }
}
