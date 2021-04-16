import 'dart:math';

import 'package:sonr_app/pages/home/home_controller.dart';
import 'package:sonr_app/theme/theme.dart';

// # Lottie
enum SonrAssetLottie {
  David,
  JoinRemote,
  MediaAccess,
  Progress,
  Camera,
  Files,
  Gallery,
}

// @ Helper method to retreive asset
extension LottieNetworkUtils on SonrAssetLottie {
  // Asset Link
  String get link {
    switch (this) {
      case SonrAssetLottie.David:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/6078773f507e00e828537af1_david.json";
      case SonrAssetLottie.JoinRemote:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/6078773f783403762f50fcab_join-remote.json";
      case SonrAssetLottie.Camera:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/6078941b16c335b7c05e1543_camera.json";
      case SonrAssetLottie.Gallery:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/6078941b341e2a5bc5d21f23_gallery.json";
      case SonrAssetLottie.Files:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/6078941bbc74897f4d27fce1_files.json";
      case SonrAssetLottie.MediaAccess:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/6078773fbeb6eb5253002b22_access.json";
      case SonrAssetLottie.Progress:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/6078773f0b611698e3ad7561_progress.json";
      default:
        return "";
    }
  }
}

// # Icons
enum SonrAssetIcon {
  ProfileDefault,
  RemoteDefault,
  ActivityDefault,
  HomeDefault,
  ProfileSelected,
  RemoteSelected,
  ActivitySelected,
  HomeSelected,
}

// @ Helper method to retreive asset
extension IconNetworkUtils on SonrAssetIcon {
  // Asset Link
  String get link {
    switch (this) {
      case SonrAssetIcon.ProfileDefault:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/607877c62ba9cc6da19b2e1c_profile_disabled.png";
      case SonrAssetIcon.RemoteDefault:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/607877c6c79f133f6cb48803_remote_disabled.png";
      case SonrAssetIcon.ActivityDefault:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/607877c60b61161eadad7829_alerts_disabled.png";
      case SonrAssetIcon.HomeDefault:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/607877c65649e1636c59765f_home_disabled.png";
      case SonrAssetIcon.ProfileSelected:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/607877c628657f5ab972ca26_profile.json";
      case SonrAssetIcon.RemoteSelected:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/607877c6dbeafa06b6229ba2_remote.json";
      case SonrAssetIcon.ActivitySelected:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/607877c69edbce00efbb6358_alerts.json";
      case SonrAssetIcon.HomeSelected:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/607877c614412d091631ce7a_home.json";
      default:
        return "";
    }
  }

  Widget get widget {
    switch (this) {
      case SonrAssetIcon.ProfileDefault:
        return AssetController.to._profileDefaultIcon;
      case SonrAssetIcon.RemoteDefault:
        return AssetController.to._remoteDefaultIcon;
      case SonrAssetIcon.ActivityDefault:
        return AssetController.to._activityDefaultIcon;
      case SonrAssetIcon.HomeDefault:
        return AssetController.to._homeDefaultIcon;
      case SonrAssetIcon.ProfileSelected:
        return AssetController.to._profileSelectIcon;
      case SonrAssetIcon.RemoteSelected:
        return AssetController.to._remoteSelectIcon;
      case SonrAssetIcon.ActivitySelected:
        return AssetController.to._activitySelectIcon;
      case SonrAssetIcon.HomeSelected:
        return AssetController.to._homeSelectIcon;
    }
    return Container();
  }
}

// # Illustrations
enum SonrAssetIllustration {
  NoFiles1,
  NoFiles2,
  NoFiles3,
  NoFiles4,
  LocationAccess,
  MediaAccess,
  CameraAccess,
  ConnectionLost,
}

// @ Helper method to retreive asset
extension IllustrationNetworkUtils on SonrAssetIllustration {
  // Asset Link
  String get link {
    switch (this) {
      case SonrAssetIllustration.NoFiles1:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/607876990d2014630c107e43_no_files-1.png";
      case SonrAssetIllustration.NoFiles2:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/60787699b965b7935368bfb1_no_files-2.png";
      case SonrAssetIllustration.NoFiles3:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/607876990233a962dac2bce6_no_files-3.png";
      case SonrAssetIllustration.NoFiles4:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/6078769aa472d661fc42e949_no_files-4.png";
      case SonrAssetIllustration.LocationAccess:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/60787699ab5fde29f0702665_location_access.png";
      case SonrAssetIllustration.MediaAccess:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/6078769932be3c73fb54f455_media_access.png";
      case SonrAssetIllustration.CameraAccess:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/60787699a572987f0d11afd8_camera_access.png";
      case SonrAssetIllustration.ConnectionLost:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/60787699880cc8c9cb1434c0_connection_lost.png";
      default:
        return "";
    }
  }

  // ^ Get Illustration ^ //
  Widget get widget {
    switch (this) {
      case SonrAssetIllustration.NoFiles1:
        return AssetController.to._noFiles1;
      case SonrAssetIllustration.NoFiles2:
        return AssetController.to._noFiles2;
      case SonrAssetIllustration.NoFiles3:
        return AssetController.to._noFiles3;
      case SonrAssetIllustration.NoFiles4:
        return AssetController.to._noFiles4;
      case SonrAssetIllustration.LocationAccess:
        return AssetController.to._locationAccess;
      case SonrAssetIllustration.MediaAccess:
        return AssetController.to._mediaAccess;
      case SonrAssetIllustration.CameraAccess:
        return AssetController.to._cameraAccess;
      case SonrAssetIllustration.ConnectionLost:
        return AssetController.to._noConnection;
    }
    return Container();
  }
}

// # Icons
enum SonrAssetLogo { TopWhite, TopBlack, Top, SideWhite, SideBlack, Side }

// @ Helper method to retreive asset
extension LogoNetworkUtils on SonrAssetLogo {
  String get link {
    switch (this) {
      case SonrAssetLogo.TopWhite:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/6074769d8ac5007279b0a666_Top_White%402x.png";
      case SonrAssetLogo.TopBlack:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/6074769d68af88df48ebe252_Top_Black%402x.png";
      case SonrAssetLogo.Top:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/6074769dc99c98a56d121540_Top%402x.png";
      case SonrAssetLogo.SideWhite:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/60747694f4117157812f1980_Side_White%402x.png";
      case SonrAssetLogo.SideBlack:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/6074769453543989b7150ddc_Side_Black%402x.png";
      case SonrAssetLogo.Side:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/607476943771d053b8e89faf_Side%402x.png";
      default:
        return "";
    }
  }

  // ^ Get Logo ^ //
  Widget get widget {
    if (this == SonrAssetLogo.Top || this == SonrAssetLogo.TopWhite || this == SonrAssetLogo.TopBlack) {
      return AssetController.to._logoTop;
    }
    return AssetController.to._logoSide;
  }
}

class AssetController extends GetxController {
  // Service Accessors
  static bool get isRegistered => Get.isRegistered<AssetController>();
  static AssetController get to => Get.find<AssetController>();

  // @ Illustrations: Access/Connection
  Image _cameraAccess = Image(image: NetworkImage(SonrAssetIllustration.CameraAccess.link), fit: BoxFit.fitHeight);
  Image _locationAccess = Image(image: NetworkImage(SonrAssetIllustration.LocationAccess.link), fit: BoxFit.fitHeight);
  Image _mediaAccess = Image(image: NetworkImage(SonrAssetIllustration.MediaAccess.link), fit: BoxFit.fitHeight);
  Image _noConnection = Image(image: NetworkImage(SonrAssetIllustration.ConnectionLost.link), fit: BoxFit.fitHeight);

  // @ Illustrations: No Files
  Image _noFiles1 = Image(
    image: NetworkImage(SonrAssetIllustration.NoFiles1.link),
    fit: BoxFit.fitHeight,
    height: 160,
    colorBlendMode: BlendMode.dst,
    gaplessPlayback: true,
  );
  Image _noFiles2 = Image(
    image: NetworkImage(SonrAssetIllustration.NoFiles2.link),
    fit: BoxFit.fitHeight,
    height: 160,
    colorBlendMode: BlendMode.dst,
    gaplessPlayback: true,
  );
  Image _noFiles3 = Image(
    image: NetworkImage(SonrAssetIllustration.NoFiles3.link),
    fit: BoxFit.fitHeight,
    height: 160,
    colorBlendMode: BlendMode.dst,
    gaplessPlayback: true,
  );
  Image _noFiles4 = Image(
    image: NetworkImage(SonrAssetIllustration.NoFiles4.link),
    fit: BoxFit.fitHeight,
    height: 160,
    colorBlendMode: BlendMode.dst,
    gaplessPlayback: true,
  );

  // @ Logos
  Image _logoTop = Image.network(SonrAssetLogo.Top.link, width: 128, height: 128);
  Image _logoSide = Image.network(SonrAssetLogo.Top.link, height: 128, fit: BoxFit.fitHeight);

  // @ Icons: Tab Bar
  ImageIcon _homeDefaultIcon = ImageIcon(NetworkImage(SonrAssetIcon.HomeDefault.link), size: 32, color: Colors.grey[400], key: ValueKey<bool>(false));
  ImageIcon _profileDefaultIcon =
      ImageIcon(NetworkImage(SonrAssetIcon.ProfileDefault.link), size: 32, color: Colors.grey[400], key: ValueKey<bool>(false));
  ImageIcon _activityDefaultIcon =
      ImageIcon(NetworkImage(SonrAssetIcon.ActivityDefault.link), size: 32, color: Colors.grey[400], key: ValueKey<bool>(false));
  ImageIcon _remoteDefaultIcon =
      ImageIcon(NetworkImage(SonrAssetIcon.RemoteDefault.link), size: 38, color: Colors.grey[400], key: ValueKey<bool>(false));
  LottieIcon _homeSelectIcon = LottieIcon(link: SonrAssetIcon.HomeSelected.link, size: 32, key: ValueKey<bool>(true));
  LottieIcon _profileSelectIcon = LottieIcon(link: SonrAssetIcon.ProfileSelected.link, size: 32, key: ValueKey<bool>(true));
  LottieIcon _activitySelectIcon = LottieIcon(link: SonrAssetIcon.ActivitySelected.link, size: 32, key: ValueKey<bool>(true));
  LottieIcon _remoteSelectIcon = LottieIcon(link: SonrAssetIcon.RemoteSelected.link, size: 38, key: ValueKey<bool>(true));

  // * Constructer * //
  onInit() async {
    // Load Icons
    precacheImage(_homeDefaultIcon.image, Get.context);
    precacheImage(_profileDefaultIcon.image, Get.context);
    precacheImage(_activityDefaultIcon.image, Get.context);
    precacheImage(_remoteDefaultIcon.image, Get.context);

    // Load Logos
    precacheImage(_logoTop.image, Get.context);
    precacheImage(_logoSide.image, Get.context);

    // Load Illustrations
    precacheImage(_cameraAccess.image, Get.context);
    precacheImage(_locationAccess.image, Get.context);
    precacheImage(_mediaAccess.image, Get.context);
    precacheImage(_noConnection.image, Get.context);
    super.onInit();
  }

  // ^ Static Get Icon for Home Tab Bar ^ //
  static Widget getHomeTabBarIcon({@required HomeView view, @required bool isSelected}) {
    switch (view) {
      case HomeView.Main:
        return isSelected ? to._homeSelectIcon : to._homeDefaultIcon;
      case HomeView.Profile:
        return isSelected ? to._profileSelectIcon : to._profileDefaultIcon;
      case HomeView.Activity:
        return isSelected ? to._activitySelectIcon : to._activityDefaultIcon;
      case HomeView.Remote:
        return isSelected ? to._remoteSelectIcon : to._remoteDefaultIcon;
    }
    return Container();
  }

  //  ^ Get Random No Files Image ^ //
  static Widget randomNoFiles() {
    var rand = Random().nextInt(3) + 1;
    if (rand == 1) {
      return to._noFiles1;
    } else if (rand == 2) {
      return to._noFiles2;
    } else if (rand == 3) {
      return to._noFiles3;
    } else {
      return to._noFiles4;
    }
  }
}
