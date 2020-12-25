import 'dart:convert';

// ^ API Endpoints ^ //
const TWITTER_API_USERS = "https://api.twitter.com/2/users/by?usernames=";
const TWITTER_API_TWEETS =
    "https://api.twitter.com/2/tweets/search/recent?query=from:";
const TWITTER_FIELDS_USERS =
    "&user.fields=created_at,description,entities,pinned_tweet_id,public_metrics,url,verified,profile_image_url";
const TWITTER_FIELDS_TWEETS =
    "&tweet.fields=created_at&expansions=author_id&user.fields=created_at";

// ^ Model ^ //
class TweetsModel {
  List<Tweet> tweets;
  List<Errors> errors;

  TweetsModel({this.tweets, this.errors});

  TweetsModel.fromResponse(dynamic respBody) {
    Map<String, dynamic> json = jsonDecode(respBody);
    if (json['data'] != null) {
      tweets = new List<Tweet>();
      json['data'].forEach((v) {
        tweets.add(new Tweet.fromJson(v));
      });
    }
    if (json['errors'] != null) {
      errors = new List<Errors>();
      json['errors'].forEach((v) {
        errors.add(new Errors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tweets != null) {
      data['data'] = this.tweets.map((v) => v.toJson()).toList();
    }
    if (this.errors != null) {
      data['errors'] = this.errors.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TwitterUserModel {
  List<UserData> data;
  List<Errors> errors;

  TwitterUserModel({this.data, this.errors});

  TwitterUserModel.fromResponse(dynamic respBody) {
    Map<String, dynamic> json = jsonDecode(respBody);
    if (json['data'] != null) {
      data = new List<UserData>();
      json['data'].forEach((v) {
        data.add(new UserData.fromJson(v));
      });
    }
    if (json['errors'] != null) {
      errors = new List<Errors>();
      json['errors'].forEach((v) {
        errors.add(new Errors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tweet {
  String authorId;
  String conversationId;
  String createdAt;
  String id;
  String text;
  Attachments attachments;
  Entities entities;
  List<ReferencedTweets> referencedTweets;

  Tweet(
      {this.authorId,
      this.conversationId,
      this.createdAt,
      this.id,
      this.text,
      this.attachments,
      this.entities,
      this.referencedTweets});

  Tweet.fromJson(Map<String, dynamic> json) {
    authorId = json['author_id'];
    conversationId = json['conversation_id'];
    createdAt = json['created_at'];
    id = json['id'];
    text = json['text'];
    attachments = json['attachments'] != null
        ? new Attachments.fromJson(json['attachments'])
        : null;
    entities = json['entities'] != null
        ? new Entities.fromJson(json['entities'])
        : null;
    if (json['referenced_tweets'] != null) {
      referencedTweets = new List<ReferencedTweets>();
      json['referenced_tweets'].forEach((v) {
        referencedTweets.add(new ReferencedTweets.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['author_id'] = this.authorId;
    data['conversation_id'] = this.conversationId;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['text'] = this.text;
    if (this.attachments != null) {
      data['attachments'] = this.attachments.toJson();
    }
    if (this.entities != null) {
      data['entities'] = this.entities.toJson();
    }
    if (this.referencedTweets != null) {
      data['referenced_tweets'] =
          this.referencedTweets.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attachments {
  List<String> mediaKeys;

  Attachments({this.mediaKeys});

  Attachments.fromJson(Map<String, dynamic> json) {
    mediaKeys = json['media_keys'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['media_keys'] = this.mediaKeys;
    return data;
  }
}

class Entities {
  List<Urls> urls;
  List<Mentions> mentions;
  List<Hashtags> hashtags;

  Entities({this.urls, this.mentions, this.hashtags});

  Entities.fromJson(Map<String, dynamic> json) {
    if (json['urls'] != null) {
      urls = new List<Urls>();
      json['urls'].forEach((v) {
        urls.add(new Urls.fromJson(v));
      });
    }
    if (json['mentions'] != null) {
      mentions = new List<Mentions>();
      json['mentions'].forEach((v) {
        mentions.add(new Mentions.fromJson(v));
      });
    }
    if (json['hashtags'] != null) {
      hashtags = new List<Hashtags>();
      json['hashtags'].forEach((v) {
        hashtags.add(new Hashtags.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.urls != null) {
      data['urls'] = this.urls.map((v) => v.toJson()).toList();
    }
    if (this.mentions != null) {
      data['mentions'] = this.mentions.map((v) => v.toJson()).toList();
    }
    if (this.hashtags != null) {
      data['hashtags'] = this.hashtags.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Urls {
  int start;
  int end;
  String url;
  String expandedUrl;
  String displayUrl;
  List<Images> images;
  int status;
  String title;
  String description;
  String unwoundUrl;

  Urls(
      {this.start,
      this.end,
      this.url,
      this.expandedUrl,
      this.displayUrl,
      this.images,
      this.status,
      this.title,
      this.description,
      this.unwoundUrl});

  Urls.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
    url = json['url'];
    expandedUrl = json['expanded_url'];
    displayUrl = json['display_url'];
    if (json['images'] != null) {
      images = new List<Images>();
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
    status = json['status'];
    title = json['title'];
    description = json['description'];
    unwoundUrl = json['unwound_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start'] = this.start;
    data['end'] = this.end;
    data['url'] = this.url;
    data['expanded_url'] = this.expandedUrl;
    data['display_url'] = this.displayUrl;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['title'] = this.title;
    data['description'] = this.description;
    data['unwound_url'] = this.unwoundUrl;
    return data;
  }
}

class Images {
  String url;
  int width;
  int height;

  Images({this.url, this.width, this.height});

  Images.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['width'] = this.width;
    data['height'] = this.height;
    return data;
  }
}

class Mentions {
  int start;
  int end;
  String username;

  Mentions({this.start, this.end, this.username});

  Mentions.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start'] = this.start;
    data['end'] = this.end;
    data['username'] = this.username;
    return data;
  }
}

class Hashtags {
  int start;
  int end;
  String tag;

  Hashtags({this.start, this.end, this.tag});

  Hashtags.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = json['end'];
    tag = json['tag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start'] = this.start;
    data['end'] = this.end;
    data['tag'] = this.tag;
    return data;
  }
}

class ReferencedTweets {
  String type;
  String id;

  ReferencedTweets({this.type, this.id});

  ReferencedTweets.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['id'] = this.id;
    return data;
  }
}

class Errors {
  String detail;
  String title;
  String resourceType;
  String parameter;
  String value;
  String type;

  Errors(
      {this.detail,
      this.title,
      this.resourceType,
      this.parameter,
      this.value,
      this.type});

  Errors.fromJson(Map<String, dynamic> json) {
    detail = json['detail'];
    title = json['title'];
    resourceType = json['resource_type'];
    parameter = json['parameter'];
    value = json['value'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['detail'] = this.detail;
    data['title'] = this.title;
    data['resource_type'] = this.resourceType;
    data['parameter'] = this.parameter;
    data['value'] = this.value;
    data['type'] = this.type;
    return data;
  }
}

class UserData {
  Entities entities;
  String createdAt;
  String description;
  PublicMetrics publicMetrics;
  String username;
  String pinnedTweetId;
  String id;
  String name;
  bool verified;
  String url;
  String profilePicUrl;

  UserData(
      {this.entities,
      this.createdAt,
      this.description,
      this.publicMetrics,
      this.username,
      this.pinnedTweetId,
      this.id,
      this.name,
      this.verified,
      this.url,
      this.profilePicUrl});

  UserData.fromJson(Map<String, dynamic> json) {
    entities = json['entities'] != null
        ? new Entities.fromJson(json['entities'])
        : null;
    createdAt = json['created_at'];
    description = json['description'];
    publicMetrics = json['public_metrics'] != null
        ? new PublicMetrics.fromJson(json['public_metrics'])
        : null;
    username = json['username'];
    pinnedTweetId = json['pinned_tweet_id'];
    id = json['id'];
    name = json['name'];
    verified = json['verified'];
    url = json['url'];
    profilePicUrl = json['profile_image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.entities != null) {
      data['entities'] = this.entities.toJson();
    }
    data['created_at'] = this.createdAt;
    data['description'] = this.description;
    if (this.publicMetrics != null) {
      data['public_metrics'] = this.publicMetrics.toJson();
    }
    data['username'] = this.username;
    data['pinned_tweet_id'] = this.pinnedTweetId;
    data['id'] = this.id;
    data['name'] = this.name;
    data['verified'] = this.verified;
    data['url'] = this.url;
    return data;
  }
}

class Url {
  List<Urls> urls;

  Url({this.urls});

  Url.fromJson(Map<String, dynamic> json) {
    if (json['urls'] != null) {
      urls = new List<Urls>();
      json['urls'].forEach((v) {
        urls.add(new Urls.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.urls != null) {
      data['urls'] = this.urls.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Description {
  List<Hashtags> hashtags;

  Description({this.hashtags});

  Description.fromJson(Map<String, dynamic> json) {
    if (json['hashtags'] != null) {
      hashtags = new List<Hashtags>();
      json['hashtags'].forEach((v) {
        hashtags.add(new Hashtags.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.hashtags != null) {
      data['hashtags'] = this.hashtags.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PublicMetrics {
  int followersCount;
  int followingCount;
  int tweetCount;
  int listedCount;

  PublicMetrics(
      {this.followersCount,
      this.followingCount,
      this.tweetCount,
      this.listedCount});

  PublicMetrics.fromJson(Map<String, dynamic> json) {
    followersCount = json['followers_count'];
    followingCount = json['following_count'];
    tweetCount = json['tweet_count'];
    listedCount = json['listed_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['followers_count'] = this.followersCount;
    data['following_count'] = this.followingCount;
    data['tweet_count'] = this.tweetCount;
    data['listed_count'] = this.listedCount;
    return data;
  }
}
