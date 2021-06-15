import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sonr_app/service/client/sonr.dart';
import 'package:sonr_app/style.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/pages/details/items/detail_view.dart';

// ** ─── Activity Arguments ────────────────────────────────────────────────────────
/// Class to Provide Arguments for ActivityPage
class ActivityPageArgs {
  final bool isNewSession;
  ActivityPageArgs({required this.isNewSession});
}

// ** ─── HomePage Arguments ────────────────────────────────────────────────────────
/// Class to Provide Arguments for HomePage
class HomePageArgs {
  final bool isFirstLoad;
  final bool hasNewCard;
  final bool firstNewCard;
  final Transfer? newCard;

  HomePageArgs({this.isFirstLoad = false, this.hasNewCard = false, this.firstNewCard = false, this.newCard});
}

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

  SnackArgs(this.title, this.message, this.icon, this.color, this.duration, this.shouldIconPulse);

  /// @ Custom Alert
  factory SnackArgs.remote({required String message, int duration = 45000, Color color = Colors.purple}) {
    return SnackArgs("Remote Code", message, SonrIcons.Remote.white, color, duration, true);
  }

  /// @ Custom Alert
  factory SnackArgs.alert({required String title, required String message, required Icon icon, Color color = Colors.orange}) {
    return SnackArgs(title, message, icon, color, 2600, false);
  }

  /// @ Cancelled Operation
  factory SnackArgs.cancelled(String message) {
    return SnackArgs("Cancelled.", message, SonrIcons.Stop.white, Colors.yellow, 2600, false);
  }

  /// @ Error on Operation
  factory SnackArgs.error(String message, {ErrorMessage? error}) {
    // @ Internal Error
    if (error != null) {
      switch (error.severity) {
        // Orange - Title Failed
        case ErrorMessage_Severity.CRITICAL:
          DeviceService.playSound(type: UISoundType.Critical);
          return SnackArgs("Failed", error.message, Icon(Icons.sms_failed_outlined), Colors.orange, 2600, false);

        // Red - Title Error
        case ErrorMessage_Severity.FATAL:
          DeviceService.playSound(type: UISoundType.Fatal);
          return SnackArgs("Error", error.message, SonrIcons.Caution.white, Colors.red, 2600, false);

        // Yellow - Title Warning
        default:
          DeviceService.playSound(type: UISoundType.Warning);
          return SnackArgs("Warning", error.message, SonrIcons.Warning.white, Colors.yellow, 2600, false);
      }
    }
    // @ App Error
    else {
      DeviceService.playSound(type: UISoundType.Warning);
      return SnackArgs("Error", message, SonrIcons.Caution.white, Colors.red, 2600, false);
    }
  }

  /// @ Invalid Operation
  factory SnackArgs.invalid(String message) {
    return SnackArgs("Uh Oh!", message, SonrIcons.Warning.white, Colors.orange[900], 2600, false);
  }

  /// @ Missing Data
  factory SnackArgs.missing(String message, {bool isLast = false}) {
    // Get Missing Title
    final list = ['Wait!', 'Hold Up!', "Uh Oh!"];
    return SnackArgs(isLast ? "Almost There!" : list.random(), message, SonrIcons.Warning.white, SonrColor.Critical, 2600, false);
  }

  /// @ Succesful Operation
  factory SnackArgs.success(String message) {
    return SnackArgs("Success!!", message, SonrIcons.Success.white, Colors.green, 2600, true);
  }
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

enum ErrorPageType {
  EmptyContacts,
  EmptyFiles,
  EmptyLinks,
  EmptyMedia,
  PermLocation,
  PermMedia,
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
        return SonrTheme.backgroundColor;
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
      default:
        return "";
    }
  }

  Color get textColor => type == ErrorPageType.EmptyLinks ? SonrColor.White : SonrColor.Black;
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
