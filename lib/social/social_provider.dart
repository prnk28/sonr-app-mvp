import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:http/http.dart';
import 'package:get/get.dart';
import 'package:sonar_app/social/medium_data.dart';
import 'package:sonar_app/theme/theme.dart';

// ** Handles SocialMedia ** //
const K_RSS_API = 'https://api.rss2json.com/v1/api.json?rss_url=';
const K_MEDIUM_FEED = 'https://medium.com/feed/@';

class SocialMediaProvider extends GetxService {
  // ^ Authenticates Facebook ^ //
  linkFacebook() {}

  // ^ Authenticates Twitter ^ //
  linkTwitter() async {
    // Set Vars
    var twitterLogin = new TwitterLogin(
      consumerKey: 'BXIzMYRhbPKXHplTPhPZa9RLB',
      consumerSecret: 'eR1xkfFM9zReFzR3yxQN1nUBxZaiYS9eNTNFMtBiFaV6Mjej4M',
    );

    // Authorize User
    final TwitterLoginResult result = await twitterLogin.authorize();

    // Check Status
    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        var session = result.session;
        // _sendTokenAndSecretToServer(session.token, session.secret);

        var twitterAuth = [session.token, session.secret];
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
