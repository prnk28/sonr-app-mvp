import 'package:sonr_core/models/models.dart';

enum SocialRefType { Link, OAuth }
enum SearchFilter { User, Playlist, Post }

class SocialMediaItem {
  // @ Properties
  final Contact_SocialTile_Provider provider;
  final SocialRefType reference;
  String _oauthToken;
  String _link;

  // @ For TextField
  String get hint => _getHintText();
  String get label => _getLabelText();
  String get infoText => _getInfoText();

  // @ For Shared Preferances
  String get key => provider.toString() + "_auth";
  String get value => _getAuthValueForRefType();
  set value(value) => _setAuthValueForRefType(value);

  SocialMediaItem(this.provider, this.reference);

  factory SocialMediaItem.fromProviderData(Contact_SocialTile_Provider prov) {
    // Link Item
    if (prov == Contact_SocialTile_Provider.Medium ||
        prov == Contact_SocialTile_Provider.Spotify ||
        prov == Contact_SocialTile_Provider.YouTube) {
      return SocialMediaItem(prov, SocialRefType.Link);
    }
    // OAuth Item
    else {
      return SocialMediaItem(prov, SocialRefType.OAuth);
    }
  }

  valueFromKey(String data) {
    if (this.reference == SocialRefType.Link) {
      _link = data;
    } else {
      _oauthToken = data;
    }
  }

  _getAuthValueForRefType() {
    if (this.reference == SocialRefType.Link) {
      return _link;
    } else {
      return _oauthToken;
    }
  }

  _getInfoText() {
    // Link Item
    if (provider == Contact_SocialTile_Provider.Medium ||
        provider == Contact_SocialTile_Provider.Spotify ||
        provider == Contact_SocialTile_Provider.YouTube) {
      return "Link your ${provider.toString()}";
    }
    // OAuth Item
    else {
      return "Connect with ${provider.toString()}";
    }
  }

  _getHintText() {
    switch (provider) {
      case Contact_SocialTile_Provider.Facebook:
        return "Insert facebook username ";
      case Contact_SocialTile_Provider.Instagram:
        return "Insert instagram username ";
      case Contact_SocialTile_Provider.Medium:
        return "@prnk28 (Incredible Posts BTW) ";
      case Contact_SocialTile_Provider.Spotify:
        return "Any public playlist or profile ";
      case Contact_SocialTile_Provider.TikTok:
        return "Insert TikTok username ";
      case Contact_SocialTile_Provider.Twitter:
        return "Insert Twitter username ";
      case Contact_SocialTile_Provider.YouTube:
        return "Insert channel name ";
      default:
    }
  }

  _getLabelText() {
    switch (provider) {
      case Contact_SocialTile_Provider.Facebook:
        return "Profile";
      case Contact_SocialTile_Provider.Instagram:
        return "Profile";
      case Contact_SocialTile_Provider.Medium:
        return "Account Username";
      case Contact_SocialTile_Provider.Spotify:
        return "Account Username";
      case Contact_SocialTile_Provider.TikTok:
        return "Account Username";
      case Contact_SocialTile_Provider.Twitter:
        return "Twitter Handle";
      case Contact_SocialTile_Provider.YouTube:
        return "YouTube Channel";
      default:
    }
  }

  _setAuthValueForRefType(String value) {
    if (this.reference == SocialRefType.Link) {
      _link = _linkFromValueAndProvider(value);
    } else {
      _oauthToken = value;
    }
  }

  _linkFromValueAndProvider(String value) {
    switch (provider) {
      case Contact_SocialTile_Provider.Medium:
        return 'https://api.rss2json.com/v1/api.json?rss_url=https://medium.com/feed/@' +
            value;
        break;
      case Contact_SocialTile_Provider.Spotify:
        break;
      case Contact_SocialTile_Provider.Twitter:
        break;
      case Contact_SocialTile_Provider.YouTube:
        break;
      default:
    }
  }
}
