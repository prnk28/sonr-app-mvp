import 'dart:math';

import 'package:sonr_app/theme/form/theme.dart';

// # Lottie
enum SonrAssetLottie {
  David,
  JoinRemote,
  Gallery,
  Location,
  MediaAccess,
  Progress,
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
      case SonrAssetLottie.Gallery:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/6078773f3975e4bb08858af6_gallery.json";
      case SonrAssetLottie.Location:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/6078773fbc748953f8270d4b_location.json";
      case SonrAssetLottie.MediaAccess:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/6078773fbeb6eb5253002b22_access.json";
      case SonrAssetLottie.Progress:
        return "https://uploads-ssl.webflow.com/606fa27d65b92bdfae5c2e58/6078773f0b611698e3ad7561_progress.json";
      default:
        return "";
    }
  }

  // Widget Instance
  Widget get widget {
    switch (this) {
      case SonrAssetLottie.David:

      case SonrAssetLottie.JoinRemote:

      case SonrAssetLottie.Gallery:

      case SonrAssetLottie.Location:

      case SonrAssetLottie.MediaAccess:

      case SonrAssetLottie.Progress:

      default:
        return Container();
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

  // Widget Instance
  static String randomNoFilesLink() {
    var rand = Random().nextInt(3) + 1;
    if (rand == 1) {
      return SonrAssetIllustration.NoFiles1.link;
    } else if (rand == 2) {
      return SonrAssetIllustration.NoFiles2.link;
    } else if (rand == 3) {
      return SonrAssetIllustration.NoFiles3.link;
    } else {
      return SonrAssetIllustration.NoFiles4.link;
    }
  }

  // Widget Instance
  Image image() {
    return Image.network(this.link);
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

  Image image({double width, double height}) {
    return Image.network(this.link, width: width ?? 100, height: height ?? 100);
  }
}

class AssetService extends GetxService {}
