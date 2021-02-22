import 'constant_data.dart';
import 'package:sonr_core/sonr_core.dart';

// ************************************** //
// ** Class For Username Query Results ** //
// ************************************** //
class QueryUsernameResult {
  // Properties
  final String query;
  final Contact_SocialTile_Provider provider;
  final bool isPrivate;

  // Setter References
  MediumModel _medium;
  TwitterUserModel _twitter;
  YoutubeModel _youtube;

  // ** Constructer ** //
  QueryUsernameResult(this.query, this.provider, this.isPrivate, dynamic data) {
    switch (provider) {
      // case Contact_SocialTile_Provider.Facebook:
      //   break;
      // case Contact_SocialTile_Provider.Github:
      //   break;
      // case Contact_SocialTile_Provider.Instagram:
      //   break;
      case Contact_SocialTile_Provider.Medium:
        _medium = data;
        break;
      // case Contact_SocialTile_Provider.Snapchat:
      //   break;
      // case Contact_SocialTile_Provider.TikTok:
      //   break;
      case Contact_SocialTile_Provider.Twitter:
        _twitter = data;
        break;
      case Contact_SocialTile_Provider.YouTube:
        _youtube = data;
        break;
    }
  }
  // ^ GETTER: Returns Result of Provider - (Username, UserLink, Provider, IsPrivate)  ^ //
  dynamic get resultData {
    switch (provider) {
      // case Contact_SocialTile_Provider.Facebook:
      //   break;
      // case Contact_SocialTile_Provider.Github:
      //   break;
      // case Contact_SocialTile_Provider.Instagram:
      //   break;
      case Contact_SocialTile_Provider.Medium:
        return _medium;
        break;
      // case Contact_SocialTile_Provider.Snapchat:
      //   break;
      // case Contact_SocialTile_Provider.TikTok:
      //   break;
      case Contact_SocialTile_Provider.Twitter:
        return _twitter;
        break;
      case Contact_SocialTile_Provider.YouTube:
        return _youtube;
        break;
      default:
        break;
    }
    return null;
  }

  // ^ GETTER: Returns User - (Username, UserLink, Provider, IsPrivate) ^ //
  Quadruple<String, String, Contact_SocialTile_Provider, bool> get userData {
    switch (provider) {
      // case Contact_SocialTile_Provider.Facebook:
      //   break;
      // case Contact_SocialTile_Provider.Github:
      //   break;
      // case Contact_SocialTile_Provider.Instagram:
      //   break;
      case Contact_SocialTile_Provider.Medium:
        return Quadruple(query, "https://medium.com/@$query", provider, isPrivate);
        break;
      // case Contact_SocialTile_Provider.Snapchat:
      //   break;
      // case Contact_SocialTile_Provider.TikTok:
      //   break;
      case Contact_SocialTile_Provider.Twitter:
        return Quadruple(query, "https://twitter.com/$query", provider, isPrivate);
        break;
      case Contact_SocialTile_Provider.YouTube:
        return Quadruple(query, "", provider, isPrivate);
        break;
      default:
        break;
    }
    return null;
  }

  // ^ GETTER: Returns If Data is Valid ^ //
  bool get isValid {
    switch (provider) {
      // case Contact_SocialTile_Provider.Facebook:
      //   break;
      // case Contact_SocialTile_Provider.Github:
      //   break;
      // case Contact_SocialTile_Provider.Instagram:
      //   break;
      case Contact_SocialTile_Provider.Medium:
        return _medium.status == "ok";
        break;
      // case Contact_SocialTile_Provider.Snapchat:
      //   break;
      // case Contact_SocialTile_Provider.TikTok:
      //   break;
      case Contact_SocialTile_Provider.Twitter:
        return _twitter.errors == null;
        break;
      case Contact_SocialTile_Provider.YouTube:
        return _youtube.items.isNotEmpty;
        break;
      default:
        break;
    }
    return null;
  }
}
