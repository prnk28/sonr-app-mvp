import 'dart:math';
import 'package:sonr_app/style.dart';

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


  // @ Logos
  Image _logoTop = Image.network(SonrAssetLogo.Top.link, width: 128, height: 128, fit: BoxFit.contain);
  Image _logoSide = Image.network(SonrAssetLogo.Top.link, height: 128, fit: BoxFit.contain);

  // * Constructer * //
  onReady() async {
    // Load Logos
    precacheImage(_logoTop.image, Get.context!);
    precacheImage(_logoSide.image, Get.context!);
    super.onReady();
  }
}
