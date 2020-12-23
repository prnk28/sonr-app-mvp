import 'package:sonr_core/models/models.dart';

enum SocialRefType { Link, OAuth }
enum SearchFilter { User, Playlist, Post }

class SocialMediaItem {
  final Contact_SocialTile_Provider provider;
  final SocialRefType reference;
  String _oauthToken;
  String _link;
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
