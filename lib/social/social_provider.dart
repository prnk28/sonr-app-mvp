import 'package:http/http.dart';
import 'package:get/get.dart';
import 'package:sonar_app/social/medium_data.dart';
import 'package:sonar_app/theme/theme.dart';

// ** Handles SocialMedia ** //
const K_RSS_API = 'https://api.rss2json.com/v1/api.json?rss_url=';
const K_MEDIUM_FEED = 'https://medium.com/feed/@';

class SocialMediaProvider extends GetxService {
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
        _presentInvalid();
        return null;
      }
    }
    // @ Invalid Code
    else {
      _presentInvalid();
      return null;
    }
  }

  // ^ Presents Invalid Snackbar ^ //
  _presentInvalid({String type = "username"}) {
    Get.snackbar("Uh Oh!", "That $type was not found",
        snackStyle: SnackStyle.FLOATING,
        duration: Duration(milliseconds: 1250),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        icon: Icon(
          Icons.warning_outlined,
          color: Colors.white,
        ),
        colorText: Colors.white);
  }
}
