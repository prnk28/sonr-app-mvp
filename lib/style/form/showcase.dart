import 'package:showcaseview/showcaseview.dart';
import 'package:sonr_app/pages/home/home_controller.dart';
import 'package:sonr_app/style/style.dart';

enum ShowcaseItemType {
  Dashboard,
  Personal,
  Alerts,
  Help,
  ShareStart,
  ShareConfirm,
  CameraPick,
  ContactPick,
  FilePick,
  AlbumDropdown,
}

extension ShowcaseItemTypeUtils on ShowcaseItemType {
  /// Return Title for ShowcaseItemType
  String get title {
    switch (this) {
      case ShowcaseItemType.Dashboard:
        return 'Dashboard';
      case ShowcaseItemType.Personal:
        return 'Personal';
      case ShowcaseItemType.Alerts:
        return 'Alerts';
      case ShowcaseItemType.Help:
        return 'Help';
      case ShowcaseItemType.ShareStart:
        return 'Share';
      case ShowcaseItemType.ShareConfirm:
        return 'Confirm';
      case ShowcaseItemType.CameraPick:
        return 'Choose Camera';
      case ShowcaseItemType.ContactPick:
        return 'Choose Contact';
      case ShowcaseItemType.FilePick:
        return 'Choose File';
      case ShowcaseItemType.AlbumDropdown:
        return 'Albums';
    }
  }

  /// Return Description for ShowcaseItemType
  String get description {
    switch (this) {
      case ShowcaseItemType.Dashboard:
        return 'View all your received Transfers from this page.';
      case ShowcaseItemType.Personal:
        return 'Edit and View your Personal Contact Card.';
      case ShowcaseItemType.Alerts:
        return 'See Active or Past Transfers here.';
      case ShowcaseItemType.Help:
        return 'Tap for Live Help with Intercom.';
      case ShowcaseItemType.ShareStart:
        return 'Tap Here to begin Sharing.';
      case ShowcaseItemType.ShareConfirm:
        return 'Tap to confirm your choosen files.';
      case ShowcaseItemType.CameraPick:
        return 'Tap to capture an image or video.';
      case ShowcaseItemType.ContactPick:
        return 'Tap to choose your contact card to share.';
      case ShowcaseItemType.FilePick:
        return 'Tap to open file picker to select file.';
      case ShowcaseItemType.AlbumDropdown:
        return 'Tap to change current album.';
    }
  }

  /// Return GlobalKey for ShowcaseItemType
  GlobalKey get globalKey {
    switch (this) {
      case ShowcaseItemType.Dashboard:
        return Get.find<HomeController>().keyThree;
      case ShowcaseItemType.Personal:
        return Get.find<HomeController>().keyFour;
      case ShowcaseItemType.Alerts:
        return Get.find<HomeController>().keyTwo;
      case ShowcaseItemType.Help:
        return Get.find<HomeController>().keyOne;
      case ShowcaseItemType.ShareStart:
        return Get.find<HomeController>().keyFive;
      case ShowcaseItemType.ShareConfirm:
        return Get.find<ShareController>().keyFive;
      case ShowcaseItemType.CameraPick:
        return Get.find<ShareController>().keyOne;
      case ShowcaseItemType.ContactPick:
        return Get.find<ShareController>().keyTwo;
      case ShowcaseItemType.FilePick:
        return Get.find<ShareController>().keyThree;
      case ShowcaseItemType.AlbumDropdown:
        return Get.find<ShareController>().keyFour;
    }
  }
}

/// Widget to Wrap around an Element to Showcase
class ShowcaseItem extends StatelessWidget {
  final Widget child;
  final String title;
  final String description;
  final GlobalKey globalKey;

  const ShowcaseItem({
    required this.title,
    required this.description,
    required this.child,
    required this.globalKey,
  });

  /// Return Showcase Item from Type
  factory ShowcaseItem.fromType({required ShowcaseItemType type, required Widget child}) {
    return ShowcaseItem(
      title: type.title,
      description: type.description,
      child: child,
      globalKey: type.globalKey,
    );
  }

  @override
  Widget build(BuildContext context) => Showcase(
        key: globalKey,
        showcaseBackgroundColor: SonrColor.Primary,
        shapeBorder: CircleBorder(),
        contentPadding: EdgeInsets.all(8),
        showArrow: true,
        disableAnimation: false,
        description: description,
        descTextStyle: DisplayTextStyle.Light.style(color: SonrColor.White, fontSize: 20),
        overlayColor: Colors.black,
        overlayOpacity: 0.85,
        title: "$title",
        titleTextStyle: DisplayTextStyle.Subheading.style(color: SonrColor.White, fontSize: 28),
        child: child,
      );
}
