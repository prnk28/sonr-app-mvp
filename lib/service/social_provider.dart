import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sonar_app/data/medium_model.dart';
import 'package:sonar_app/data/social_model.dart';
import 'package:sonar_app/theme/theme.dart';

// ** Handles SocialMedia ** //
class SocialMediaProvider extends GetConnect {
  // Reactive Properties
  final enabledSocialMedia = List<SocialMediaItem>().obs;

  Future<MediumModel> getMedium(String userID) async {
    /// @ Request with UserID
    var resp = await get(
        'https://api.rss2json.com/v1/api.json?rss_url=https://medium.com/feed/@' +
            userID);

    // @ Check Status Code
    if (resp.statusCode == 200) {
      // Initialize Model
      var feed = MediumModel.fromJson(jsonDecode(resp.body));

      // Return Model Save Auth+Link
      if (feed.status == "ok") {
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
}
