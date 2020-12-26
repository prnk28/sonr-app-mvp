import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:get/get.dart';
import 'package:sonar_app/data/social_medium.dart';
import 'package:sonar_app/data/social_twitter.dart';
import 'package:sonar_app/data/social_youtube.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';

// ** Handles SocialMedia ** //
const K_FB_GRAPH = 'https://graph.facebook.com/v2.12/';

class SocialMediaService extends GetxService {
  String _twitterBearer;
  // ignore: unused_field
  String _twitterConsumer;
  // ignore: unused_field
  String _twitterSecret;
  String _youtubeKey;

  Future<SocialMediaService> init() async {
    final data = await rootBundle.loadString('assets/keys.json', cache: false);
    var result = jsonDecode(data);
    _twitterBearer = result["twitterBearer"];
    _twitterConsumer = result["twitterConsumer"];
    _twitterSecret = result["twitterSecret"];
    _youtubeKey = result["youtubeKey"];
    return this;
  }

  // * ------------------------ * //
  // * ---- Authentication ---- * //
  // * ------------------------ * //
  // ^ Simple Username Validation ^ //
  Future<bool> validate(Contact_SocialTile_Provider prv, String query) async {
    switch (prv) {
      case Contact_SocialTile_Provider.Medium:
        MediumModel data = await getMedium(query);
        return data.status == "ok";
        break;
      case Contact_SocialTile_Provider.Spotify:
        // TODO
        break;
      case Contact_SocialTile_Provider.TikTok:
        // TODO
        break;
      case Contact_SocialTile_Provider.Twitter:
        TwitterUserModel data = await getTwitterUser(query);
        return data.errors.isEmpty;
        break;
      case Contact_SocialTile_Provider.YouTube:
        YoutubeModel data = await getYoutube(query);
        return data.items.isNotEmpty;
        break;
    }
    return false;
  }

  // * ------------------- * //
  // * ---- Retreival ---- * //
  // * ------------------- * //
  // ^ Gets Medium Data as RSS Feed then Converts to JSON ^ //
  Future<MediumModel> getMedium(String username) async {
    //  Request with UserID
    final resp = await get(MEDIUM_API_FEED + username);

    //  Valid Status
    if (resp.statusCode == 200) {
      return MediumModel.fromResponse(resp.body);
    }
    // ! Invalid Code
    else {
      SonrSnack.error("Something went wrong");
      return null;
    }
  }

  // ^ Retreive Profile/ Tweets ^ //
  Future<TweetsModel> getTweets(String username) async {
    // Valid Status
    final tweetResp = await get(
        TWITTER_API_TWEETS + username + TWITTER_FIELDS_TWEETS,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_twitterBearer',
        });

    if (tweetResp.statusCode == 200) {
      return TweetsModel.fromResponse(tweetResp.body);
    }

    // ! Invalid Code
    else {
      SonrSnack.error("Something went wrong");
      return null;
    }
  }

  // ^ Retreive Profile/ Tweets ^ //
  Future<TwitterUserModel> getTwitterUser(String username) async {
    // Perform Request
    final userResp = await get(
        TWITTER_API_USERS + username + TWITTER_FIELDS_USERS,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_twitterBearer',
        });

    // Valid Status
    if (userResp.statusCode == 200) {
      return TwitterUserModel.fromResponse(userResp.body);
    }

    // ! Invalid Code
    else {
      SonrSnack.error("Something went wrong");
      return null;
    }
  }

  // ^ Gets Medium Data as RSS Feed then Converts to JSON ^ //
  Future<YoutubeModel> getYoutube(String video) async {
    // Perform Request
    final youResp = await get(
        YOUTUBE_API_SEARCH + video + YOUTUBE_KEY + _youtubeKey,
        headers: {
          'Accept': 'application/json',
        });

    //  Valid Status
    if (youResp.statusCode == 200) {
      return YoutubeModel.fromResponse(youResp.body);
    }
    // ! Invalid Code
    else {
      SonrSnack.error("Something went wrong");
      return null;
    }
  }
}
