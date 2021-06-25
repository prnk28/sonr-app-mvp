import 'package:sonr_app/pages/details/details.dart';
import 'dart:io';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_app/data/data.dart';

// ** ─── Details Arguments ────────────────────────────────────────────────────────

enum DetailPageType {
  Contact,
  File,
  Media,
  Url,
}

class DetailPageArgs {
  final DetailPageType type;
  final SonrFile? file;
  final SonrFile_Item? mediaItem;
  final File? mediaItemFile;
  final Contact? contact;
  final URLLink? urlLink;

  DetailPageArgs(
    this.type, {
    this.file,
    this.mediaItem,
    this.mediaItemFile,
    this.contact,
    this.urlLink,
  });

  factory DetailPageArgs.contact(Contact contact) => DetailPageArgs(
        DetailPageType.Contact,
        contact: contact,
      );

  factory DetailPageArgs.file(SonrFile file) => DetailPageArgs(
        DetailPageType.File,
        file: file,
      );

  factory DetailPageArgs.media(SonrFile_Item item, File? file) => DetailPageArgs(
        DetailPageType.Media,
        mediaItem: item,
        mediaItemFile: file,
      );

  factory DetailPageArgs.url(URLLink link) => DetailPageArgs(
        DetailPageType.Url,
        urlLink: link,
      );

  /// Return Body for Arguments
  Widget body() {
    switch (this.type) {
      case DetailPageType.Contact:
        return DetailContactView(contact: this.contact!);
      case DetailPageType.File:
        return DetailFileView(file: this.file!);
      case DetailPageType.Media:
        return DetailMediaView(item: this.mediaItem!, file: this.mediaItemFile);
      case DetailPageType.Url:
        return DetailUrlView(urlLink: this.urlLink!);
    }
  }

  /// Return Title for this Page
  String get title => this.type.toString().substring(this.type.toString().indexOf('.'));
}

enum ErrorPageType { EmptyContacts, EmptyFiles, EmptyLinks, EmptyMedia, PermLocation, PermMedia, NoNetwork }

extension ErrorPageTypeUtils on ErrorPageType {
  bool get isEmpty => this.toString().contains("Empty");
  bool get isPermission => this.toString().contains("Perm");
  bool get isNetwork => this.toString().contains('Network');
}

class ErrorPageArgs {
  final ErrorPageType type;
  ErrorPageArgs(this.type);

  factory ErrorPageArgs.emptyContacts() => ErrorPageArgs(ErrorPageType.EmptyContacts);
  factory ErrorPageArgs.emptyFiles() => ErrorPageArgs(ErrorPageType.EmptyFiles);
  factory ErrorPageArgs.emptyLinks() => ErrorPageArgs(ErrorPageType.EmptyLinks);
  factory ErrorPageArgs.emptyMedia() => ErrorPageArgs(ErrorPageType.EmptyMedia);
  factory ErrorPageArgs.permLocation() => ErrorPageArgs(ErrorPageType.PermLocation);
  factory ErrorPageArgs.permMedia() => ErrorPageArgs(ErrorPageType.PermMedia);
  factory ErrorPageArgs.noNetwork() => ErrorPageArgs(ErrorPageType.NoNetwork);

  Color get backgroundColor {
    switch (type) {
      case ErrorPageType.EmptyContacts:
        return Colors.white;
      case ErrorPageType.EmptyFiles:
        return Colors.white;
      case ErrorPageType.EmptyLinks:
        return Color.fromRGBO(159, 177, 192, 1.0);
      case ErrorPageType.EmptyMedia:
        return Color.fromRGBO(240, 244, 244, 1.0);
      default:
        return AppTheme.backgroundColor;
    }
  }

  /// Returns Image Asset Path for Error
  String get imagePath {
    // Initialize Base Path
    final basePath = "assets/illustrations/";
    // Get Path
    switch (type) {
      case ErrorPageType.EmptyContacts:
        return basePath + "NoContacts.png";
      case ErrorPageType.EmptyFiles:
        return basePath + "NoFiles.png";
      case ErrorPageType.EmptyLinks:
        return basePath + "NoLinks.png";
      case ErrorPageType.EmptyMedia:
        return basePath + "NoMedia.png";
      case ErrorPageType.PermLocation:
        return basePath + "LocationPerm.png";
      case ErrorPageType.PermMedia:
        return basePath + "MediaPerm.png";
      case ErrorPageType.NoNetwork:
        return basePath + "ErrorNetwork.png";
      default:
        return "";
    }
  }

  String get buttonText {
    if (type.isEmpty) {
      return "Return Home";
    } else if (type.isPermission) {
      return "Grant";
    } else {
      return "Retry";
    }
  }

  Color get textColor => type == ErrorPageType.EmptyLinks ? SonrColor.White : SonrColor.Black;

  Future<void> action() async {
    if (type == ErrorPageType.PermLocation) {
      await Permissions.Location.request();
    } else if (type == ErrorPageType.PermMedia) {
      await Permissions.Gallery.request();
    } else if (type == ErrorPageType.NoNetwork) {
    } else {
      AppRoute.close();
    }
  }
}

class PostsPageArgs {
  final PostItemType type;
  final ScrollController? scrollController;
  PostsPageArgs(this.type, {this.scrollController});

  factory PostsPageArgs.contacts({ScrollController? scrollController}) => PostsPageArgs(PostItemType.Contacts, scrollController: scrollController);

  factory PostsPageArgs.files({ScrollController? scrollController}) => PostsPageArgs(PostItemType.Files, scrollController: scrollController);

  factory PostsPageArgs.links({ScrollController? scrollController}) => PostsPageArgs(PostItemType.Links, scrollController: scrollController);

  factory PostsPageArgs.media({ScrollController? scrollController}) => PostsPageArgs(PostItemType.Media, scrollController: scrollController);
}
