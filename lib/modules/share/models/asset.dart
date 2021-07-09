// @ Helper Enum for Video/Image Orientation
import 'package:file_picker/file_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart';

extension TransferCardUtils on TransferCard {
  /// Checks if Provided Query Matches Date of Transfer
  bool matchesDate(String q) {
    // Retreive DateTime Data
    var receivedDay = this.received.day.toString();

    // Check Query
    return receivedDay.contains(q);
  }

  /// Checks if Provided Query Matches Owner Name
  bool matchesName(String q) {
    return this.owner.firstName.contains(q) || this.owner.lastName.contains(q) || this.owner.sName.contains(q);
  }

  /// Checks if Provided Query Matches Payload
  bool matchesPayload(String q) {
    return this.payload.toString().contains(q);
  }
}

extension FilePickerResultUtils on FilePickerResult {
  /// Converts Picker Result into SFile
  SFile toSFile({required Payload payload}) {
    var file = SFile(payload: this.isSinglePick ? payload : Payload.FILES, items: this._toSFileItems());
    file.update();
    return file;
  }

  /// Converts Picker Items into SFile_Item Items
  List<SFile_Item> _toSFileItems() {
    var items = <SFile_Item>[];
    this.paths.forEach((p) {
      if (p != null) {
        items.add(SFileItemUtil.newItem(path: p));
      }
    });
    return items;
  }
}

extension SharedMediaFileUtils on List<SharedMediaFile> {
  /// Checks if only one SharedMediaFile is present
  bool get isSingleItem => this.length == 1;

  /// Returns List of SharedMediaFile as SFile
  SFile toSFile() {
    return SFile(payload: this.isSingleItem ? Payload.MEDIA : Payload.FILES, items: this._toSFileItems());
  }

  /// Converts Picker Items into SFile_Item Items
  List<SFile_Item> _toSFileItems() {
    var items = <SFile_Item>[];
    this.forEach((f) {
      items.add(SFileItemUtil.newItem(
        path: f.path,
        duration: f.duration,
        thumbPath: f.thumbnail,
      ));
    });
    return items;
  }
}

extension AssetEntityListUtils on List<Tuple<AssetEntity, Uint8List>> {
  /// Checks if only one AssetEntity is present
  bool get isSingleItem => this.length == 1;

  /// Returns List of AssetEntity as SFile
  Future<SFile> toSFile() async {
    var items = await this._toSFileItems();
    var file = SFile(
      payload: this.isSingleItem ? Payload.MEDIA : Payload.ALBUM,
      items: items,
      count: items.length,
    );
    file.update();
    return file;
  }

  /// Converts Asset Entity Items into SFile_Item Items
  Future<List<SFile_Item>> _toSFileItems() async {
    var items = <SFile_Item>[];
    for (var t in this) {
      AssetEntity f = t.item1;
      Uint8List thumb = t.item2;
      // Get Data
      var file = await f.loadFile();

      // Add File Item
      if (file != null) {
        items.add(SFileItemUtil.newItem(path: file.path, thumbBuffer: thumb.toList()));
      }
    }

    return items;
  }
}

extension AssetEntityUtils on AssetEntity {
  Widget icon() {
    switch (this.type) {
      case AssetType.other:
        return SimpleIcons.Unknown.gradient(size: 46);
      case AssetType.image:
        return SimpleIcons.Image.gradient(size: 46);
      case AssetType.video:
        return SimpleIcons.Video.gradient(size: 46);
      case AssetType.audio:
        return SimpleIcons.Audio.gradient(size: 46);
    }
  }
}

extension AssetPathEntityUtils on AssetPathEntity {
  String get name {
    if (this.isAll) {
      return "All";
    } else if (this.name.toLowerCase() == "recent") {
      return "Recents";
    } else {
      return this.name;
    }
  }
}

extension AssetPathEntityListUtils on List<AssetPathEntity> {
  Future<AssetPathAlbum?> allAlbum() async {
    if (this.any((e) => e.isAll)) {
      var entity = this.firstWhere((e) => e.isAll);
      var index = this.indexOf(entity);
      return await AssetPathAlbum.init(index, entity);
    } else {
      return null;
    }
  }

  Future<List<AssetPathAlbum>> systemAlbums() async {
    /// Get Albums
    final albums = this.where((e) => (e.name.isAny(SYSTEM_ALBUM_NAMES))).toList();

    // Return Asset Path Album
    final list = List<AssetPathAlbum>.generate(albums.length, (index) => AssetPathAlbum(index, albums[index]));
    list.forEach((element) async => await element.initialize());
    return list;
  }
}

class AssetPathAlbum {
  final int index;
  final AssetPathEntity entity;
  late List<AssetEntity> assets;

  bool get isAll => entity.isAll;
  bool get isNotAll => !isAll;
  int get length => assets.length;
  String get name => entity.name;

  AssetPathAlbum(this.index, this.entity);

  static Future<AssetPathAlbum> init(int index, AssetPathEntity entity) async {
    var album = AssetPathAlbum(index, entity);
    album.assets = await entity.assetList;
    return album;
  }

  factory AssetPathAlbum.blank() {
    return AssetPathAlbum(-1, AssetPathEntity());
  }

  Future<void> initialize() async {
    this.assets = await entity.assetList;
  }

  bool isIndex(int i) {
    return index == i;
  }

  AssetEntity entityAtIndex(int i) {
    return this.assets[i];
  }

  double get offsetX => this.name.size(DisplayTextStyle.Subheading, fontSize: 20).width;
}
