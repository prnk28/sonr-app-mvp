import 'package:sonr_core/models/models.dart';

enum SocialRefType { Link, OAuth }
enum SearchFilter { User, Playlist, Post }

class SocialMediaItem {
  final Contact_SocialTile_Provider provider;
  final SocialRefType reference;
  String _oauthToken;
  String _link;
  String get key => provider.toString() + "_auth";
  String get value => _authValueForRefType();

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

  _authValueForRefType() {
    if (this.reference == SocialRefType.Link) {
      return _link;
    } else {
      return _oauthToken;
    }
  }
}
