import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:http/http.dart';
import 'package:get/get.dart';
import 'package:sonar_app/service/device_service.dart';
import 'package:sonar_app/social/medium_data.dart';
import 'package:sonar_app/social/twitter_data.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';

// ** Handles SocialMedia ** //
const K_FB_GRAPH = 'https://graph.facebook.com/v2.12/';

class SocialMediaProvider extends GetxService {
  dynamic _apiKeys;

  init() async {
    final data = await rootBundle.loadString('assets/keys.json');
    _apiKeys = jsonDecode(data);
    return this;
  }

  // * ------------------------ * //
  // * ---- Authentication ---- * //
  // * ------------------------ * //

  // ^ Authenticates Facebook ^ //
  linkFacebook() async {
    // Set Vars
    final fb = FacebookLogin();
    fb.loginBehavior = FacebookLoginBehavior.webViewOnly;

    // Authorize User
    final result = await fb.logIn(['email']);

    // Check Status
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        // Save Auth to Persistent Data
        Get.find<DeviceService>().saveAuth(
            Contact_SocialTile_Provider.Facebook, [result.accessToken.token]);
        SonrSnack.success("Facebook link success");
        break;
      case FacebookLoginStatus.cancelledByUser:
        SonrSnack.cancelled("Facebook link stopped");
        break;
      case FacebookLoginStatus.error:
        SonrSnack.error("Something went wrong");
        break;
    }
  }

  // ^ Authenticates Twitter ^ //
  linkTwitter() async {
    // Set Vars
    var twitterLogin = new TwitterLogin(
      consumerKey: _apiKeys["twitterConsumer"],
      consumerSecret: _apiKeys["twitterSecret"],
    );

    // Authorize User
    final TwitterLoginResult result = await twitterLogin.authorize();

    // Check Status
    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        // Save Auth to Persistent Data
        Get.find<DeviceService>().saveAuth(Contact_SocialTile_Provider.Twitter,
            [result.session.token, result.session.secret]);
        SonrSnack.success("Twitter link success");
        break;
      case TwitterLoginStatus.cancelledByUser:
        SonrSnack.cancelled("Twitter link stopped");
        break;
      case TwitterLoginStatus.error:
        SonrSnack.error("Something went wrong");
        break;
    }
  }

  // * ------------------- * //
  // * ---- Retreival ---- * //
  // * ------------------- * //

  // ^ Retreive Profile Information ^ //
  Future getFacebook() async {
    // Get User Token
    final token = Get.find<DeviceService>()
        .getAuth(Contact_SocialTile_Provider.Facebook)[0];

    final response = await get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
  }

  // ^ Retreive Profile/ Tweets ^ //
  Future<TwitterData> getTwitter() async {
    // Perform Request
    final resp = await get(TWITTER_API_USERS + TWITTER_FIELDS_USERS, headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${_apiKeys["twitterBearer"]}',
    });

    // Valid Status
    if (resp.statusCode == 200) {
      return TwitterData.fromResponse(resp.body);
    }

    // ! Invalid Code
    else {
      SonrSnack.error("Something went wrong");
      return null;
    }
  }

  // ^ Gets Medium Data as RSS Feed then Converts to JSON ^ //
  Future<MediumData> getMedium(String userID) async {
    //  Request with UserID
    final resp = await get(MEDIUM_API_FEED + userID);

    //  Valid Status
    if (resp.statusCode == 200) {
      final feed = MediumData.fromResponse(resp.body);
      if (feed.status == "ok") {
        return feed;
      }

      // Display Error Snackbar
      else {
        SonrSnack.invalid("User not found");
        return null;
      }
    }
    // ! Invalid Code
    else {
      SonrSnack.error("Something went wrong");
      return null;
    }
  }
}
