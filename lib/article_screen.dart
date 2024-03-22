// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Article {
  final String title;
  final String? urlToImage;
  final String? author;
  final String? description;
  final String? content;
  Article({
    required this.title,
    this.urlToImage,
    this.author,
    this.description,
    this.content,
  });



  Article copyWith({
    String? title,
    String? urlToImage,
    String? author,
    String? description,
    String? content,
  }) {
    return Article(
      title: title ?? this.title,
      urlToImage: urlToImage ?? this.urlToImage,
      author: author ?? this.author,
      description: description ?? this.description,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'urlToImage': urlToImage,
      'author': author,
      'description': description,
      'content': content,
    };
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      title: map['title'] as String,
      urlToImage: map['urlToImage'] != null ? map['urlToImage'] as String : null,
      author: map['author'] != null ? map['author'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      content: map['content'] != null ? map['content'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Article.fromJson(String source) => Article.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Article(title: $title, urlToImage: $urlToImage, author: $author, description: $description, content: $content)';
  }

  @override
  bool operator ==(covariant Article other) {
    if (identical(this, other)) return true;
  
    return 
      other.title == title &&
      other.urlToImage == urlToImage &&
      other.author == author &&
      other.description == description &&
      other.content == content;
  }

  @override
  int get hashCode {
    return title.hashCode ^
      urlToImage.hashCode ^
      author.hashCode ^
      description.hashCode ^
      content.hashCode;
  }
}


