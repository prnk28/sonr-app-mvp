// @ Helper Enum for Video/Image Orientation
import 'package:file_picker/file_picker.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:sonr_plugin/sonr_plugin.dart';

enum MediaOrientation { Portrait, Landscape }

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
    var file = SonrFile(payload: this.isSinglePick ? payload : Payload.FILES, files: this._toSonrFileItems());
    file.update();
    return file;
  }

  /// Converts Picker Items into SonrFile_Metadata Items
  List<SonrFile_Metadata> _toSonrFileItems() {
    var items = <SonrFile_Metadata>[];
    this.files.forEach((f) {
      items.add(MetadataUtils.newItem(path: f.path!));
    });
    return items;
  }
}

extension SharedMediaFileUtils on List<SharedMediaFile> {
  /// Checks if only one SharedMediaFile is present
  bool get isSingleItem => this.length == 1;

  /// Returns List of SharedMediaFile as SonrFile
  SonrFile toSonrFile() {
    return SonrFile(payload: this.isSingleItem ? Payload.MEDIA : Payload.FILES, files: this._toSonrFileItems());
  }

  /// Converts Picker Items into SonrFile_Metadata Items
  List<SonrFile_Metadata> _toSonrFileItems() {
    var items = <SonrFile_Metadata>[];
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
