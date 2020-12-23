import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sonar_app/data/medium_model.dart';
import 'package:sonar_app/data/social_model.dart';

// ^ Fetches Medium feed by ID ^ //
Future<MediumFeedModel> fetchMediumFeedWithID(
    SocialMediaItem item, String userID) async {
  /// @ Request with UserID
  var resp = await http.get(
      'https://api.rss2json.com/v1/api.json?rss_url=https://medium.com/feed/@' +
          userID);

  // @ Check Status Code
  if (resp.statusCode == 200) {
    // Initialize Model
    var feed = MediumFeedModel.fromJson(jsonDecode(resp.body));

    // Return Model Save Auth+Link
    if (feed.status == "ok") {
      return feed;
    }
    // Display Error Snackbar
    else {
      return null;
    }
  }
  // @ Invalid Code
  else {
    return null;
  }
}

// ^ Fetches Medium feed by Item Data ^ //
Future<MediumFeedModel> fetchMediumFeedWithItem(SocialMediaItem item) async {
  // Initialize
  var resp = await http.get(item.value);

  // @ Check Status Code
  if (resp.statusCode == 200) {
    // Initialize Model
    var feed = MediumFeedModel.fromJson(jsonDecode(resp.body));

    // Return Model Save Auth+Link
    if (feed.status == "ok") {
      return feed;
    } else {
      return null;
    }
  }
  // @ Invalid Code
  else {
    return null;
  }
}
