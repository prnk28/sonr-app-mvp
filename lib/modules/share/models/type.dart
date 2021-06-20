import 'package:photo_manager/photo_manager.dart';
import 'package:sonr_app/style.dart';
import 'package:sonr_app/style/components/icon.dart';

enum ShareViewType {
  /// For Default State
  None,

  /// For when ShareView Presented from Home Screen.
  Popup,

  /// For when ShareView Presented from Transfer Screen
  Alert
}

enum ShareViewStatus { Default, Loading, Ready }

extension ShareViewStatusUtils on ShareViewStatus {
  /// Checks if ShareViewStatus is either Default or Loading
  bool get isNotReady => this == ShareViewStatus.Default || this == ShareViewStatus.Loading;

  /// Checks if ShareViewStatus is Ready
  bool get isReady => this == ShareViewStatus.Ready;
}

extension ShareViewTypeUtils on ShareViewType {
  /// Checks for Popup Type - Popup is for when in HomeScreen
  bool get isViewPopup => this == ShareViewType.Popup;

  /// Checks for Dialog Type - Dialog is for when in TransferScreen
  bool get isViewDialog => this == ShareViewType.Alert;
}

/// Row Button Size
const K_ROW_BUTTON_SIZE = 75.0;

/// Row Circle Size
const K_ROW_CIRCLE_SIZE = 95.0;

/// System Generated Albums
const SYSTEM_ALBUM_NAMES = ["panoramas", "videos", "favorites", "downloads"];

/// System Generated Albums
enum DefaultAlbum {
  None,
  Panoramas,
  Videos,
  Recent,
  Movies,
  Markup,
  Download,
  Screenshots,
  Favorites,
  Bursts,
  Slomo,
  Selfies,
  Portrait,
  LivePhotos,
}

extension DefaultAlbumUtils on DefaultAlbum {
  /// Returns IconData by Album
  IconData get iconData {
    switch (this) {
      case DefaultAlbum.Panoramas:
        return SonrIcons.Panorama;
      case DefaultAlbum.Videos:
        return SonrIcons.Video;
      case DefaultAlbum.Recent:
        return SonrIcons.Clock;
      case DefaultAlbum.Movies:
        return SonrIcons.Video;
      case DefaultAlbum.Markup:
        return SonrIcons.Pen;
      case DefaultAlbum.Download:
        return SonrIcons.Download;
      case DefaultAlbum.Screenshots:
        return SonrIcons.Screenshot;
      case DefaultAlbum.Favorites:
        return SonrIcons.Star;
      case DefaultAlbum.Bursts:
        return SonrIcons.Bolt;
      default:
        return SonrIcons.Album;
    }
  }

  /// Returns this Album Name
  String get name {
    switch (this) {
      case DefaultAlbum.Slomo:
        return "Slo-mo";
      case DefaultAlbum.Recent:
        return "Recents";
      case DefaultAlbum.LivePhotos:
        return "Live Photos";
      default:
        return this.value;
    }
  }

  /// Return Enum Value as String w/o Prefix
  String get value {
    return this.toString().substring(this.toString().indexOf('.') + 1);
  }

  /// ### (Static) buildInfolistOption:
  /// Method Builds InfoListOption Given AssetPathEntity and
  /// Function onPressed
  static InfolistOption buildInfolistOption({required Function onPressed, required AssetPathEntity entity}) {
    // Set Title
    String title = entity.name;
    if (DefaultAlbumUtils.isDefault(entity)) {
      title = DefaultAlbumUtils.toDefault(entity).name;
    }

    // Set IconData
    IconData iconData = SonrIcons.Album;
    if (DefaultAlbumUtils.isDefault(entity)) {
      iconData = DefaultAlbumUtils.toDefault(entity).iconData;
    }
    return InfolistOption(title, iconData, onPressed);
  }

  /// ### (Static) isDefault:
  /// Checks if AssetPathEntity is Default Album
  static bool isDefault(AssetPathEntity entity) => DefaultAlbum.values.any((v) => v.name == entity.name);

  /// ### (Static) isDefault:
  /// Checks if AssetPathEntity is Default Album
  static DefaultAlbum toDefault(AssetPathEntity entity) => DefaultAlbum.values.firstWhere(
        (v) => v.name == entity.name,
        orElse: () => DefaultAlbum.None,
      );
}
