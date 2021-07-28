import 'dart:io';

import 'package:photo_manager/photo_manager.dart';
import 'package:sonr_app/style/style.dart';

extension TransferFileUtils on Transfer {
  /// ### Adds Card to Card Database
  Future<void> addCard({ActivityType activityType = ActivityType.Received}) async {
    // Save to DB
    await CardService.addCard(this, activityType);
  }

  /// ### Open Given File from Disk Path
  Future<void> open() async {
    await OpenFile.open(this.file.single.path);
  }

  /// ### Saves Transfer to Disk
  /// Given payload contains SFile, all items get stored to disk.
  Future<bool> save() async {
    if (DeviceService.isMobile) {
      // Set Count
      int mediaCount = 0;
      bool result = true;

      // Iterate Files
      this.file.items.forEach((i) async {
        if (i.mime.isPhotoVideo) {
          mediaCount += 1;
          result = await i.saveMedia();
        }
      });

      // Get Title
      var title = mediaCount == this.file.count ? "Media" : "Transfer";
      if (this.file.isSingle) {
        title = this.file.single.mime.isImage ? "Photo" : "Video";
      }

      // Check Result
      if (result) {
        AppRoute.snack(SnackArgs.success("Succesfully Received $title!"));
      } else {
        AppRoute.snack(SnackArgs.error("Unable to save $title to your Gallery"));
      }
      return result;
    } else {
      await this.open();
    }
    return false;
  }
}

extension SFileItemHandler on SFile_Item {
  /// ### Load IO File from Metadata
  Future<File> loadFile() async {
    if (DeviceService.isMobile) {
      var asset = await AssetEntity.fromId(this.id);
      if (asset != null) {
        var file = await asset.file;
        if (file != null) {
          return file;
        }
      }
      return this.file;
    } else {
      return File("");
    }
  }

  /// ### Open Given File from Disk Path
  Future<void> open() async {
    await OpenFile.open(this.path);
  }

  /// ### Saves Media to Disk
  /// Save Persistently to Gallery if its a Media File.
  Future<bool> saveMedia() async {
    // Initialize
    AssetEntity? asset;

    // Get Data from Media
    if (this.mime.isImage && await Permissions.Gallery.isGranted) {
      asset = await PhotoManager.editor.saveImageWithPath(this.path);

      // Visualize Result
      if (asset != null) {
        this.id = asset.id;
        return true;
      }
    }

    // Save Video to Gallery
    else if (this.mime.isVideo && await Permissions.Gallery.isGranted) {
      // Set Video File
      asset = await PhotoManager.editor.saveVideo(this.file);

      // Visualize Result
      if (asset != null) {
        this.id = asset.id;
        return true;
      }
    }
    return false;
  }
}

extension InviteRequestDisplayUtils on InviteRequest {
  /// Display Invite Request as a Bottom Sheet
  void show() {
    // Place Controller
    if (this.payload == Payload.CONTACT) {
      AppRoute.popup(ContactAuthView(false, invite: this), dismissible: false);
    } else {
      AppRoute.sheet(InviteRequestSheet(invite: this), key: ValueKey(this), dismissible: true, onDismissed: (direction) {
        NodeService.instance.respond(this.newDeclineResponse());
        AppRoute.close();
      });
    }
  }
}

extension InviteResponseDisplayUtils on InviteResponse {
  /// Display Invite Request as a Bottom Sheet
  void show() {
    if (this.payload == Payload.CONTACT) {
      // Open Sheet
      AppRoute.popup(
        Container(
          child: ContactAuthView(true, reply: this),
        ),
        dismissible: false,
      );
    }
  }
}

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
