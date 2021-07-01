import 'package:photo_manager/photo_manager.dart';
import 'package:sonr_app/style/style.dart';

class RequestBuilder {
  // Request References
  static APIKeys get apiKeys => AppServices.apiKeys;
  static Device get device => DeviceService.device;
  static Contact get contact => ContactService.contact.value;
  static ConnectionRequest_InternetType get internetType => DeviceService.connectivity.value.toInternetType();
  static ConnectionRequest_UserStatus get userStatus => ContactService.status.value.toConnectionStatus();

  /// Define Connection Request Options
  static ConnectionRequest_HostOptions get _hostOpts => ConnectionRequest_HostOptions(mdnsDiscovery: true);
  static ConnectionRequest_PubsubOptions get _pubsubOpts => ConnectionRequest_PubsubOptions(relay: true);
  static ConnectionRequest_TextileOptions get _textileOpts => ConnectionRequest_TextileOptions(enabled: true, mailbox: DeviceService.isIOS);

  /// Returns New Connection Request
  static Future<ConnectionRequest> get connection async {
    return ConnectionRequest(
      apiKeys: apiKeys,
      location: await DeviceService.location,
      contact: contact,
      type: internetType,
      status: userStatus,
      textileOptions: _textileOpts,
      hostOptions: _hostOpts,
      pubsubOptions: _pubsubOpts,
    );
  }

  /// Returns New Initialize Request
  static InitializeRequest get initialize {
    return InitializeRequest(
      apiKeys: apiKeys,
      device: DeviceService.device,
    );
  }

  /// Returns New Contact Update Request
  static UpdateRequest get updateContact {
    return API.newUpdateContact(contact);
  }

  /// Returns New Position Update Request
  static UpdateRequest get updatePosition {
    return API.newUpdatePosition(DeviceService.position.value);
  }

  /// Returns New Properties Update Request
  static UpdateRequest get updateProperties {
    return API.newUpdateProperties(Preferences.properties.value);
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
        if (NodeService.isReady) {
          NodeService.instance.respond(this.newDeclineResponse());
        }
        AppRoute.closeSheet();
      });
    }
  }
}

extension InviteResponseDisplayUtils on InviteResponse {
  /// Display Invite Request as a Bottom Sheet
  void show() {
    if (this.type == InviteResponse_Type.Contact) {
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
