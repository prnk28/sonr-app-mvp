import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:http/http.dart';
import 'package:get/get.dart';
import 'package:sonar_app/service/device_service.dart';
import 'package:sonar_app/social/medium_data.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';

// ** Handles SocialMedia ** //
const K_RSS_API = 'https://api.rss2json.com/v1/api.json?rss_url=';
const K_MEDIUM_FEED = 'https://medium.com/feed/@';

class SocialMediaProvider extends GetxService {
  Map _apiKeys;

  init() async {
    _apiKeys = await Get.find<DeviceService>().getKeys();
  }

  // ^ Authenticates Facebook ^ //
  linkFacebook() {}

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
        // Get Session Result
        var session = result.session;

        // Save Auth to Data
        Get.find<DeviceService>().saveAuth(Contact_SocialTile_Provider.Twitter,
            [session.token, session.secret]);

        // Present Success
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

  // ^ Gets Medium Data as RSS Feed then Converts to JSON ^ //
  Future<MediumData> getMedium(String userID) async {
    //  Request with UserID
    var resp = await get(K_RSS_API + K_MEDIUM_FEED + userID);

    //  Valid Status
    if (resp.statusCode == 200) {
      var feed = MediumData.fromResponse(resp.body);
      if (feed.status == "ok") {
        return feed;
      }

      // Display Error Snackbar
      else {
        SonrSnack.invalid("User not found");
        return null;
      }
    }
    // @ Invalid Code
    else {
      SonrSnack.error("Something went wrong");
      return null;
    }
  }
}
