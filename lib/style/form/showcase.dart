import 'package:showcaseview/showcaseview.dart';
import 'package:sonr_app/pages/home/controllers/home_controller.dart';
import 'package:sonr_app/style/style.dart';

enum ShowcaseType {
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

extension ShowcaseUtil on ShowcaseType {
  /// Return which page this ShowcaseType resides
  AppPage get appPage {
    switch (this) {
      case ShowcaseType.Dashboard:
        return AppPage.Home;
      case ShowcaseType.Personal:
        return AppPage.Home;
      case ShowcaseType.Alerts:
        return AppPage.Home;
      case ShowcaseType.Help:
        return AppPage.Home;
      case ShowcaseType.ShareStart:
        return AppPage.Home;
      case ShowcaseType.ShareConfirm:
        return AppPage.Share;
      case ShowcaseType.CameraPick:
        return AppPage.Share;
      case ShowcaseType.ContactPick:
        return AppPage.Share;
      case ShowcaseType.FilePick:
        return AppPage.Share;
      case ShowcaseType.AlbumDropdown:
        return AppPage.Share;
    }
  }

  /// Return Title for ShowcaseItemType
  String get title {
    switch (this) {
      case ShowcaseType.Dashboard:
        return 'Dashboard';
      case ShowcaseType.Personal:
        return 'Personal';
      case ShowcaseType.Alerts:
        return 'Alerts';
      case ShowcaseType.Help:
        return 'Help';
      case ShowcaseType.ShareStart:
        return 'Share';
      case ShowcaseType.ShareConfirm:
        return 'Confirm';
      case ShowcaseType.CameraPick:
        return 'Choose Camera';
      case ShowcaseType.ContactPick:
        return 'Choose Contact';
      case ShowcaseType.FilePick:
        return 'Choose File';
      case ShowcaseType.AlbumDropdown:
        return 'Albums';
    }
  }

  /// Return Description for ShowcaseItemType
  String get description {
    switch (this) {
      case ShowcaseType.Dashboard:
        return 'View all your received Transfers from this page.';
      case ShowcaseType.Personal:
        return 'Edit and View your Personal Contact Card.';
      case ShowcaseType.Alerts:
        return 'See Active or Past Transfers here.';
      case ShowcaseType.Help:
        return 'Tap for Live Help with Intercom.';
      case ShowcaseType.ShareStart:
        return 'Tap Here to begin Sharing.';
      case ShowcaseType.ShareConfirm:
        return 'Tap to confirm your choosen files.';
      case ShowcaseType.CameraPick:
        return 'Tap to capture an image or video.';
      case ShowcaseType.ContactPick:
        return 'Tap to choose your contact card to share.';
      case ShowcaseType.FilePick:
        return 'Tap to open file picker to select file.';
      case ShowcaseType.AlbumDropdown:
        return 'Tap to change current album.';
    }
  }

  /// Return ShapeBorder for ShowcaseItemType
  ShapeBorder get shapeBorder {
    if (this.appPage == AppPage.Home) {
      return CircleBorder();
    } else {
      return RoundedRectangleBorder(borderRadius: BorderRadius.circular(22));
    }
  }

  /// Return GlobalKey for ShowcaseItemType
  GlobalKey get globalKey {
    switch (this) {
      case ShowcaseType.Dashboard:
        return Get.find<HomeController>().keyThree;
      case ShowcaseType.Personal:
        return Get.find<HomeController>().keyFour;
      case ShowcaseType.Alerts:
        return Get.find<HomeController>().keyTwo;
      case ShowcaseType.Help:
        return Get.find<HomeController>().keyOne;
      case ShowcaseType.ShareStart:
        return Get.find<HomeController>().keyFive;
      case ShowcaseType.ShareConfirm:
        return Get.find<ShareController>().keyFive;
      case ShowcaseType.CameraPick:
        return Get.find<ShareController>().keyOne;
      case ShowcaseType.ContactPick:
        return Get.find<ShareController>().keyTwo;
      case ShowcaseType.FilePick:
        return Get.find<ShareController>().keyThree;
      case ShowcaseType.AlbumDropdown:
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
  final ShapeBorder shapeBorder;

  const ShowcaseItem({
    required this.title,
    required this.description,
    required this.child,
    required this.globalKey,
    required this.shapeBorder,
  });

  /// Return Showcase Item from Type
  factory ShowcaseItem.fromType({required ShowcaseType type, required Widget child}) {
    return ShowcaseItem(
      title: type.title,
      description: type.description,
      child: child,
      globalKey: type.globalKey,
      shapeBorder: type.shapeBorder,
    );
  }

  @override
  Widget build(BuildContext context) => Showcase(
        key: globalKey,
        showcaseBackgroundColor: AppColor.Blue,
        shapeBorder: shapeBorder,
        contentPadding: EdgeInsets.all(8),
        showArrow: true,
        disableAnimation: false,
        description: description,
        descTextStyle: DisplayTextStyle.Light.style(color: AppColor.White, fontSize: 20),
        overlayColor: Colors.black,
        overlayOpacity: 0.85,
        title: "$title",
        titleTextStyle: DisplayTextStyle.Subheading.style(color: AppColor.White, fontSize: 28),
        child: child,
      );
}
