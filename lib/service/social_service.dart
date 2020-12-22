import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonar_app/data/permission_model.dart';

import 'package:sonar_app/data/social_model.dart';
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
  Future<bool> search(Contact_SocialTile_Provider provider, SearchFilter filter,
      String query) async {
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
