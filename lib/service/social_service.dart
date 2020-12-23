import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonar_app/data/medium_model.dart';
import 'package:sonar_app/data/social_model.dart';
import 'package:sonar_app/data/user_model.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonar_app/theme/theme.dart';
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
  Future<dynamic> connect(Contact_SocialTile_Provider provider,
      SearchFilter filter, String query) async {
    // Create Item
    var item = SocialMediaItem.fromProviderData(provider);

    // Connect By Provider
    switch (provider) {
      case Contact_SocialTile_Provider.Facebook:
        break;
      case Contact_SocialTile_Provider.Instagram:
        break;

      // @ Retreive Medium RSS Feed as JSON
      case Contact_SocialTile_Provider.Medium:
        if (filter == SearchFilter.User) {
          var resp = await _fetchMediumFeed(item, query);
          if (resp != null) {
            return resp;
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

  // ^ Fetches Medium feed by ID ^ //
  Future<MediumFeedModel> _fetchMediumFeed(
      SocialMediaItem item, String userID) async {
    // @ Request
    var resp = await http.get(
        'https://api.rss2json.com/v1/api.json?rss_url=https://medium.com/feed/@' +
            userID);

    // @ Check Status Code
    if (resp.statusCode == 200) {
      // Initialize Model
      var feed = MediumFeedModel.fromJson(jsonDecode(resp.body));

      // Return Model Save Auth+Link
      if (feed.status == "ok") {
        item.value = userID;
        _prefs.setString(item.key, item.value);
        return feed;
      }
      // Display Error Snackbar
      else {
        Get.snackbar("Uh Oh!", "That username was not found",
            snackStyle: SnackStyle.FLOATING,
            duration: Duration(milliseconds: 1250),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            icon: Icon(
              Icons.warning_outlined,
              color: Colors.white,
            ),
            colorText: Colors.white);

        return null;
      }
    }
    // @ Invalid Code
    else {
      return null;
    }
  }
}
