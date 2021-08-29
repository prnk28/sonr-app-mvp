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
  static BuildMode mode() {
    if (kReleaseMode) {
      return BuildMode.Release;
    } else {
      return BuildMode.Debug;
    }
  }

  /// Returns Current BuildMode from Foundation and
  /// Wraps into InitializeRequest_LogLevel
  static InitializeRequest_LogLevel logLevel() => mode().toLogLevel();

  /// Checks if Build Mode is Debug
  bool get isDebug => this == BuildMode.Debug && !kReleaseMode;

  /// Checks if Build Mode is Release
  bool get isRelease => this == BuildMode.Release && kReleaseMode;

  /// Converts BuildMode from Foundation into InitializeRequest_LogLevel
  InitializeRequest_LogLevel toLogLevel() {
    // Check if Test Device is connected
    if (Logger.isTestDevice) {
      return InitializeRequest_LogLevel.INFO;
    }

    // Check for Debug Mode
    if (this.isDebug) {
      return InitializeRequest_LogLevel.DEBUG;
    } else {
      return InitializeRequest_LogLevel.WARNING;
    }
  }
}

// ** ─── Snackbar Arguments ────────────────────────────────────────────────────────
/// Class to Provide Snackbar Properties to AppRoute
class SnackArgs {
  // Properties
  final Color? backgroundColor;
  final Color textColor;
  final String? title;
  final String message;
  final Widget icon;
  final Duration? duration;
  final bool shouldIconPulse;
  final SnackPosition position;
  final Gradient? backgroundGradient;
  final SnackStyle? snackStyle;
  final TextButton? mainButton;
  final AnimationController? progressIndicatorController;
  final Color? progressIndicatorBackgroundColor;
  final Animation<Color>? progressIndicatorValueColor;
  final void Function(GetBar<Object>)? onTap;
  final bool? isDismissible;
  final SnackDismissDirection? dismissDirection;

  SnackArgs(
      {required this.title,
      required this.message,
      required this.icon,
      this.backgroundColor,
      this.textColor = AppColor.White,
      this.backgroundGradient,
      this.snackStyle,
      this.mainButton,
      required this.duration,
      required this.shouldIconPulse,
      required this.position,
      this.progressIndicatorController,
      this.dismissDirection,
      this.progressIndicatorBackgroundColor,
      this.onTap,
      this.isDismissible,
      this.progressIndicatorValueColor});

  /// #### Custom Alert
  factory SnackArgs.alert({
    required String title,
    required String message,
    required Icon icon,
    Color color = Colors.orange,
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    return SnackArgs(
        title: title, message: message, icon: icon, backgroundColor: color, duration: 2600.milliseconds, shouldIconPulse: false, position: position);
  }

  /// #### Cancelled Operation
  factory SnackArgs.cancelled(String message, {SnackPosition position = SnackPosition.BOTTOM}) {
    return SnackArgs(
        title: "Cancelled.",
        message: message,
        icon: SimpleIcons.Stop.white,
        backgroundColor: Colors.yellow,
        duration: 2600.milliseconds,
        shouldIconPulse: false,
        position: position);
  }

  /// #### Error on Operation
  factory SnackArgs.error(String message, {ErrorEvent? error}) {
    // @ Internal Error
    if (error != null) {
      switch (error.severity) {
        // Orange - Title Failed
        case ErrorEvent_Severity.CRITICAL:
          Sound.Critical.play();
          return SnackArgs(
            title: "Failed",
            message: error.message,
            icon: Icon(Icons.sms_failed_outlined),
            backgroundColor: Colors.orange,
            duration: 2600.milliseconds,
            shouldIconPulse: false,
            position: SnackPosition.BOTTOM,
          );

        // Red - Title Error
        case ErrorEvent_Severity.FATAL:
          Sound.Fatal.play();
          return SnackArgs(
            title: "Error",
            message: error.message,
            icon: SimpleIcons.Caution.white,
            backgroundColor: Colors.red,
            duration: 2600.milliseconds,
            shouldIconPulse: false,
            position: SnackPosition.BOTTOM,
          );

        // Yellow - Title Warning
        default:
          Sound.Warning.play();
          return SnackArgs(
            title: "Warning",
            message: error.message,
            icon: SimpleIcons.Caution.white,
            backgroundColor: Colors.yellow,
            duration: 2600.milliseconds,
            shouldIconPulse: false,
            position: SnackPosition.BOTTOM,
          );
      }
    }
    // @ App Error
    else {
      Sound.Warning.play();
      return SnackArgs(
        title: "Error",
        message: message,
        icon: SimpleIcons.Caution.white,
        backgroundColor: Colors.red,
        duration: 2600.milliseconds,
        shouldIconPulse: false,
        position: SnackPosition.BOTTOM,
      );
    }
  }

  /// #### Invalid Operation
  factory SnackArgs.invalid(String message, {SnackPosition position = SnackPosition.BOTTOM}) {
    return SnackArgs(
      title: "Uh Oh!",
      message: message,
      icon: SimpleIcons.Warning.white,
      backgroundColor: Colors.orange[900],
      duration: 2600.milliseconds,
      shouldIconPulse: false,
      position: position,
    );
  }

  /// #### MailEvent Operation
  factory SnackArgs.mail(
    MailEvent mail,
  ) {
    final inv = mail.invite;
    return SnackArgs(
      title: "Remote Invite",
      message: inv.payload.toString() + " File from ${mail.invite.from.active.profile.firstName}",
      icon: SimpleIcons.Compass.white,
      backgroundColor: AppTheme.AccentColor,
      snackStyle: SnackStyle.FLOATING,
      duration: 5.seconds,
      shouldIconPulse: true,
      position: SnackPosition.TOP,
      dismissDirection: SnackDismissDirection.HORIZONTAL,
      isDismissible: true,
      onTap: (_) {
        HapticFeedback.heavyImpact();

        // Place Controller
        if (inv.payload == Payload.CONTACT) {
          AppRoute.popup(ContactAuthView(false, invite: inv), dismissible: false);
        } else {
          AppRoute.sheet(InviteRequestSheet(invite: inv), key: ValueKey(inv), dismissible: true, onDismissed: (direction) {
            NodeService.instance.respond(inv.newDeclineResponse());
            AppRoute.close();
          });
        }
      },
    );
  }

  /// #### Missing Data
  factory SnackArgs.missing(String message, {bool isLast = false, SnackPosition position = SnackPosition.BOTTOM}) {
    // Get Missing Title
    return SnackArgs(
      title: isLast ? "Almost There!" : ['Wait!', 'Hold Up!', "Uh Oh!"].random(),
      message: message,
      icon: SimpleIcons.Warning.white,
      backgroundColor: AppColor.Red,
      duration: 2600.milliseconds,
      shouldIconPulse: false,
      position: position,
    );
  }

  /// #### RemoteNotification Operation
  factory SnackArgs.notification(
    RemoteNotification notification,
  ) {
    return SnackArgs(
      title: notification.title,
      message: notification.body ?? "",
      icon: SimpleIcons.Alerts.white,
      backgroundColor: AppTheme.AccentColor,
      duration: 4000.milliseconds,
      shouldIconPulse: true,
      position: SnackPosition.TOP,
      dismissDirection: SnackDismissDirection.HORIZONTAL,
      isDismissible: true,
      onTap: (_) {
        AppPage.Activity.to();
      },
    );
  }

  /// #### Succesful Operation
  factory SnackArgs.success(
    String message, {
    SnackPosition position = SnackPosition.BOTTOM,
    void Function(GetBar<Object>)? onTap,
  }) {
    return SnackArgs(
      title: "Success!",
      onTap: onTap,
      message: message,
      icon: SimpleIcons.Success.white,
      backgroundColor: Colors.green,
      duration: 2600.milliseconds,
      shouldIconPulse: true,
      position: position,
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

enum ErrorPageType { EmptyContacts, EmptyFiles, EmptyLinks, EmptyMedia, PermLocation, PermMedia, PermNotifications, NoNetwork }

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
  factory ErrorPageArgs.permNotifications() => ErrorPageArgs(ErrorPageType.PermNotifications);
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
        return AppTheme.BackgroundColor;
    }
  }

  /// Returns Image Asset Path for Error
  String get imagePath {
    // Initialize Base Path
    final basePath = "assets/images/illustrations/";
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
      case ErrorPageType.PermNotifications:
        return basePath + "NotificationsPerm.png";
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
        return AppColor.White;
      case ErrorPageType.NoNetwork:
        return AppColor.White;
      default:
        return AppColor.Black;
    }
  }

  Future<void> action() async {
    if (type == ErrorPageType.PermLocation) {
      await Permissions.Location.request();
    } else if (type == ErrorPageType.PermMedia) {
      await Permissions.Gallery.request();
    } else if (type == ErrorPageType.PermNotifications) {
      await Permissions.Notifications.request();
    } else if (type == ErrorPageType.NoNetwork) {
      if (DeviceService.hasInternet) {
        AppRoute.close();
      } else {
        AppRoute.snack(SnackArgs.error("Network has still not been found."));
      }
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

// ** ─── Activity Arguments ────────────────────────────────────────────────────────
/// Class to Provide Arguments for ActivityPage
class ActivityPageArgs {
  final bool isNewSession;
  ActivityPageArgs({required this.isNewSession});
}
