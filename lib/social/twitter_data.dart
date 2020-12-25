import 'dart:convert';

// ^ API Endpoints ^ //
const TWITTER_API_USERS =
    "https://api.twitter.com/2/users/by?usernames=twitterdev,twitterapi,adsapi";
const TWITTER_FIELDS_USERS =
    "&user.fields=created_at&expansions=pinned_tweet_id&tweet.fields=author_id,created_at";

// ^ Model ^ //
class TwitterData {
  List<User> users;
  Tweets includes;

  TwitterData({this.users, this.includes});

  TwitterData.fromResponse(dynamic respBody) {
    Map<String, dynamic> json = jsonDecode(respBody);
    if (json['data'] != null) {
      users = new List<User>();
      json['data'].forEach((v) {
        users.add(new User.fromJson(v));
      });
    }
    includes =
        json['includes'] != null ? new Tweets.fromJson(json['includes']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.users != null) {
      data['data'] = this.users.map((v) => v.toJson()).toList();
    }
    if (this.includes != null) {
      data['includes'] = this.includes.toJson();
    }
    return data;
  }
}

class User {
  String createdAt;
  String id;
  String name;
  String pinnedTweetId;
  String username;

  User({this.createdAt, this.id, this.name, this.pinnedTweetId, this.username});

  User.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    id = json['id'];
    name = json['name'];
    pinnedTweetId = json['pinned_tweet_id'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['name'] = this.name;
    data['pinned_tweet_id'] = this.pinnedTweetId;
    data['username'] = this.username;
    return data;
  }
}

class Tweets {
  List<Tweet> tweets;

  Tweets({this.tweets});

  Tweets.fromJson(Map<String, dynamic> json) {
    if (json['tweets'] != null) {
      tweets = new List<Tweet>();
      json['tweets'].forEach((v) {
        tweets.add(new Tweet.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tweets != null) {
      data['tweets'] = this.tweets.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tweet {
  String authorId;
  String createdAt;
  String id;
  String text;

  Tweet({this.authorId, this.createdAt, this.id, this.text});

  Tweet.fromJson(Map<String, dynamic> json) {
    authorId = json['author_id'];
    createdAt = json['created_at'];
    id = json['id'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['author_id'] = this.authorId;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['text'] = this.text;
    return data;
  }
}
