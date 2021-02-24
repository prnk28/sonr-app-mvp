import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:get/get.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/service/user_service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';

// ** Handles SocialMedia ** //
const K_FB_GRAPH = 'https://graph.facebook.com/v2.12/';

enum SocialAuthType { Link, OAuth }
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

  // ** Return Current User Object **
  static List<Contact_SocialTile_Provider> get options {
    // Initialize
    var options = <Contact_SocialTile_Provider>[];

    // Iterate through All Options
    Contact_SocialTile_Provider.values.forEach((provider) {
      if (!UserService.socials.any((tile) => tile.provider == provider)) {
        options.add(provider);
      }
    });
    return options;
  }

  // * ------------------------ * //
  // * ---- Authentication ---- * //
  // * ------------------------ * //
  // ^ Simple Username Validation ^ //
  Future<bool> validate(Contact_SocialTile_Provider prv, String query, bool isPrivate) async {
    QueryUsernameResult result;
    switch (prv) {
      case Contact_SocialTile_Provider.Medium:
        result = QueryUsernameResult(query, prv, isPrivate, await getMedium(query));
        return result.isValid;
        break;
      case Contact_SocialTile_Provider.Spotify:
        // TODO
        break;
      case Contact_SocialTile_Provider.TikTok:
        // TODO
        break;
      case Contact_SocialTile_Provider.Twitter:
        // Perform Request
        final userResp = await get(TWITTER_API_USERS + query + TWITTER_FIELDS_USERS, headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $_twitterBearer',
        });

        result = QueryUsernameResult(query, prv, isPrivate, TwitterUserModel.fromResponse(userResp.body));
        return result.isValid;
        break;
      case Contact_SocialTile_Provider.YouTube:
        result = QueryUsernameResult(query, prv, isPrivate, await getYoutube(query));
        return result.isValid;
        break;
    }
    return false;
  }

  // ^ Get Links for User Social Profile ^ //
  Contact_SocialTile_Links getLinks(Contact_SocialTile_Provider prv, String username) {
    // Initialize
    var links = Contact_SocialTile_Links();

    // Check by provider
    switch (prv) {
      case Contact_SocialTile_Provider.Medium:
        links.userLink = "https://medium.com/@$username";
        break;
      case Contact_SocialTile_Provider.Spotify:
        links.userLink = "";
        break;
      case Contact_SocialTile_Provider.TikTok:
        links.userLink = "";
        break;
      case Contact_SocialTile_Provider.Twitter:
        links.userLink = "https://twitter.com/$username";
        break;
      case Contact_SocialTile_Provider.YouTube:
        links.userLink = "";
        break;
    }
    return links;
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
  Future<TwitterModel> getTwitter(String username) async {
    // Valid Status
    final tweetResp = await get(TWITTER_API_TWEETS + username + TWITTER_FIELDS_TWEETS, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_twitterBearer',
    });

    // Perform Request
    final userResp = await get(TWITTER_API_USERS + username + TWITTER_FIELDS_USERS, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $_twitterBearer',
    });

    // Check Response
    if (tweetResp.statusCode == 200 && userResp.statusCode == 200) {
      return TwitterModel.fromResponses(tweetResp.body, userResp.body);
    } else {
      SonrSnack.error("Something went wrong");
      return null;
    }
  }

  // ^ Gets Medium Data as RSS Feed then Converts to JSON ^ //
  Future<YoutubeModel> getYoutube(String video) async {
    // Perform Request
    final youResp = await get(YOUTUBE_API_SEARCH + video + YOUTUBE_KEY + _youtubeKey, headers: {
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
