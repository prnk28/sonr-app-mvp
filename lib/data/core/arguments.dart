import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sonr_app/data/services/services.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_app/data/data.dart';

// ** ─── BuildMode Arguments ────────────────────────────────────────────────────────
/// Build Mode Enum
enum BuildMode { Release, Debug }

extension BuildModeUtil on BuildMode {
  /// Returns Current BuildMode from Foundation
  static BuildMode current() {
    if (kReleaseMode) {
      return BuildMode.Release;
    } else {
      return BuildMode.Debug;
    }
  }

  /// Checks if Build Mode is Debug
  bool get isDebug => this == BuildMode.Debug && !kReleaseMode;

  /// Checks if Build Mode is Release
  bool get isRelease => this == BuildMode.Release && kReleaseMode;
}

// ** ─── Snackbar Arguments ────────────────────────────────────────────────────────
/// Class to Provide Snackbar Properties to AppRoute
class SnackArgs {
  // Properties
  final Color? color;
  final String? title;
  final String message;
  final Widget icon;
  final int duration;
  final bool shouldIconPulse;
  final SnackPosition position;

  SnackArgs(this.title, this.message, this.icon, this.color, this.duration, this.shouldIconPulse, this.position);

  /// @ Custom Alert
  factory SnackArgs.remote({
    required String message,
    int duration = 45000,
    Color color = Colors.purple,
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    return SnackArgs("Remote Code", message, SonrIcons.Remote.white, color, duration, true, position);
  }

  /// @ Custom Alert
  factory SnackArgs.alert({
    required String title,
    required String message,
    required Icon icon,
    Color color = Colors.orange,
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    return SnackArgs(title, message, icon, color, 2600, false, position);
  }

  /// @ Cancelled Operation
  factory SnackArgs.cancelled(String message, {SnackPosition position = SnackPosition.BOTTOM}) {
    return SnackArgs("Cancelled.", message, SonrIcons.Stop.white, Colors.yellow, 2600, false, position);
  }

  /// @ Error on Operation
  factory SnackArgs.error(String message, {ErrorMessage? error}) {
    // @ Internal Error
    if (error != null) {
      switch (error.severity) {
        // Orange - Title Failed
        case ErrorMessage_Severity.CRITICAL:
          Sound.Critical.play();
          return SnackArgs(
            "Failed",
            error.message,
            Icon(Icons.sms_failed_outlined),
            Colors.orange,
            2600,
            false,
            SnackPosition.TOP,
          );

        // Red - Title Error
        case ErrorMessage_Severity.FATAL:
          Sound.Fatal.play();
          return SnackArgs(
            "Error",
            error.message,
            SonrIcons.Caution.white,
            Colors.red,
            2600,
            false,
            SnackPosition.TOP,
          );

        // Yellow - Title Warning
        default:
          Sound.Warning.play();
          return SnackArgs(
            "Warning",
            error.message,
            SonrIcons.Warning.white,
            Colors.yellow,
            2600,
            false,
            SnackPosition.BOTTOM,
          );
      }
    }
    // @ App Error
    else {
      Sound.Warning.play();
      return SnackArgs(
        "Error",
        message,
        SonrIcons.Caution.white,
        Colors.red,
        2600,
        false,
        SnackPosition.TOP,
      );
    }
  }

  /// @ Invalid Operation
  factory SnackArgs.invalid(String message, {SnackPosition position = SnackPosition.BOTTOM}) {
    return SnackArgs(
      "Uh Oh!",
      message,
      SonrIcons.Warning.white,
      Colors.orange[900],
      2600,
      false,
      position,
    );
  }

  /// @ Missing Data
  factory SnackArgs.missing(String message, {bool isLast = false, SnackPosition position = SnackPosition.BOTTOM}) {
    // Get Missing Title
    final list = ['Wait!', 'Hold Up!', "Uh Oh!"];
    return SnackArgs(
      isLast ? "Almost There!" : list.random(),
      message,
      SonrIcons.Warning.white,
      SonrColor.Critical,
      2600,
      false,
      position,
    );
  }

  /// @ Succesful Operation
  factory SnackArgs.success(String message, {SnackPosition position = SnackPosition.BOTTOM}) {
    return SnackArgs(
      "Success!!",
      message,
      SonrIcons.Success.white,
      Colors.green,
      2600,
      true,
      position,
    );
  }
}

// ** ─── Page-Based Arguments ────────────────────────────────────────────────────────
/// TransferPage Arguments
class TransferArguments {
  final InviteRequest request;
  TransferArguments(this.request);
}

/// Class to Provide Arguments for HomePage
class HomeArguments {
  final bool isFirstLoad;
  final bool hasNewCard;
  final bool firstNewCard;
  final Transfer? newCard;

  HomeArguments({this.isFirstLoad = false, this.hasNewCard = false, this.firstNewCard = false, this.newCard});

  static HomeArguments get FirstLoad => HomeArguments(isFirstLoad: true);
}

// ** ─── Details Arguments ────────────────────────────────────────────────────────

enum DetailPageType {
  Contact,
  File,
  Media,
  Url,
}

class DetailPageArgs {
  final DetailPageType type;
  final SFile? file;
  final SFile_Item? mediaItem;
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

  factory DetailPageArgs.file(SFile file) => DetailPageArgs(
        DetailPageType.File,
        file: file,
      );

  factory DetailPageArgs.media(SFile_Item item, File? file) => DetailPageArgs(
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

  Color get textColor {
    switch (this.type) {
      case ErrorPageType.EmptyLinks:
        return SonrColor.White;
      case ErrorPageType.NoNetwork:
        return SonrColor.White;
      default:
        return SonrColor.Black;
    }
  }

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
