class News {
  Source _source;
  String _title;
  String _author;
  String _content;
  String _imageUrl;
  String _publishedAt;

  News(this._source, this._author, this._title, this._content, this._imageUrl,
      this._publishedAt);

  // criar um método fábrica(factory) converter o json em objeto Dart
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      Source.fromJson(json["source"]),
      json["author"],
      json["title"],
      json["content"],
      json["urlToImage"],
      json["publishedAt"]
    );
  }

  Source get source => _source;

  String get author => _author;

  String get title => _title;

  String get content => _content;

  String get imageUrl => _imageUrl;

  String get publishedAt => _publishedAt;
}


class Source {
  String _id;
  String _name;

  Source(this._id, this._name);

  // criar um método fábrica(factory) converter o json em objeto Dart
  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(json["id"], json["name"]);
  }
}