import 'package:photo_manager/photo_manager.dart';
import 'package:sonr_app/style.dart';

class RequestBuilder {
  static APIKeys get apiKeys => AppServices.apiKeys;
  static Device get device => DeviceService.device;
  static Contact get contact => ContactService.contact.value;
  static ConnectionRequest_InternetType get internetType => DeviceService.connectivity.value.toInternetType();

  /// Returns New Connection Request
  static Future<ConnectionRequest> get connection async {
    return ConnectionRequest(
      apiKeys: apiKeys,
      location: await DeviceService.location,
      contact: contact,
    );
  }

  /// Returns New Initialize Request
  static InitializeRequest get initialize {
    return InitializeRequest(
      apiKeys: apiKeys,
      device: DeviceService.device,
    );
  }

  /// Returns New Position Update Request
  static UpdateRequest get positionUpdate {
    return Request.newUpdatePosition(DeviceService.position.value);
  }
}

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
  /// Given payload contains SonrFile, all items get stored to disk.
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

extension SonrFileItemUtils on SonrFile_Item {
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
