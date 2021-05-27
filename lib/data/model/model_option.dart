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

/// Class Manages Pre Transfer Share Selection
class ShareItem {
  // * Variables
  // Properties
  final Payload payload;
  final Contact? contact;
  final SonrFile? file;
  final String? url;
  ThumbnailStatus thumbStatus = ThumbnailStatus.None;

  // Accessors
  bool get exists => this.payload != Payload.NONE;
  bool get isContact => this.exists && this.contact != null;
  bool get isFile => this.exists && file != null;
  bool get isURL => this.exists && url != null;

  // References
  AuthInvite _invite = AuthInvite();

  // * Constructers
  /// Default Constructer
  ShareItem(this.payload, {this.file, this.contact, this.url}) {
    if (this.exists) {
      _init();
    }
  }

  /// Blank Constructer
  factory ShareItem.blank() {
    return ShareItem(Payload.NONE);
  }

  /// Contact Constructer
  factory ShareItem.contact(Contact contact) {
    return ShareItem(Payload.CONTACT, contact: contact);
  }

  /// File Constructer
  factory ShareItem.file(SonrFile file) {
    return ShareItem(file.payload, file: file);
  }

  /// URL Constructer
  factory ShareItem.url(String url) {
    return ShareItem(Payload.URL, url: url);
  }

  // * Methods
  /// Returns Auth Invite for Share Item
  AuthInvite invite(Peer peer) => AuthInviteUtils.copyWithPeer(_invite, peer);

  /// Builds Invite from Payload
  Future<bool> _init() async {
    // Check for File
    if (this.payload.isTransfer && this.isFile) {
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
    else if (this.payload == Payload.URL && this.isURL) {
      this._invite.setUrl(url!);
      return true;
    }
    return false;
  }
}
