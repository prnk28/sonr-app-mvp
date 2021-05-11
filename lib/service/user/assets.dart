import 'dart:math';

import 'package:sonr_app/pages/home/home_controller.dart';
import 'package:sonr_app/style/style.dart';

// # Lottie
enum SonrAssetLottie {
  David,
  MediaAccess,
  Progress,
  Camera,
  Files,
  Gallery,
  Success,
  Denied,
}

// @ Helper method to retreive asset
extension LottieNetworkUtils on SonrAssetLottie {
  // Asset Link
  String get link {
    switch (this) {
      case SonrAssetLottie.David:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/6078773f507e00e828537af1_david.json";
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
      case SonrAssetLottie.Success:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/60834598e3a2bf18b09c6f8a_37265-success-animation.json";
      case SonrAssetLottie.Denied:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/6083451f8a710f4661f235b2_denied.json";
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
      case SonrAssetIcon.ProfileSelected:
        return AssetController.to._profileSelectIcon;
      case SonrAssetIcon.RemoteSelected:
        return AssetController.to._remoteSelectIcon;
      case SonrAssetIcon.ActivitySelected:
        return AssetController.to._activitySelectIcon;
      case SonrAssetIcon.HomeSelected:
        return AssetController.to._homeSelectIcon;
      default:
        return Container();
    }
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
  CreateGroup,
  NoPeers,
  NoAlerts,
  AddPicture
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
      case SonrAssetIllustration.CreateGroup:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/607f1b993ce6db87fb96abc2_create-group.png";
      case SonrAssetIllustration.NoPeers:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/607f3b7f1864e77cc43e5298_no-peers.png";
      case SonrAssetIllustration.NoAlerts:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/607f3b8086827c51039f33cf_no-alerts.png";
      case SonrAssetIllustration.AddPicture:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/607f3b7fc0b85aedda12ed5f_add-picture.png";
    }
  }

  /// @ Get Illustration
  Image get widget {
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
      case SonrAssetIllustration.CreateGroup:
        return AssetController.to._createGroup;
      case SonrAssetIllustration.NoPeers:
        return AssetController.to._noPeers;
      case SonrAssetIllustration.NoAlerts:
        return AssetController.to._noAlerts;
      case SonrAssetIllustration.AddPicture:
        return AssetController.to._addPicture;
    }
  }

  ImageProvider<Object> get image {
    switch (this) {
      case SonrAssetIllustration.NoFiles1:
        return AssetController.to._noFiles1.image;
      case SonrAssetIllustration.NoFiles2:
        return AssetController.to._noFiles2.image;
      case SonrAssetIllustration.NoFiles3:
        return AssetController.to._noFiles3.image;
      case SonrAssetIllustration.NoFiles4:
        return AssetController.to._noFiles4.image;
      case SonrAssetIllustration.LocationAccess:
        return AssetController.to._locationAccess.image;
      case SonrAssetIllustration.MediaAccess:
        return AssetController.to._mediaAccess.image;
      case SonrAssetIllustration.CameraAccess:
        return AssetController.to._cameraAccess.image;
      case SonrAssetIllustration.ConnectionLost:
        return AssetController.to._noConnection.image;
      case SonrAssetIllustration.CreateGroup:
        return AssetController.to._createGroup.image;
      case SonrAssetIllustration.NoPeers:
        return AssetController.to._noPeers.image;
      case SonrAssetIllustration.NoAlerts:
        return AssetController.to._noAlerts.image;
      case SonrAssetIllustration.AddPicture:
        return AssetController.to._addPicture.image;
    }
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

  /// @ Get Logo
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

  // @ Images: Card Design
  static Image get randomCard {
    // Get Random
    var rand = Random().nextInt(75);
    rand = rand + 1;

    // Return Image
    if (rand < 10) {
      return Image(image: AssetImage("assets/cards/0$rand.png"));
    } else {
      return Image(image: AssetImage("assets/cards/$rand.png"));
    }
  }

  // @ Illustrations: Access/Connection
  Image _addPicture = Image(image: NetworkImage(SonrAssetIllustration.AddPicture.link), fit: BoxFit.fitHeight);
  Image _cameraAccess = Image(image: NetworkImage(SonrAssetIllustration.CameraAccess.link), fit: BoxFit.fitHeight);
  Image _createGroup = Image(image: NetworkImage(SonrAssetIllustration.CreateGroup.link), fit: BoxFit.fitHeight);
  Image _locationAccess = Image(image: NetworkImage(SonrAssetIllustration.LocationAccess.link), fit: BoxFit.fitHeight);
  Image _mediaAccess = Image(image: NetworkImage(SonrAssetIllustration.MediaAccess.link), fit: BoxFit.fitHeight);
  Image _noConnection = Image(image: NetworkImage(SonrAssetIllustration.ConnectionLost.link), fit: BoxFit.contain);
  Image _noPeers = Image(image: NetworkImage(SonrAssetIllustration.NoPeers.link), fit: BoxFit.contain);
  Image _noAlerts = Image(image: NetworkImage(SonrAssetIllustration.NoAlerts.link), fit: BoxFit.contain);

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
  Image _logoTop = Image.network(SonrAssetLogo.Top.link, width: 128, height: 128, fit: BoxFit.contain);
  Image _logoSide = Image.network(SonrAssetLogo.Top.link, height: 128, fit: BoxFit.contain);

  // @ Icons: Tab Bar
  LottieIcon _homeSelectIcon = LottieIcon(link: SonrAssetIcon.HomeSelected.link, size: 32, key: ValueKey<bool>(true));
  LottieIcon _profileSelectIcon = LottieIcon(link: SonrAssetIcon.ProfileSelected.link, size: 32, key: ValueKey<bool>(true));
  LottieIcon _activitySelectIcon = LottieIcon(link: SonrAssetIcon.ActivitySelected.link, size: 32, key: ValueKey<bool>(true));
  LottieIcon _remoteSelectIcon = LottieIcon(link: SonrAssetIcon.RemoteSelected.link, size: 38, key: ValueKey<bool>(true));

  // * Constructer * //
  onReady() async {
    // Load Logos
    precacheImage(_logoTop.image, Get.context!);
    precacheImage(_logoSide.image, Get.context!);

    // Load Illustrations
    precacheImage(_cameraAccess.image, Get.context!);
    precacheImage(_createGroup.image, Get.context!);
    precacheImage(_locationAccess.image, Get.context!);
    precacheImage(_mediaAccess.image, Get.context!);
    precacheImage(_noConnection.image, Get.context!);

    // Load Empty States
    precacheImage(_addPicture.image, Get.context!);
    precacheImage(_noAlerts.image, Get.context!);
    precacheImage(_noPeers.image, Get.context!);
    super.onReady();
  }

  /// @ Static Get Icon for Home Tab Bar
  static Widget getHomeTabBarIcon({required HomeView view, required bool isSelected}) {
    switch (view) {
      case HomeView.Profile:
        return isSelected
            ? to._profileSelectIcon
            : ImageIcon(NetworkImage(SonrAssetIcon.ProfileDefault.link), size: 32, color: Get.theme.hintColor, key: ValueKey<bool>(false));
      case HomeView.Activity:
        return isSelected
            ? to._activitySelectIcon
            : ImageIcon(NetworkImage(SonrAssetIcon.ActivityDefault.link), size: 32, color: Get.theme.hintColor, key: ValueKey<bool>(false));
      case HomeView.Remote:
        return isSelected
            ? to._remoteSelectIcon
            : ImageIcon(NetworkImage(SonrAssetIcon.RemoteDefault.link), size: 38, color: Get.theme.hintColor, key: ValueKey<bool>(false));
      default:
        return isSelected
            ? to._homeSelectIcon
            : ImageIcon(NetworkImage(SonrAssetIcon.HomeDefault.link), size: 32, color: Get.theme.hintColor, key: ValueKey<bool>(false));
    }
  }

  //  ^ Get Random No Files Image
  static Widget getNoFiles(int val) {
    if (val == 1) {
      return to._noFiles1;
    } else if (val == 2) {
      return to._noFiles2;
    } else if (val == 3) {
      return to._noFiles3;
    } else {
      return to._noFiles4;
    }
  }
}
