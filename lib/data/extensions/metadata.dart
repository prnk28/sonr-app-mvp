// @ Helper Enum for Video/Image Orientation
import 'package:file_picker/file_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart';
import '../data.dart';

enum MediaOrientation { Portrait, Landscape }

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
    return this.owner.firstName.contains(q) || this.owner.lastName.contains(q) || this.owner.sname.contains(q);
  }

  /// Checks if Provided Query Matches Payload
  bool matchesPayload(String q) {
    return this.payload.toString().contains(q);
  }
}

extension MediaOrientationUtils on MediaOrientation {
  double get aspectRatio {
    switch (this) {
      case MediaOrientation.Landscape:
        return 16 / 9;
      default:
        return 9 / 16;
    }
  }

  double get defaultHeight {
    switch (this) {
      case MediaOrientation.Landscape:
        return 180;
      default:
        return 320;
    }
  }

  double get defaultWidth {
    switch (this) {
      case MediaOrientation.Landscape:
        return 320;
      default:
        return 180;
    }
  }
}

extension FilePickerResultUtils on FilePickerResult {
  /// Converts Picker Result into SonrFile
  SonrFile toSonrFile({required Payload payload}) {
    var file = SonrFile(payload: this.isSinglePick ? payload : Payload.FILES, items: this._toSonrFileItems());
    file.update();
    return file;
  }

  /// Converts Picker Items into SonrFile_Item Items
  List<SonrFile_Item> _toSonrFileItems() {
    var items = <SonrFile_Item>[];
    this.paths.forEach((p) {
      if (p != null) {
        items.add(MetadataUtils.newItem(path: p));
      }
    });
    return items;
  }
}

extension SharedMediaFileUtils on List<SharedMediaFile> {
  /// Checks if only one SharedMediaFile is present
  bool get isSingleItem => this.length == 1;

  /// Returns List of SharedMediaFile as SonrFile
  SonrFile toSonrFile() {
    return SonrFile(payload: this.isSingleItem ? Payload.MEDIA : Payload.FILES, items: this._toSonrFileItems());
  }

  /// Converts Picker Items into SonrFile_Item Items
  List<SonrFile_Item> _toSonrFileItems() {
    var items = <SonrFile_Item>[];
    this.forEach((f) {
      items.add(MetadataUtils.newItem(
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

  /// Returns List of AssetEntity as SonrFile
  Future<SonrFile> toSonrFile() async {
    var items = await this._toSonrFileItems();
    var file = SonrFile(payload: this.isSingleItem ? Payload.MEDIA : Payload.FILES, items: items);
    file.update();
    return file;
  }

  /// Converts Asset Entity Items into SonrFile_Item Items
  Future<List<SonrFile_Item>> _toSonrFileItems() async {
    var items = <SonrFile_Item>[];
    for (var t in this) {
      AssetEntity f = t.item1;
      Uint8List thumb = t.item2;
      // Get Data
      var file = await f.loadFile();

      // Add File Item
      if (file != null) {
        items.add(MetadataUtils.newItem(path: file.path, thumbBuffer: thumb.toList()));
      }
    }

    return items;
  }
}

extension AssetEntityUtils on AssetEntity {
  Widget icon() {
    switch (this.type) {
      case AssetType.other:
        return SonrIcons.Unknown.gradient(size: 46);
      case AssetType.image:
        return SonrIcons.Image.gradient(size: 46);
      case AssetType.video:
        return SonrIcons.Video.gradient(size: 46);
      case AssetType.audio:
        return SonrIcons.Audio.gradient(size: 46);
    }
  }
}
