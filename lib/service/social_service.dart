import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonar_app/data/medium_model.dart';
import 'package:sonar_app/data/social_model.dart';
import 'package:sonar_app/data/user_model.dart';
import 'package:sonar_app/repository/medium_api.dart';
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

  // ^ Retreives Model Item from Tile ^ //
  SocialMediaItem getItem(Contact_SocialTile tile) {
    // Find Saved Oauth Tokens/Links
    return enabledSocialMedia
        .firstWhere((smi) => smi.provider == tile.provider);
  }

  // ^ Retreives Model Item from Tile ^ //
  fetchData(SocialMediaItem item) {
    if (item.provider == Contact_SocialTile_Provider.Medium) {
      var data = fetchMediumFeedWithItem(item);
      if (data != null) {
        return data;
      } else {
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
      }
    }
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
        enabledSocialMedia.refresh();
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
          // API Call
          var resp = await fetchMediumFeedWithID(item, query);

          // Check Response
          if (resp != null) {
            // Add Item To Preferences
            item.value = query;
            _prefs.setString(item.key, item.value);
            refresh();
            return resp;
          } else {
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
}
