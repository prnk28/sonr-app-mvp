import 'dart:convert';
import 'package:flutter/services.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart';
import 'package:get/get.dart';
import 'package:sonar_app/data/social_medium.dart';
import 'package:sonar_app/data/social_twitter.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';
export 'package:sonr_core/models/models.dart';

// ** Handles SocialMedia ** //
const K_FB_GRAPH = 'https://graph.facebook.com/v2.12/';

class SocialMediaService extends GetxService {
  String _twitterBearer;
  // ignore: unused_field
  String _twitterConsumer;
  // ignore: unused_field
  String _twitterSecret;

  Future<SocialMediaService> init() async {
    final data = await rootBundle.loadString('assets/keys.json', cache: false);
    var result = jsonDecode(data);
    _twitterBearer = result["twitterBearer"];
    _twitterConsumer = result["twitterConsumer"];
    _twitterSecret = result["twitterSecret"];
    return this;
  }

  // * ------------------------ * //
  // * ---- Authentication ---- * //
  // * ------------------------ * //
  // ^ Simple Username Validation ^ //
  Future<bool> validate(Contact_SocialTile_Provider prv, String usr) async {
    switch (prv) {
      case Contact_SocialTile_Provider.Medium:
        MediumData data = await getMedium(usr);
        return data.status == "ok";
        break;
      case Contact_SocialTile_Provider.Spotify:
        // TODO
        break;
      case Contact_SocialTile_Provider.TikTok:
        // TODO
        break;
      case Contact_SocialTile_Provider.Twitter:
        TwitterUserModel data = await getTwitterUser(usr);
        return data.errors.isEmpty;
        break;
      case Contact_SocialTile_Provider.YouTube:
        // TODO
        break;
    }
    return false;
  }

  // * ------------------- * //
  // * ---- Retreival ---- * //
  // * ------------------- * //
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
  Future<MediumData> getMedium(String username) async {
    //  Request with UserID
    final resp = await get(MEDIUM_API_FEED + username);

    //  Valid Status
    if (resp.statusCode == 200) {
      return MediumData.fromResponse(resp.body);
    }
    // ! Invalid Code
    else {
      SonrSnack.error("Something went wrong");
      return null;
    }
  }
}
