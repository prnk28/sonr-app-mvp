import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonar_app/data/permission_model.dart';
import 'package:http/http.dart' as http;
import 'package:sonar_app/data/social_media/medium_model.dart';

import 'package:sonar_app/data/social_media/social_model.dart';
import 'package:sonar_app/data/user_model.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonr_core/sonr_core.dart';

// ** Handles SocialMedia ** //
class SocialMediaService extends GetxService {
  // References
  SharedPreferences _prefs;

  // Reactive Properties
  final user = Rx<User>();
  final enabledSocialMedia = List<SocialMediaItem>().obs;

  // ^ Open SharedPreferences on Init ^ //
  Future<SocialMediaService> init(User value) async {
    // Init Shared Preferences
    _prefs = await SharedPreferences.getInstance();

    // Set User and Refresh
    user(value);
    await refresh();
    return this;
  }

  // ^ Refreshes all Social Media Data ^ //
  refresh() async {
    // @ Validate Socials
    if (user.value.contact.socials.isNotEmpty) {
      // Add All Social Media to Service
      user.value.contact.socials.forEach((social) {
        // Create Item
        var item = SocialMediaItem.fromProviderData(social.provider);

        // Find Saved Oauth Tokens/Links
        if (_prefs.containsKey(item.key)) {
          item.valueFromKey(_prefs.getString(item.key));
        }

        // Add To List
        enabledSocialMedia().add(item);
      });
    } else {
      print("Empty Socials");
    }
  }

  // ^ Connect account to a Social Media Provider ^ //
  Future<dynamic> search(Contact_SocialTile_Provider provider,
      SearchFilter filter, String query) async {
    switch (provider) {
      case Contact_SocialTile_Provider.Facebook:
        break;
      case Contact_SocialTile_Provider.Instagram:
        break;
      case Contact_SocialTile_Provider.Medium:
        if (filter == SearchFilter.User) {
          var resp = await SocialAPI.getMediumFeed(query);
          if (resp.statusCode == 200) {
            // If the server did return a 200 OK response
            var feed = MediumFeedModel.fromJson(jsonDecode(resp.body));
            if (feed.status == "error") {
              // Snackbar Error
            } else if (feed.status == "ok") {
              return feed;
            }
          } else {
            // If the server did not return a 200 OK response,
            // then throw an exception.
            throw Exception('Failed to load album');
          }
        }
        break;
      case Contact_SocialTile_Provider.Spotify:
        break;
      case Contact_SocialTile_Provider.TikTok:
        break;
      case Contact_SocialTile_Provider.Twitter:
        break;
      case Contact_SocialTile_Provider.YouTube:
        break;
    }
    return true;
  }

  // ^ Connect account to a Social Media Provider ^ //
  Future<bool> connect(Contact_SocialTile_Provider provider) async {
    switch (provider) {
      case Contact_SocialTile_Provider.Facebook:
        break;
      case Contact_SocialTile_Provider.Instagram:
        break;
      case Contact_SocialTile_Provider.Medium:
        break;
      case Contact_SocialTile_Provider.Spotify:
        break;
      case Contact_SocialTile_Provider.TikTok:
        break;
      case Contact_SocialTile_Provider.Twitter:
        break;
      case Contact_SocialTile_Provider.YouTube:
        break;
    }
    return true;
  }
}

// ** Class that Calls Social Network APIs
class SocialAPI {
  static Future<http.Response> getMediumFeed(userID) {
    return http.get(
        'https://api.rss2json.com/v1/api.json?rss_url=https://medium.com/feed/@' +
            userID);
  }
}
