import 'package:sonr_app/pages/home/views/contact/editor/editor_controller.dart';
import 'package:sonr_app/style/style.dart';

enum ContactOptions {
  Names,
  Phone,
  Addresses,
  Gender,
  // Music
  // Social
  // Emails
  // Websites
  // Payments
}

extension ContactOptionUtils on ContactOptions {
  IconData get iconData {
    switch (this) {
      case ContactOptions.Names:
        return SonrIcons.Pen;
      case ContactOptions.Phone:
        return SonrIcons.Call;
      case ContactOptions.Addresses:
        return SonrIcons.Location;
      case ContactOptions.Gender:
        return SonrIcons.User;
    }
  }

  String get name {
    return this.toString().substring(this.toString().indexOf('.') + 1);
  }

  EditorFieldStatus get editorStatus {
    switch (this) {
      case ContactOptions.Names:
        return EditorFieldStatus.FieldName;
      case ContactOptions.Phone:
        return EditorFieldStatus.FieldPhone;
      case ContactOptions.Addresses:
        return EditorFieldStatus.FieldAddresses;
      case ContactOptions.Gender:
        return EditorFieldStatus.FieldGender;
    }
  }
}

enum ShareItemCount { None, Single, Multiple }

/// Class Manages Pre Transfer Share Selection
class ShareItem {
  // * Variables
  // Properties
  final ShareItemCount count;
  final Payload payload;
  final Contact? contact;
  final SonrFile? file;
  final String? url;
  ThumbnailStatus thumbStatus = ThumbnailStatus.None;

  // Accessors
  bool get exists => this.payload != Payload.NONE && hasData;
  bool get hasData => this.contact != null || file != null || url != null;
  bool get isContact => this.exists && this.payload.isContact;
  bool get isFlatContact => this.exists && this.payload.isFlatContact;
  bool get isMedia => this.exists && this.payload.isMedia;
  bool get isTransfer => this.exists && this.payload.isTransfer;
  bool get isUrl => this.exists && this.payload.isUrl;
  bool get isEmptyItem => this.count == ShareItemCount.None;
  bool get isSingleItem => this.count == ShareItemCount.Single;
  bool get isMultiItems => this.count == ShareItemCount.Multiple;

  // References
  AuthInvite _invite = AuthInvite();

  // * Constructers
  /// Default Constructer
  ShareItem(this.payload, this.count, {this.file, this.contact, this.url});

  /// Blank Constructer
  factory ShareItem.blank() {
    return ShareItem(Payload.NONE, _countfromInt(0));
  }

  /// Contact Constructer
  static Future<ShareItem> fromContact(Contact contact) async {
    var i = ShareItem(Payload.CONTACT, _countfromInt(1), contact: contact);
    await i._init();
    return i;
  }

  /// File Constructer
  static Future<ShareItem> fromFile(SonrFile file) async {
    var i = ShareItem(file.payload, _countfromInt(file.count), file: file);
    await i._init();
    return i;
  }

  /// URL Constructer
  static Future<ShareItem> fromUrl(String url) async {
    var i = ShareItem(Payload.URL, _countfromInt(1), url: url);
    await i._init();
    return i;
  }

  // * Methods
  /// Returns Auth Invite for Share Item
  AuthInvite invite(Peer peer) => AuthInviteUtils.copyWithPeer(_invite, peer);

  /// Builds Invite from Payload
  Future<bool> _init() async {
    // Check for File
    if (this.payload.isTransfer && this.isTransfer) {
      file!.update();
      this._invite.setFile(file!);

      // Check for Media
      if (this.payload == Payload.MEDIA) {
        // Set File Item
        this.thumbStatus = ThumbnailStatus.Loading;
        await this.file!.setThumbnail();

        // Check Result
        if (this.file!.single.hasThumbnail()) {
          this.thumbStatus = ThumbnailStatus.Complete;
        } else {
          this.thumbStatus = ThumbnailStatus.None;
        }
      }
      return true;
    }

    // Check for Contact
    else if (this.payload == Payload.CONTACT && this.isContact) {
      this._invite.setContact(contact!);
      return true;
    }

    // Check for URL
    else if (this.payload == Payload.URL && this.isUrl) {
      this._invite.setUrl(url!);
      return true;
    }
    return false;
  }

  // Helper: Returns Enum Value from Item Count
  static ShareItemCount _countfromInt(int x) {
    if (x > 1) {
      return ShareItemCount.Multiple;
    } else if (x == 1) {
      return ShareItemCount.Single;
    } else {
      return ShareItemCount.None;
    }
  }
}
