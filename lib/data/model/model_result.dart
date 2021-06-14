import 'package:photo_manager/photo_manager.dart';
import 'package:sonr_app/style.dart';

class SaveTransferEntry {
  // Properties
  final bool success;
  final String path;
  final String id;
  SaveTransferEntry(this.success, this.path, this.id);

  static Future<SaveTransferEntry> fromAssetEntity(SonrFile_Item meta, AssetEntity entity) async {
    bool success = await entity.exists;
    return SaveTransferEntry(success, meta.path, entity.id);
  }

  /// Constructer for Default Success Result
  factory SaveTransferEntry.success() {
    return SaveTransferEntry(true, "", "");
  }

  /// Constructer for Default Success Result
  factory SaveTransferEntry.fail() {
    return SaveTransferEntry(false, "", "");
  }
}

class SaveTransferResult {
  /// Reference to List of Save Results
  final List<SaveTransferEntry> results;
  SaveTransferResult(this.results);

  /// Constructer for Default Success Result
  factory SaveTransferResult.success() {
    return SaveTransferResult([SaveTransferEntry.success()]);
  }

  /// Constructer for Default Failed Result
  factory SaveTransferResult.fail() {
    return SaveTransferResult([SaveTransferEntry.fail()]);
  }

  /// Method checks if all Items were saved
  bool get isValid {
    bool valid = true;
    this.results.forEach((r) {
      if (!r.success) {
        valid = false;
      }
    });
    return valid;
  }

  /// Method Copys Asset ID's from Results to Sonr File
  SonrFile copyAssetIds(SonrFile file) {
    var idx = 0;
    for (SonrFile_Item i in file.items) {
      if (i.mime.isMedia && this.results[idx].path == i.path) {
        i.id = this.results[idx].id;
        idx += 1;
      }
    }
    return file;
  }
}
