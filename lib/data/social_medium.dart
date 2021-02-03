import 'dart:convert';

// ^ API Endpoints ^ //
const MEDIUM_API_FEED =
    'https://api.rss2json.com/v1/api.json?rss_url=https://medium.com/feed/@';

// ^ Model ^ //
class MediumModel {
  String status;
  Feed feed;
  List<Post> posts;

  MediumModel({this.status, this.feed, this.posts});

  MediumModel.fromResponse(dynamic respBody) {
    Map<String, dynamic> json = jsonDecode(respBody);
    status = json['status'];
    feed = json['feed'] != null ? new Feed.fromJson(json['feed']) : null;
    if (json['items'] != null) {
      posts = <Post>[];
      json['items'].forEach((v) {
        posts.add(new Post.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.feed != null) {
      data['feed'] = this.feed.toJson();
    }
    if (this.posts != null) {
      data['items'] = this.posts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Feed {
  String url;
  String title;
  String link;
  String author;
  String description;
  String image;

  Feed(
      {this.url,
      this.title,
      this.link,
      this.author,
      this.description,
      this.image});

  Feed.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    title = json['title'];
    link = json['link'];
    author = json['author'];
    description = json['description'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['title'] = this.title;
    data['link'] = this.link;
    data['author'] = this.author;
    data['description'] = this.description;
    data['image'] = this.image;
    return data;
  }
}

class Post {
  String title;
  String pubDate;
  String link;
  String guid;
  String author;
  String thumbnail;
  String description;
  String content;
  List<String> categories;

  Post(
      {this.title,
      this.pubDate,
      this.link,
      this.guid,
      this.author,
      this.thumbnail,
      this.description,
      this.content,
      this.categories});

  Post.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    pubDate = json['pubDate'];
    link = json['link'];
    guid = json['guid'];
    author = json['author'];
    thumbnail = json['thumbnail'];
    description = json['description'];
    content = json['content'];

    categories = json['categories'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['pubDate'] = this.pubDate;
    data['link'] = this.link;
    data['guid'] = this.guid;
    data['author'] = this.author;
    data['thumbnail'] = this.thumbnail;
    data['description'] = this.description;
    data['content'] = this.content;
    data['categories'] = this.categories;
    return data;
  }
}
