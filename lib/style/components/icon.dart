import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sonr_plugin/sonr_plugin.dart';
import '../theme/color.dart';
import '../theme/gradient.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sonr_app/style/style.dart';

extension IntricateIconUtils on ComplexIcons {
  /// Returns Full System Path - For Comment Generation
  String fullPath(String dir, {bool withDots = false}) => withDots ? dir + this.pathDots : dir + this.path;

  /// Returns Path for this Icon
  String get path {
    // Set Base Path
    var path = 'assets/images/svg/';

    // Iterate Words
    bool isFirst = true;
    for (var word in this.pascalWords) {
      // Verify Value
      if (word != null) {
        // Check if first element
        if (isFirst) {
          path += word.toLowerCase();
          isFirst = false;
        }
        // Add Hyphen for consecutive words
        else {
          path += "-${word.toLowerCase()}";
        }
      }
    }
    // Return with extension
    return path;
  }

  /// Returns Path for this Icon
  String get pathDots {
    // Set Base Path
    var path = 'assets/images/svg/';

    // Iterate Words
    bool isFirst = true;
    for (var word in this.pascalWords) {
      // Verify Value
      if (word != null) {
        // Check if first element
        if (isFirst) {
          path += word.toLowerCase();
          isFirst = false;
        }
        // Add Hyphen for consecutive words
        else {
          path += "-${word.toLowerCase()}";
        }
      }
    }
    // Return with extension
    return path + '_dots.svg';
  }

  /// ## IntricateIcons: SVG
  /// Returns SVGPicture Widget, contains all Default properties for SVGPicture package.
  SvgPicture normal({
    Key? key,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    Clip clipBehavior = Clip.hardEdge,
  }) {
    return SvgPicture.asset(
      this.path,
      color: Get.isDarkMode ? Color(0xffC2C2C2) : Color(0xff515151),
      bundle: rootBundle,
      key: key,
      clipBehavior: clipBehavior,
      fit: fit,
      width: width,
      height: height,
      colorBlendMode: BlendMode.overlay,
      alignment: alignment,
    );
  }

  /// ## IntricateIcons: SVG
  /// Returns SVGPicture Widget, contains all Default properties for SVGPicture package.
  SvgPicture dots({
    Key? key,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    Color? color,
    Clip clipBehavior = Clip.hardEdge,
  }) {
    return SvgPicture.asset(
      this.pathDots,
      color: Get.isDarkMode ? Color(0xffC2C2C2) : Color(0xff515151),
      bundle: rootBundle,
      key: key,
      clipBehavior: clipBehavior,
      fit: fit,
      width: width,
      height: height,
      alignment: alignment,
    );
  }

  /// Get All pascal words in Enum Value
  List<String?> get pascalWords => K_PASCAL_REGEX.allMatches(this.value).map((m) => m[0]).toList();

  /// Get the Name of This Value
  String get value => this.toString().substring(this.toString().indexOf('.') + 1);

  /// #### Constant Regex Expression for Fuzzy Path
  static final K_PASCAL_REGEX = RegExp(r"(?:[A-Z]+|^)[a-z]*");
}

extension MimeIcon on MIME_Type {
  Widget gradient({double size = 32, Gradient? gradient}) {
    return this.iconData.gradient(value: gradient ?? this.defaultIconGradient, size: size);
  }

  Icon icon({double size = 32, Color color = AppColor.White}) {
    return this.iconData.icon(size: size, color: color) as Icon;
  }

  Icon black({double size = 32}) {
    return this.iconData.blackWith(size: size) as Icon;
  }

  Icon grey({double size = 32}) {
    return this.iconData.greyWith(size: size) as Icon;
  }

  Icon white({double size = 32}) {
    return this.iconData.whiteWith(size: size) as Icon;
  }

  IconData get iconData {
    switch (this) {
      case MIME_Type.AUDIO:
        return SimpleIcons.Audio;
      case MIME_Type.IMAGE:
        return SimpleIcons.Image;
      case MIME_Type.TEXT:
        return SimpleIcons.Document;
      case MIME_Type.VIDEO:
        return SimpleIcons.Video;
      default:
        if (this == MIME_Type.PDF) {
          return SimpleIcons.PDF;
        } else if (this == MIME_Type.SPREADSHEET) {
          return SimpleIcons.Spreadsheet;
        } else if (this == MIME_Type.PRESENTATION) {
          return SimpleIcons.Presentation;
        }
        return SimpleIcons.Unknown;
    }
  }

  Gradient get defaultIconGradient {
    switch (this) {
      case MIME_Type.AUDIO:
        return DesignGradients.FlyingLemon;
      case MIME_Type.IMAGE:
        return DesignGradients.JuicyCake;
      case MIME_Type.TEXT:
        return DesignGradients.FarawayRiver;
      case MIME_Type.VIDEO:
        return DesignGradients.NightCall;
      default:
        if (this == MIME_Type.PDF) {
          return DesignGradients.RoyalGarden;
        } else if (this == MIME_Type.SPREADSHEET) {
          return DesignGradients.ItmeoBranding;
        } else if (this == MIME_Type.PRESENTATION) {
          return DesignGradients.OrangeJuice;
        }
        return DesignGradients.SolidStone;
    }
  }
}

extension PayloadIcon on Payload {
  Widget gradient({double size = 32, Gradient? gradient}) {
    return this.iconData.gradient(value: gradient ?? this.defaultIconGradient, size: size);
  }

  Icon icon({double size = 32, Color color = AppColor.White}) {
    return this.iconData.icon(size: size, color: color) as Icon;
  }

  Icon black({double size = 32}) {
    return this.iconData.blackWith(size: size) as Icon;
  }

  Icon grey({double size = 32}) {
    return this.iconData.greyWith(size: size) as Icon;
  }

  Icon white({double size = 32}) {
    return this.iconData.whiteWith(size: size) as Icon;
  }

  IconData get iconData {
    if (this == Payload.CONTACT) {
      return SimpleIcons.Avatar;
    } else if (this == Payload.URL) {
      return SimpleIcons.Discover;
    } else if (this == Payload.FILE) {
      return SimpleIcons.Document;
    } else if (this == Payload.MEDIA) {
      return SimpleIcons.Photos;
    } else if (this == Payload.FILES) {
      return SimpleIcons.Files;
    } else {
      return SimpleIcons.Unknown;
    }
  }

  Gradient get defaultIconGradient {
    if (this == Payload.CONTACT) {
      return DesignGradients.SunnyMorning;
    } else if (this == Payload.URL) {
      return DesignGradients.Lollipop;
    } else if (this == Payload.FILE) {
      return DesignGradients.FarawayRiver;
    } else if (this == Payload.MEDIA) {
      return DesignGradients.FarawayRiver;
    } else if (this == Payload.FILES) {
      return DesignGradients.FarawayRiver;
    } else {
      return DesignGradients.SolidStone;
    }
  }
}

extension PlatformIcon on Platform {
  ///-- Returns Icon Widget -- //
  Widget gradient({double size = 32, Gradient? gradient}) {
    return this.iconData.gradient(value: gradient ?? DesignGradients.PremiumWhite, size: size);
  }

  Icon icon({double size = 32, Color color = AppColor.White}) {
    return this.iconData.icon(size: size, color: color) as Icon;
  }

  Icon black({double size = 32}) {
    return this.iconData.blackWith(size: size) as Icon;
  }

  Icon grey({double size = 32}) {
    return this.iconData.greyWith(size: size) as Icon;
  }

  Icon white({double size = 32}) {
    return this.iconData.whiteWith(size: size) as Icon;
  }

  /// Returns `IconData` based on Platform
  IconData get iconData {
    switch (this) {
      case Platform.ANDROID:
        return SimpleIcons.Android;
      case Platform.IOS:
        return SimpleIcons.IPhone;
      case Platform.MACOS:
        return SimpleIcons.IMac;
      case Platform.WINDOWS:
        return SimpleIcons.Windows;
      default:
        return SimpleIcons.Unknown;
    }
  }

  Color get defaultIconColor {
    switch (this) {
      case Platform.ANDROID:
        return Colors.greenAccent.shade400;
      case Platform.IOS:
        return Colors.lightBlueAccent.shade400;
      case Platform.MACOS:
        return Colors.lightBlueAccent;
      case Platform.WINDOWS:
        return Colors.blueAccent.shade700;
      default:
        return Colors.black87;
    }
  }

  Gradient get defaultIconGradient {
    switch (this) {
      case Platform.ANDROID:
        return DesignGradients.ItmeoBranding;
      case Platform.IOS:
        return DesignGradients.PerfectBlue;
      case Platform.MACOS:
        return DesignGradients.PlumBath;
      case Platform.WINDOWS:
        return DesignGradients.CrystalRiver;
      default:
        return DesignGradients.SolidStone;
    }
  }
}

extension SocialIconUtils on Contact_Social_Media {
  Widget gradient({double size = 32, Gradient? gradient}) {
    return this.iconData.gradient(value: gradient ?? this.defaultIconGradient, size: size);
  }

  Icon icon({double size = 32, Color color = AppColor.White}) {
    return this.iconData.icon(size: size, color: color) as Icon;
  }

  Icon black({double size = 32}) {
    return this.iconData.blackWith(size: size) as Icon;
  }

  Icon grey({double size = 32}) {
    return this.iconData.greyWith(size: size) as Icon;
  }

  Icon white({double size = 32}) {
    return this.iconData.whiteWith(size: size) as Icon;
  }

  IconData get iconData {
    switch (this) {
      case Contact_Social_Media.Snapchat:
        return SimpleIcons.Snapchat;
      case Contact_Social_Media.Github:
        return SimpleIcons.Github;
      case Contact_Social_Media.Facebook:
        return SimpleIcons.Facebook;
      case Contact_Social_Media.Medium:
        return SimpleIcons.Medium;
      case Contact_Social_Media.YouTube:
        return SimpleIcons.YouTube;
      case Contact_Social_Media.Twitter:
        return SimpleIcons.Twitter;
      case Contact_Social_Media.Instagram:
        return SimpleIcons.Instagram;
      case Contact_Social_Media.TikTok:
        return SimpleIcons.Tiktok;
      default:
        return SimpleIcons.Spotify;
    }
  }

  Gradient get defaultIconGradient {
    switch (this) {
      case Contact_Social_Media.Snapchat:
        return DesignGradients.SunnyMorning;
      case Contact_Social_Media.Github:
        return DesignGradients.SolidStone;
      case Contact_Social_Media.Facebook:
        return DesignGradients.PerfectBlue;
      case Contact_Social_Media.Medium:
        return DesignGradients.SolidStone;
      case Contact_Social_Media.YouTube:
        return DesignGradients.LoveKiss;
      case Contact_Social_Media.Twitter:
        return DesignGradients.MalibuBeach;
      case Contact_Social_Media.Instagram:
        return DesignGradients.AmourAmour;
      case Contact_Social_Media.TikTok:
        return DesignGradients.PremiumDark;
      default:
        return DesignGradients.SummerGames;
    }
  }
}

extension DesignIcon on IconData {
  Icon get black {
    return Icon(
      this,
      size: 24,
      color: AppColor.Black,
    );
  }

  Widget blackWith({double size = 24}) {
    return Icon(
      this,
      size: size,
      color: AppColor.Black,
    );
  }

  Icon get grey {
    return Icon(
      this,
      size: 24,
      color: AppColor.DarkGrey,
    );
  }

  Widget greyWith({double size = 24}) {
    return Icon(
      this,
      size: size,
      color: AppColor.DarkGrey,
    );
  }

  Icon get white {
    return Icon(
      this,
      size: 24,
      color: AppColor.White,
    );
  }

  Widget whiteWith({double size = 24}) {
    return Icon(
      this,
      size: size,
      color: AppColor.White,
    );
  }

  Widget icon({double size = 24, Color color = AppColor.White}) {
    return Icon(this, size: size, color: color);
  }

  Widget gradient({Gradient? value, double size = 32}) {
    return ShaderMask(
      blendMode: BlendMode.modulate,
      shaderCallback: (bounds) {
        var grad = value ?? AppGradients.Primary();
        return grad.createShader(bounds);
      },
      child: Icon(
        this,
        size: size,
        color: Colors.white,
      ),
    );
  }
}

/// ## Sonr Icon Class
class SimpleIcons {
  // PCRE (PHP < 7.3)
  /// -> ^.*(\s([a-zA-Z]+\s)+).*$ > Regex
  // Substitution: /// SonrIcons -$2![Icon of $2 ](/Users/prad/Sonr/docs/icons/PNG/$2.png)\n\0\n
  // Expression for Comment Generation * //
  //! Dont use underscores for fonts //

  SimpleIcons._();
  static const String _fontFamily = 'SonrIcons';
  static const String _fontNavFamily = 'SonrNavIcons';

  static const IconData Arroba = IconData(0xe900, fontFamily: _fontNavFamily);
  static const IconData Back = IconData(0xe901, fontFamily: _fontNavFamily);
  static const IconData CheckboxActive = IconData(0xe902, fontFamily: _fontNavFamily);
  static const IconData CheckboxInactive = IconData(0xe903, fontFamily: _fontNavFamily);
  static const IconData Copy = IconData(0xe904, fontFamily: _fontNavFamily);
  static const IconData Down = IconData(0xe905, fontFamily: _fontNavFamily);
  static const IconData Edit = IconData(0xe906, fontFamily: _fontNavFamily);
  static const IconData Foward = IconData(0xe907, fontFamily: _fontNavFamily);
  static const IconData HomeActive = IconData(0xe908, fontFamily: _fontNavFamily);
  static const IconData HomeInactive = IconData(0xe909, fontFamily: _fontNavFamily);
  static const IconData LikeActive = IconData(0xe90a, fontFamily: _fontNavFamily);
  static const IconData LikeInactive = IconData(0xe90b, fontFamily: _fontNavFamily);
  static const IconData Menu = IconData(0xe90c, fontFamily: _fontNavFamily);
  static const IconData Notification = IconData(0xe90d, fontFamily: _fontNavFamily);
  static const IconData PersonalActive = IconData(0xe90e, fontFamily: _fontNavFamily);
  static const IconData PersonalInactive = IconData(0xe90f, fontFamily: _fontNavFamily);
  static const IconData Report = IconData(0xe910, fontFamily: _fontNavFamily);
  static const IconData Search = IconData(0xe911, fontFamily: _fontNavFamily);
  static const IconData Setting = IconData(0xe912, fontFamily: _fontNavFamily);
  static const IconData ShareOutside = IconData(0xe913, fontFamily: _fontNavFamily);
  static const IconData Up = IconData(0xe914, fontFamily: _fontNavFamily);

  /// SonrIcons - Archive ![Icon of Alerts](/Users/prad/Sonr/docs/icons/PNG/Alerts.png)
  static const IconData Alerts = IconData(0xe9da, fontFamily: _fontFamily);

  /// SonrIcons - Archive ![Icon of Profile](/Users/prad/Sonr/docs/icons/PNG/Profile.png)
  static const IconData Profile = IconData(0xe9db, fontFamily: _fontFamily);

  /// SonrIcons - Archive ![Icon of Archive](/Users/prad/Sonr/docs/icons/PNG/Archive.png)
  static const IconData Archive = IconData(0xe914, fontFamily: _fontFamily);

  /// SonrIcons - ATSign ![Icon of ATSign](/Users/prad/Sonr/docs/icons/PNG/ATSign.png)
  static const IconData ATSign = IconData(0xe918, fontFamily: _fontFamily);

  /// SonrIcons - Barcode ![Icon of Barcode](/Users/prad/Sonr/docs/icons/PNG/Barcode.png)
  static const IconData Barcode = IconData(0xe964, fontFamily: _fontFamily);

  /// SonrIcons - Camera ![Icon of Camera](/Users/prad/Sonr/docs/icons/PNG/Camera.png)
  static const IconData Camera = IconData(0xe975, fontFamily: _fontFamily);

  /// SonrIcons - Capture ![Icon of Capture](/Users/prad/Sonr/docs/icons/PNG/Capture.png)
  static const IconData Capture = IconData(0xe9c0, fontFamily: _fontFamily);

  /// SonrIcons - Clear ![Icon of Clear](/Users/prad/Sonr/docs/icons/PNG/Clear.png)
  static const IconData Clear = IconData(0xe9c1, fontFamily: _fontFamily);

  /// SonrIcons - Compass ![Icon of Compass](/Users/prad/Sonr/docs/icons/PNG/Compass.png)
  static const IconData Compass = IconData(0xe9d0, fontFamily: _fontFamily);

  /// SonrIcons - Database ![Icon of Database](/Users/prad/Sonr/docs/icons/PNG/Database.png)
  static const IconData Database = IconData(0xe9d1, fontFamily: _fontFamily);

  /// SonrIcons - Diagram ![Icon of Diagram](/Users/prad/Sonr/docs/icons/PNG/Diagram.png)
  static const IconData Diagram = IconData(0xe9d2, fontFamily: _fontFamily);

  /// SonrIcons - Diamond ![Icon of Diamond](/Users/prad/Sonr/docs/icons/PNG/Diamond.png)
  static const IconData Diamond = IconData(0xe9d3, fontFamily: _fontFamily);

  /// SonrIcons - Gamepad ![Icon of Gamepad](/Users/prad/Sonr/docs/icons/PNG/Gamepad.png)
  static const IconData Gamepad = IconData(0xe9d4, fontFamily: _fontFamily);

  /// SonrIcons - Heart ![Icon of Heart](/Users/prad/Sonr/docs/icons/PNG/Heart.png)
  static const IconData Heart = IconData(0xe9d5, fontFamily: _fontFamily);

  /// SonrIcons - Help ![Icon of Help](/Users/prad/Sonr/docs/icons/PNG/Help.png)
  static const IconData Help = IconData(0xe9d6, fontFamily: _fontFamily);

  /// SonrIcons - NoConnection ![Icon of NoConnection](/Users/prad/Sonr/docs/icons/PNG/NoConnection.png)
  static const IconData NoConnection = IconData(0xe9d7, fontFamily: _fontFamily);

  /// SonrIcons - Pause ![Icon of Pause](/Users/prad/Sonr/docs/icons/PNG/Pause.png)
  static const IconData Pause = IconData(0xe9d8, fontFamily: _fontFamily);

  /// SonrIcons - WifiOff ![Icon of WifiOff](/Users/prad/Sonr/docs/icons/PNG/WifiOff.png)
  static const IconData WifiOff = IconData(0xe9d9, fontFamily: _fontFamily);

  /// SonrIcons - Alexa ![Icon of Alexa](/Users/prad/Sonr/docs/icons/PNG/Alexa.png)
  static const IconData Alexa = IconData(0xe945, fontFamily: _fontFamily);

  /// SonrIcons - AndroidClassic ![Icon of AndroidClassic](/Users/prad/Sonr/docs/icons/PNG/AndroidClassic.png)
  static const IconData AndroidClassic = IconData(0xe9c2, fontFamily: _fontFamily);

  /// SonrIcons - GoogleHome ![Icon of GoogleHome](/Users/prad/Sonr/docs/icons/PNG/GoogleHome.png)
  static const IconData GoogleHome = IconData(0xe9c3, fontFamily: _fontFamily);

  /// SonrIcons - IMac ![Icon of IMac](/Users/prad/Sonr/docs/icons/PNG/IMac.png)
  static const IconData IMac = IconData(0xe9c4, fontFamily: _fontFamily);

  /// SonrIcons - IPad ![Icon of IPad](/Users/prad/Sonr/docs/icons/PNG/IPad.png)
  static const IconData IPad = IconData(0xe9c5, fontFamily: _fontFamily);

  /// SonrIcons - IPadClassic ![Icon of IPadClassic](/Users/prad/Sonr/docs/icons/PNG/IPadClassic.png)
  static const IconData IPadClassic = IconData(0xe9c6, fontFamily: _fontFamily);

  /// SonrIcons - IPhoneClassic ![Icon of IPhoneClassic](/Users/prad/Sonr/docs/icons/PNG/IPhoneClassic.png)
  static const IconData IPhoneClassic = IconData(0xe9c7, fontFamily: _fontFamily);

  /// SonrIcons - LinuxDesktop ![Icon of LinuxDesktop](/Users/prad/Sonr/docs/icons/PNG/LinuxDesktop.png)
  static const IconData LinuxDesktop = IconData(0xe9c8, fontFamily: _fontFamily);

  /// SonrIcons - LinuxLaptop ![Icon of LinuxLaptop](/Users/prad/Sonr/docs/icons/PNG/LinuxLaptop.png)
  static const IconData LinuxLaptop = IconData(0xe9c9, fontFamily: _fontFamily);

  /// SonrIcons - Macbook ![Icon of Macbook](/Users/prad/Sonr/docs/icons/PNG/Macbook.png)
  static const IconData Macbook = IconData(0xe9ca, fontFamily: _fontFamily);

  /// SonrIcons - NintendoSwitch ![Icon of NintendoSwitch](/Users/prad/Sonr/docs/icons/PNG/NintendoSwitch.png)
  static const IconData NintendoSwitch = IconData(0xe9cb, fontFamily: _fontFamily);

  /// SonrIcons - WatchAndroid ![Icon of WatchAndroid](/Users/prad/Sonr/docs/icons/PNG/WatchAndroid.png)
  static const IconData WatchAndroid = IconData(0xe9cc, fontFamily: _fontFamily);

  /// SonrIcons - WatchApple ![Icon of WatchApple](/Users/prad/Sonr/docs/icons/PNG/WatchApple.png)
  static const IconData WatchApple = IconData(0xe9cd, fontFamily: _fontFamily);

  /// SonrIcons - WindowsDesktop ![Icon of WindowsDesktop](/Users/prad/Sonr/docs/icons/PNG/WindowsDesktop.png)
  static const IconData WindowsDesktop = IconData(0xe9ce, fontFamily: _fontFamily);

  /// SonrIcons - WindowsLaptop ![Icon of WindowsLaptop](/Users/prad/Sonr/docs/icons/PNG/WindowsLaptop.png)
  static const IconData WindowsLaptop = IconData(0xe9cf, fontFamily: _fontFamily);

  /// SonrIcons - AddFolder ![Icon of AddFolder](/Users/prad/Sonr/docs/icons/PNG/AddFolder.png)
  static const IconData AddFolder = IconData(0xe9bd, fontFamily: _fontFamily);

  /// SonrIcons - ContactCard ![Icon of ContactCard](/Users/prad/Sonr/docs/icons/PNG/ContactCard.png)
  static const IconData ContactCard = IconData(0xe9be, fontFamily: _fontFamily);

  /// SonrIcons - DeleteFolder ![Icon of DeleteFolder](/Users/prad/Sonr/docs/icons/PNG/DeleteFolder.png)
  static const IconData DeleteFolder = IconData(0xe9bf, fontFamily: _fontFamily);

  /// SonrIcons - Message ![Icon of Message](/Users/prad/Sonr/docs/icons/PNG/Message.png)
  static const IconData Message = IconData(0xe9b1, fontFamily: _fontFamily);

  /// SonrIcons - Unknown ![Icon of Unknown](/Users/prad/Sonr/docs/icons/PNG/Unknown.png)
  static const IconData Unknown = IconData(0xe9b5, fontFamily: _fontFamily);

  /// SonrIcons - Refresh ![Icon of Refresh](/Users/prad/Sonr/docs/icons/PNG/Refresh.png)
  static const IconData Refresh = IconData(0xe9b6, fontFamily: _fontFamily);

  /// SonrIcons - Open ![Icon of Open](/Users/prad/Sonr/docs/icons/PNG/Open.png)
  static const IconData Open = IconData(0xe9b7, fontFamily: _fontFamily);

  /// SonrIcons - Safe ![Icon of Safe](/Users/prad/Sonr/docs/icons/PNG/Safe.png)
  static const IconData Safe = IconData(0xe9b8, fontFamily: _fontFamily);

  /// SonrIcons - Sale ![Icon of Sale](/Users/prad/Sonr/docs/icons/PNG/Sale.png)
  static const IconData Sale = IconData(0xe9b9, fontFamily: _fontFamily);

  /// SonrIcons - Science ![Icon of Science](/Users/prad/Sonr/docs/icons/PNG/Science.png)
  static const IconData Science = IconData(0xe9ba, fontFamily: _fontFamily);

  /// SonrIcons - Sync ![Icon of Sync](/Users/prad/Sonr/docs/icons/PNG/Sync.png)
  static const IconData Sync = IconData(0xe9bb, fontFamily: _fontFamily);

  /// SonrIcons - Transform ![Icon of Transform](/Users/prad/Sonr/docs/icons/PNG/Transform.png)
  static const IconData Transform = IconData(0xe9bc, fontFamily: _fontFamily);

  /// SonrIcons - Apple ![Icon of Apple](/Users/prad/Sonr/docs/icons/PNG/Apple.png)
  static const IconData Apple = IconData(0xe90b, fontFamily: _fontFamily);

  /// SonrIcons - Browser ![Icon of Browser](/Users/prad/Sonr/docs/icons/PNG/Browser.png)
  static const IconData Browser = IconData(0xe9ae, fontFamily: _fontFamily);

  /// SonrIcons - ColorPalette ![Icon of ColorPalette](/Users/prad/Sonr/docs/icons/PNG/ColorPalette.png)
  static const IconData ColorPalette = IconData(0xe9b2, fontFamily: _fontFamily);

  /// SonrIcons - Clip ![Icon of Clip](/Users/prad/Sonr/docs/icons/PNG/Clip.png)
  static const IconData Clip = IconData(0xe9b3, fontFamily: _fontFamily);

  /// SonrIcons - Like ![Icon of Like](/Users/prad/Sonr/docs/icons/PNG/Like.png)
  static const IconData Like = IconData(0xe9b4, fontFamily: _fontFamily);

  /// SonrIcons - Album ![Icon of Album](/Users/prad/Sonr/docs/icons/PNG/Album.png)
  static const IconData Album = IconData(0xe97c, fontFamily: _fontFamily);

  /// SonrIcons - Alert ![Icon of Alert](/Users/prad/Sonr/docs/icons/PNG/Alert.png)
  static const IconData Alert = IconData(0xe97f, fontFamily: _fontFamily);

  /// SonrIcons - CircleDown ![Icon of CircleDown](/Users/prad/Sonr/docs/icons/PNG/CircleDown.png)
  static const IconData CircleDown = IconData(0xe980, fontFamily: _fontFamily);

  /// SonrIcons - CircleLeft ![Icon of CircleLeft](/Users/prad/Sonr/docs/icons/PNG/CircleLeft.png)
  static const IconData CircleLeft = IconData(0xe983, fontFamily: _fontFamily);

  /// SonrIcons - CircleRight ![Icon of CircleRight](/Users/prad/Sonr/docs/icons/PNG/CircleRight.png)
  static const IconData CircleRight = IconData(0xe985, fontFamily: _fontFamily);

  /// SonrIcons - CircleTop ![Icon of CircleTop](/Users/prad/Sonr/docs/icons/PNG/CircleTop.png)
  static const IconData CircleTop = IconData(0xe986, fontFamily: _fontFamily);

  /// SonrIcons - Bolt ![Icon of Bolt](/Users/prad/Sonr/docs/icons/PNG/Bolt.png)
  static const IconData Bolt = IconData(0xe991, fontFamily: _fontFamily);

  /// SonrIcons - Burger ![Icon of Burger](/Users/prad/Sonr/docs/icons/PNG/Burger.png)
  static const IconData Burger = IconData(0xe992, fontFamily: _fontFamily);

  /// SonrIcons - Lens ![Icon of Lens](/Users/prad/Sonr/docs/icons/PNG/Lens.png)
  static const IconData Lens = IconData(0xe993, fontFamily: _fontFamily);

  /// SonrIcons - Clock ![Icon of Clock](/Users/prad/Sonr/docs/icons/PNG/Clock.png)
  static const IconData Clock = IconData(0xe994, fontFamily: _fontFamily);

  /// SonrIcons - Crown ![Icon of Crown](/Users/prad/Sonr/docs/icons/PNG/Crown.png)
  static const IconData Crown = IconData(0xe995, fontFamily: _fontFamily);

  /// SonrIcons - Exchange ![Icon of Exchange](/Users/prad/Sonr/docs/icons/PNG/Exchange.png)
  static const IconData Exchange = IconData(0xe997, fontFamily: _fontFamily);

  /// SonrIcons - Eye ![Icon of Eye](/Users/prad/Sonr/docs/icons/PNG/Eye.png)
  static const IconData Eye = IconData(0xe998, fontFamily: _fontFamily);

  /// SonrIcons - FaceID ![Icon of FaceID](/Users/prad/Sonr/docs/icons/PNG/FaceID.png)
  static const IconData FaceID = IconData(0xe999, fontFamily: _fontFamily);

  /// SonrIcons - Hdd ![Icon of Hdd](/Users/prad/Sonr/docs/icons/PNG/Hdd.png)
  static const IconData Hdd = IconData(0xe99a, fontFamily: _fontFamily);

  /// SonrIcons - Info ![Icon of Info](/Users/prad/Sonr/docs/icons/PNG/Info.png)
  static const IconData Info = IconData(0xe99b, fontFamily: _fontFamily);

  /// SonrIcons - Pen ![Icon of Pen](/Users/prad/Sonr/docs/icons/PNG/Pen.png)
  static const IconData Pen = IconData(0xe99d, fontFamily: _fontFamily);

  /// SonrIcons - Rocket ![Icon of Rocket](/Users/prad/Sonr/docs/icons/PNG/Rocket.png)
  static const IconData Rocket = IconData(0xe99e, fontFamily: _fontFamily);

  /// SonrIcons - Star ![Icon of Star](/Users/prad/Sonr/docs/icons/PNG/Star.png)
  static const IconData Star = IconData(0xe9a2, fontFamily: _fontFamily);

  /// SonrIcons - Ufo ![Icon of Ufo](/Users/prad/Sonr/docs/icons/PNG/Ufo.png)
  static const IconData Ufo = IconData(0xe9a3, fontFamily: _fontFamily);

  /// SonrIcons - Upload ![Icon of Upload](/Users/prad/Sonr/docs/icons/PNG/Upload.png)
  static const IconData Upload = IconData(0xe9a4, fontFamily: _fontFamily);

  /// SonrIcons - ZoomMinus ![Icon of ZoomMinus](/Users/prad/Sonr/docs/icons/PNG/ZoomMinus.png)
  static const IconData ZoomMinus = IconData(0xe9a6, fontFamily: _fontFamily);

  /// SonrIcons - ZoomPlus ![Icon of ZoomPlus](/Users/prad/Sonr/docs/icons/PNG/ZoomPlus.png)
  static const IconData ZoomPlus = IconData(0xe9ac, fontFamily: _fontFamily);

  /// SonrIcons - Audio ![Icon of Audio](/Users/prad/Sonr/docs/icons/PNG/Audio.png)
  static const IconData Audio = IconData(0x1f508, fontFamily: _fontFamily);

  /// SonrIcons - Yoda ![Icon of Yoda](/Users/prad/Sonr/docs/icons/PNG/Yoda.png)
  static const IconData Yoda = IconData(0xe942, fontFamily: _fontFamily);

  /// SonrIcons - Cancel ![Icon of Cancel](/Users/prad/Sonr/docs/icons/PNG/Cancel.png)
  static const IconData Cancel = IconData(0xe94d, fontFamily: _fontFamily);

  /// SonrIcons - Plus ![Icon of Plus](/Users/prad/Sonr/docs/icons/PNG/Plus.png)
  static const IconData Plus = IconData(0xe961, fontFamily: _fontFamily);

  /// SonrIcons - Panorama ![Icon of Panorama](/Users/prad/Sonr/docs/icons/PNG/Panorama.png)
  static const IconData Panorama = IconData(0xe91a, fontFamily: _fontFamily);

  /// SonrIcons - WebApp ![Icon of WebApp](/Users/prad/Sonr/docs/icons/PNG/WebApp.png)
  static const IconData WebApp = IconData(0xe91b, fontFamily: _fontFamily);

  /// SonrIcons - DarthVader ![Icon of DarthVader](/Users/prad/Sonr/docs/icons/PNG/DarthVader.png)
  static const IconData DarthVader = IconData(0xe965, fontFamily: _fontFamily);

  /// SonrIcons - PDF ![Icon of PDF](/Users/prad/Sonr/docs/icons/PNG/PDF.png)
  static const IconData PDF = IconData(0xe976, fontFamily: _fontFamily);

  /// SonrIcons - IPhone ![Icon of IPhone](/Users/prad/Sonr/docs/icons/PNG/IPhone.png)
  static const IconData IPhone = IconData(0xe977, fontFamily: _fontFamily);

  /// SonrIcons - Android ![Icon of Android](/Users/prad/Sonr/docs/icons/PNG/Android.png)
  static const IconData Android = IconData(0xe97a, fontFamily: _fontFamily);

  /// SonrIcons - Stop ![Icon of Stop](/Users/prad/Sonr/docs/icons/PNG/Stop.png)
  static const IconData Stop = IconData(0xe974, fontFamily: _fontFamily);

  /// SonrIcons - Anchor ![Icon of Anchor](/Users/prad/Sonr/docs/icons/PNG/Anchor.png)
  static const IconData Anchor = IconData(0xe963, fontFamily: _fontFamily);

  /// SonrIcons - CheckAll ![Icon of CheckAll](/Users/prad/Sonr/docs/icons/PNG/CheckAll.png)
  static const IconData CheckAll = IconData(0xe966, fontFamily: _fontFamily);

  /// SonrIcons - Close ![Icon of Close](/Users/prad/Sonr/docs/icons/PNG/Close.png)
  static const IconData Close = IconData(0xe967, fontFamily: _fontFamily);

  /// SonrIcons - Gift ![Icon of Gift](/Users/prad/Sonr/docs/icons/PNG/Gift.png)
  static const IconData Gift = IconData(0xe968, fontFamily: _fontFamily);

  /// SonrIcons - Scan ![Icon of Scan](/Users/prad/Sonr/docs/icons/PNG/Scan.png)
  static const IconData Scan = IconData(0xe969, fontFamily: _fontFamily);

  /// SonrIcons - Server ![Icon of Server](/Users/prad/Sonr/docs/icons/PNG/Server.png)
  static const IconData Server = IconData(0xe96a, fontFamily: _fontFamily);

  /// SonrIcons - Ship ![Icon of Ship](/Users/prad/Sonr/docs/icons/PNG/Ship.png)
  static const IconData Ship = IconData(0xe96e, fontFamily: _fontFamily);

  /// SonrIcons - Tag ![Icon of Tag](/Users/prad/Sonr/docs/icons/PNG/Tag.png)
  static const IconData Tag = IconData(0xe96f, fontFamily: _fontFamily);

  /// SonrIcons - TrendUp ![Icon of TrendUp](/Users/prad/Sonr/docs/icons/PNG/TrendUp.png)
  static const IconData TrendUp = IconData(0xe970, fontFamily: _fontFamily);

  /// SonrIcons - Update ![Icon of Update](/Users/prad/Sonr/docs/icons/PNG/Update.png)
  static const IconData Update = IconData(0xe972, fontFamily: _fontFamily);

  /// SonrIcons - Facebook ![Icon of Facebook](/Users/prad/Sonr/docs/icons/PNG/Facebook.png)
  static const IconData Facebook = IconData(0xe900, fontFamily: _fontFamily);

  /// SonrIcons - Files ![Icon of Files](/Users/prad/Sonr/docs/icons/PNG/Files.png)
  static const IconData Files = IconData(0xe929, fontFamily: _fontFamily);

  /// SonrIcons - Video ![Icon of Video](/Users/prad/Sonr/docs/icons/PNG/Video.png)
  static const IconData Video = IconData(0xe93a, fontFamily: _fontFamily);

  /// SonrIcons - Internet ![Icon of Internet](/Users/prad/Sonr/docs/icons/PNG/Internet.png)
  static const IconData Internet = IconData(0xe94f, fontFamily: _fontFamily);

  /// SonrIcons - Link ![Icon of Link](/Users/prad/Sonr/docs/icons/PNG/Link.png)
  static const IconData Link = IconData(0xe95c, fontFamily: _fontFamily);

  /// SonrIcons - Linkedin ![Icon of Linkedin](/Users/prad/Sonr/docs/icons/PNG/Linkedin.png)
  static const IconData Linkedin = IconData(0xe962, fontFamily: _fontFamily);

  /// SonrIcons - Remote ![Icon of Remote](/Users/prad/Sonr/docs/icons/PNG/Remote.png)
  static const IconData Remote = IconData(0xe922, fontFamily: _fontFamily);

  /// SonrIcons - Photos ![Icon of Photos](/Users/prad/Sonr/docs/icons/PNG/Photos.png)
  static const IconData Photos = IconData(0xe902, fontFamily: _fontFamily);

  /// SonrIcons - Activity ![Icon of Activity](/Users/prad/Sonr/docs/icons/PNG/Activity.png)
  static const IconData Activity = IconData(0xe910, fontFamily: _fontFamily);

  /// SonrIcons - Bug ![Icon of Bug](/Users/prad/Sonr/docs/icons/PNG/Bug.png)
  static const IconData Bug = IconData(0xe91c, fontFamily: _fontFamily);

  /// SonrIcons - Check ![Icon of Check](/Users/prad/Sonr/docs/icons/PNG/Check.png)
  static const IconData Check = IconData(0xe91f, fontFamily: _fontFamily);

  /// SonrIcons - Backward ![Icon of Backward](/Users/prad/Sonr/docs/icons/PNG/Backward.png)
  static const IconData Backward = IconData(0xe920, fontFamily: _fontFamily);

  /// SonrIcons - Forward ![Icon of Forward](/Users/prad/Sonr/docs/icons/PNG/Forward.png)
  static const IconData Forward = IconData(0xe924, fontFamily: _fontFamily);

  /// SonrIcons - Collapse ![Icon of Collapse](/Users/prad/Sonr/docs/icons/PNG/Collapse.png)
  static const IconData Collapse = IconData(0xe928, fontFamily: _fontFamily);

  /// SonrIcons - Screenshot ![Icon of Screenshot](/Users/prad/Sonr/docs/icons/PNG/Screenshot.png)
  static const IconData Screenshot = IconData(0xe92b, fontFamily: _fontFamily);

  /// SonrIcons - Download ![Icon of Download](/Users/prad/Sonr/docs/icons/PNG/Download.png)
  static const IconData Download = IconData(0xe92c, fontFamily: _fontFamily);

  /// SonrIcons - Grid ![Icon of Grid](/Users/prad/Sonr/docs/icons/PNG/Grid.png)
  static const IconData Grid = IconData(0xe92d, fontFamily: _fontFamily);

  /// SonrIcons - Group ![Icon of Group](/Users/prad/Sonr/docs/icons/PNG/Group.png)
  static const IconData Group = IconData(0xe92e, fontFamily: _fontFamily);

  /// SonrIcons - Hide ![Icon of Hide](/Users/prad/Sonr/docs/icons/PNG/Hide.png)
  static const IconData Hide = IconData(0xe92f, fontFamily: _fontFamily);

  /// SonrIcons - Image ![Icon of Image](/Users/prad/Sonr/docs/icons/PNG/Image.png)
  static const IconData Image = IconData(0xe930, fontFamily: _fontFamily);

  /// SonrIcons - Inbox ![Icon of Inbox](/Users/prad/Sonr/docs/icons/PNG/Inbox.png)
  static const IconData Inbox = IconData(0xe931, fontFamily: _fontFamily);

  /// SonrIcons - Instagram ![Icon of Instagram](/Users/prad/Sonr/docs/icons/PNG/Instagram.png)
  static const IconData Instagram = IconData(0xe932, fontFamily: _fontFamily);

  /// SonrIcons - Layers ![Icon of Layers](/Users/prad/Sonr/docs/icons/PNG/Layers.png)
  static const IconData Layers = IconData(0xe933, fontFamily: _fontFamily);

  /// SonrIcons - Leaderboard ![Icon of Leaderboard](/Users/prad/Sonr/docs/icons/PNG/Leaderboard.png)
  static const IconData Leaderboard = IconData(0xe934, fontFamily: _fontFamily);

  /// SonrIcons - Spreadsheet ![Icon of Spreadsheet](/Users/prad/Sonr/docs/icons/PNG/Spreadsheet.png)
  static const IconData Spreadsheet = IconData(0xe935, fontFamily: _fontFamily);

  /// SonrIcons - Login ![Icon of Login](/Users/prad/Sonr/docs/icons/PNG/Login.png)
  static const IconData Login = IconData(0xe936, fontFamily: _fontFamily);

  /// SonrIcons - Logout ![Icon of Logout](/Users/prad/Sonr/docs/icons/PNG/Logout.png)
  static const IconData Logout = IconData(0xe938, fontFamily: _fontFamily);

  /// SonrIcons - Map ![Icon of Map](/Users/prad/Sonr/docs/icons/PNG/Map.png)
  static const IconData Map = IconData(0xe939, fontFamily: _fontFamily);

  /// SonrIcons - Medal ![Icon of Medal](/Users/prad/Sonr/docs/icons/PNG/Medal.png)
  static const IconData Medal = IconData(0xe93b, fontFamily: _fontFamily);

  /// SonrIcons - Moon ![Icon of Moon](/Users/prad/Sonr/docs/icons/PNG/Moon.png)
  static const IconData Moon = IconData(0xe93f, fontFamily: _fontFamily);

  /// SonrIcons - MoreHorizontal ![Icon of MoreHorizontal](/Users/prad/Sonr/docs/icons/PNG/MoreHorizontal.png)
  static const IconData MoreHorizontal = IconData(0xe940, fontFamily: _fontFamily);

  /// SonrIcons - MoreVertical ![Icon of MoreVertical](/Users/prad/Sonr/docs/icons/PNG/MoreVertical.png)
  static const IconData MoreVertical = IconData(0xe944, fontFamily: _fontFamily);

  /// SonrIcons - User ![Icon of User](/Users/prad/Sonr/docs/icons/PNG/User.png)
  static const IconData User = IconData(0xe949, fontFamily: _fontFamily);

  /// SonrIcons - Presentation ![Icon of Presentation](/Users/prad/Sonr/docs/icons/PNG/Presentation.png)
  static const IconData Presentation = IconData(0xe94a, fontFamily: _fontFamily);

  /// SonrIcons - Avatar ![Icon of Avatar](/Users/prad/Sonr/docs/icons/PNG/Avatar.png)
  static const IconData Avatar = IconData(0xe94b, fontFamily: _fontFamily);

  /// SonrIcons - Reload ![Icon of Reload](/Users/prad/Sonr/docs/icons/PNG/Reload.png)
  static const IconData Reload = IconData(0xe94c, fontFamily: _fontFamily);

  /// SonrIcons - Settings ![Icon of Settings](/Users/prad/Sonr/docs/icons/PNG/Settings.png)
  static const IconData Settings = IconData(0xe951, fontFamily: _fontFamily);

  /// SonrIcons - Show ![Icon of Show](/Users/prad/Sonr/docs/icons/PNG/Show.png)
  static const IconData Show = IconData(0xe952, fontFamily: _fontFamily);

  /// SonrIcons - Expand ![Icon of Expand](/Users/prad/Sonr/docs/icons/PNG/Expand.png)
  static const IconData Expand = IconData(0xe953, fontFamily: _fontFamily);

  /// SonrIcons - SmartWatch ![Icon of SmartWatch](/Users/prad/Sonr/docs/icons/PNG/SmartWatch.png)
  static const IconData SmartWatch = IconData(0xe954, fontFamily: _fontFamily);

  /// SonrIcons - Snapchat ![Icon of Snapchat](/Users/prad/Sonr/docs/icons/PNG/Snapchat.png)
  static const IconData Snapchat = IconData(0xe955, fontFamily: _fontFamily);

  /// SonrIcons - Sun ![Icon of Sun](/Users/prad/Sonr/docs/icons/PNG/Sun.png)
  static const IconData Sun = IconData(0xe956, fontFamily: _fontFamily);

  /// SonrIcons - Twitter ![Icon of Twitter](/Users/prad/Sonr/docs/icons/PNG/Twitter.png)
  static const IconData Twitter = IconData(0xe958, fontFamily: _fontFamily);

  /// SonrIcons - Undo ![Icon of Undo](/Users/prad/Sonr/docs/icons/PNG/Undo.png)
  static const IconData Undo = IconData(0xe959, fontFamily: _fontFamily);

  /// SonrIcons - Warning ![Icon of Warning](/Users/prad/Sonr/docs/icons/PNG/Warning.png)
  static const IconData Warning = IconData(0xe95e, fontFamily: _fontFamily);

  /// SonrIcons - Wind ![Icon of Wind](/Users/prad/Sonr/docs/icons/PNG/Wind.png)
  static const IconData Wind = IconData(0xe95f, fontFamily: _fontFamily);

  /// SonrIcons - Zap ![Icon of Zap](/Users/prad/Sonr/docs/icons/PNG/Zap.png)
  static const IconData Zap = IconData(0xe960, fontFamily: _fontFamily);

  /// SonrIcons - AndroidLogo ![Icon of AndroidLogo](/Users/prad/Sonr/docs/icons/PNG/AndroidLogo.png)
  static const IconData AndroidLogo = IconData(0xe903, fontFamily: _fontFamily);

  /// SonrIcons - Github ![Icon of Github](/Users/prad/Sonr/docs/icons/PNG/Github.png)
  static const IconData Github = IconData(0xe901, fontFamily: _fontFamily);

  /// SonrIcons - Medium ![Icon of Medium](/Users/prad/Sonr/docs/icons/PNG/Medium.png)
  static const IconData Medium = IconData(0xe907, fontFamily: _fontFamily);

  /// SonrIcons - Spotify ![Icon of Spotify](/Users/prad/Sonr/docs/icons/PNG/Spotify.png)
  static const IconData Spotify = IconData(0xe911, fontFamily: _fontFamily);

  /// SonrIcons - Tiktok ![Icon of Tiktok](/Users/prad/Sonr/docs/icons/PNG/Tiktok.png)
  static const IconData Tiktok = IconData(0xe912, fontFamily: _fontFamily);

  /// SonrIcons - Windows ![Icon of Windows](/Users/prad/Sonr/docs/icons/PNG/Windows.png)
  static const IconData Windows = IconData(0xe913, fontFamily: _fontFamily);

  /// SonrIcons - YouTube ![Icon of YouTube](/Users/prad/Sonr/docs/icons/PNG/YouTube.png)
  static const IconData YouTube = IconData(0xe915, fontFamily: _fontFamily);

  /// SonrIcons - Add ![Icon of Add](/Users/prad/Sonr/docs/icons/PNG/Add.png)
  static const IconData Add = IconData(0xe904, fontFamily: _fontFamily);

  /// SonrIcons - BlockedAccount ![Icon of BlockedAccount](/Users/prad/Sonr/docs/icons/PNG/BlockedAccount.png)
  static const IconData BlockedAccount = IconData(0xe905, fontFamily: _fontFamily);

  /// SonrIcons - BlockedUser ![Icon of BlockedUser](/Users/prad/Sonr/docs/icons/PNG/BlockedUser.png)
  static const IconData BlockedUser = IconData(0xe906, fontFamily: _fontFamily);

  /// SonrIcons - CallIn ![Icon of CallIn](/Users/prad/Sonr/docs/icons/PNG/CallIn.png)
  static const IconData CallIn = IconData(0xe908, fontFamily: _fontFamily);

  /// SonrIcons - CallRinging ![Icon of CallRinging](/Users/prad/Sonr/docs/icons/PNG/CallRinging.png)
  static const IconData CallRinging = IconData(0xe909, fontFamily: _fontFamily);

  /// SonrIcons - Call ![Icon of Call](/Users/prad/Sonr/docs/icons/PNG/Call.png)
  static const IconData Call = IconData(0xe90a, fontFamily: _fontFamily);

  /// SonrIcons - CanceledCall ![Icon of CanceledCall](/Users/prad/Sonr/docs/icons/PNG/CanceledCall.png)
  static const IconData CanceledCall = IconData(0xe90c, fontFamily: _fontFamily);

  /// SonrIcons - Cart ![Icon of Cart](/Users/prad/Sonr/docs/icons/PNG/Cart.png)
  static const IconData Cart = IconData(0xe90d, fontFamily: _fontFamily);

  /// SonrIcons - Category ![Icon of Category](/Users/prad/Sonr/docs/icons/PNG/Category.png)
  static const IconData Category = IconData(0xe90e, fontFamily: _fontFamily);

  /// SonrIcons - Caution ![Icon of Caution](/Users/prad/Sonr/docs/icons/PNG/Caution.png)
  static const IconData Caution = IconData(0xe90f, fontFamily: _fontFamily);

  /// SonrIcons - Coupon ![Icon of Coupon](/Users/prad/Sonr/docs/icons/PNG/Coupon.png)
  static const IconData Coupon = IconData(0xe916, fontFamily: _fontFamily);

  /// SonrIcons - Discount ![Icon of Discount](/Users/prad/Sonr/docs/icons/PNG/Discount.png)
  static const IconData Discount = IconData(0xe917, fontFamily: _fontFamily);

  /// SonrIcons - Dislike ![Icon of Dislike](/Users/prad/Sonr/docs/icons/PNG/Dislike.png)
  static const IconData Dislike = IconData(0xe919, fontFamily: _fontFamily);

  /// SonrIcons - Favorite ![Icon of Favorite](/Users/prad/Sonr/docs/icons/PNG/Favorite.png)
  static const IconData Favorite = IconData(0xe91e, fontFamily: _fontFamily);

  /// SonrIcons - Hastag ![Icon of Hastag](/Users/prad/Sonr/docs/icons/PNG/Hastag.png)
  static const IconData Hastag = IconData(0xe923, fontFamily: _fontFamily);

  /// SonrIcons - Key ![Icon of Key](/Users/prad/Sonr/docs/icons/PNG/Key.png)
  static const IconData Key = IconData(0xe926, fontFamily: _fontFamily);

  /// SonrIcons - Liked ![Icon of Liked](/Users/prad/Sonr/docs/icons/PNG/Liked.png)
  static const IconData Liked = IconData(0xe927, fontFamily: _fontFamily);

  /// SonrIcons - Location ![Icon of Location](/Users/prad/Sonr/docs/icons/PNG/Location.png)
  static const IconData Location = IconData(0xe92a, fontFamily: _fontFamily);

  /// SonrIcons - Muted ![Icon of Muted](/Users/prad/Sonr/docs/icons/PNG/Muted.png)
  static const IconData Muted = IconData(0xe937, fontFamily: _fontFamily);

  /// SonrIcons - Pin ![Icon of Pin](/Users/prad/Sonr/docs/icons/PNG/Pin.png)
  static const IconData Pin = IconData(0xe93c, fontFamily: _fontFamily);

  /// SonrIcons - Play ![Icon of Play](/Users/prad/Sonr/docs/icons/PNG/Play.png)
  static const IconData Play = IconData(0xe93d, fontFamily: _fontFamily);

  /// SonrIcons - Pocket ![Icon of Pocket](/Users/prad/Sonr/docs/icons/PNG/Pocket.png)
  static const IconData Pocket = IconData(0xe93e, fontFamily: _fontFamily);

  /// SonrIcons - Seen ![Icon of Seen](/Users/prad/Sonr/docs/icons/PNG/Seen.png)
  static const IconData Seen = IconData(0xe941, fontFamily: _fontFamily);

  /// SonrIcons - Share ![Icon of Share](/Users/prad/Sonr/docs/icons/PNG/Share.png)
  static const IconData Share = IconData(0xe943, fontFamily: _fontFamily);

  /// SonrIcons - Silent ![Icon of Silent](/Users/prad/Sonr/docs/icons/PNG/Silent.png)
  static const IconData Silent = IconData(0xe946, fontFamily: _fontFamily);

  /// SonrIcons - SoundOne ![Icon of SoundOne](/Users/prad/Sonr/docs/icons/PNG/SoundOne.png)
  static const IconData SoundOne = IconData(0xe947, fontFamily: _fontFamily);

  /// SonrIcons - SoundTwo ![Icon of SoundTwo](/Users/prad/Sonr/docs/icons/PNG/SoundTwo.png)
  static const IconData SoundTwo = IconData(0xe948, fontFamily: _fontFamily);

  /// SonrIcons - SwitchCamera ![Icon of SwitchCamera](/Users/prad/Sonr/docs/icons/PNG/SwitchCamera.png)
  static const IconData SwitchCamera = IconData(0xe957, fontFamily: _fontFamily);

  /// SonrIcons - Ticket ![Icon of Ticket](/Users/prad/Sonr/docs/icons/PNG/Ticket.png)
  static const IconData Ticket = IconData(0xe950, fontFamily: _fontFamily);

  /// SonrIcons - VideoCamera ![Icon of VideoCamera](/Users/prad/Sonr/docs/icons/PNG/VideoCamera.png)
  static const IconData VideoCamera = IconData(0xe95a, fontFamily: _fontFamily);

  /// SonrIcons - About ![Icon of About](/Users/prad/Sonr/docs/icons/PNG/About.png)
  static const IconData About = IconData(0xe95b, fontFamily: _fontFamily);

  /// SonrIcons - AddFile ![Icon of AddFile](/Users/prad/Sonr/docs/icons/PNG/AddFile.png)
  static const IconData AddFile = IconData(0xe95d, fontFamily: _fontFamily);

  /// SonrIcons - Chat ![Icon of Chat](/Users/prad/Sonr/docs/icons/PNG/Chat.png)
  static const IconData Chat = IconData(0xe96b, fontFamily: _fontFamily);

  /// SonrIcons - Checklist ![Icon of Checklist](/Users/prad/Sonr/docs/icons/PNG/Checklist.png)
  static const IconData Checklist = IconData(0xe96c, fontFamily: _fontFamily);

  /// SonrIcons - CircleClock ![Icon of CircleClock](/Users/prad/Sonr/docs/icons/PNG/CircleClock.png)
  static const IconData CircleClock = IconData(0xe96d, fontFamily: _fontFamily);

  /// SonrIcons - Discover ![Icon of Discover](/Users/prad/Sonr/docs/icons/PNG/Discover.png)
  static const IconData Discover = IconData(0xe971, fontFamily: _fontFamily);

  /// SonrIcons - DownloadFile ![Icon of DownloadFile](/Users/prad/Sonr/docs/icons/PNG/DownloadFile.png)
  static const IconData DownloadFile = IconData(0xe973, fontFamily: _fontFamily);

  /// SonrIcons - Filter ![Icon of Filter](/Users/prad/Sonr/docs/icons/PNG/Filter.png)
  static const IconData Filter = IconData(0xe978, fontFamily: _fontFamily);

  /// SonrIcons - Folder ![Icon of Folder](/Users/prad/Sonr/docs/icons/PNG/Folder.png)
  static const IconData Folder = IconData(0xe979, fontFamily: _fontFamily);

  /// SonrIcons - Home ![Icon of Home](/Users/prad/Sonr/docs/icons/PNG/Home.png)
  static const IconData Home = IconData(0xe97d, fontFamily: _fontFamily);

  /// SonrIcons - Calendar ![Icon of Calendar](/Users/prad/Sonr/docs/icons/PNG/Calendar.png)
  static const IconData Calendar = IconData(0xe97e, fontFamily: _fontFamily);

  /// SonrIcons - Document ![Icon of Document](/Users/prad/Sonr/docs/icons/PNG/Document.png)
  static const IconData Document = IconData(0xe981, fontFamily: _fontFamily);

  /// SonrIcons - List ![Icon of List](/Users/prad/Sonr/docs/icons/PNG/List.png)
  static const IconData List = IconData(0xe982, fontFamily: _fontFamily);

  /// SonrIcons - Lock ![Icon of Lock](/Users/prad/Sonr/docs/icons/PNG/Lock.png)
  static const IconData Lock = IconData(0xe984, fontFamily: _fontFamily);

  /// SonrIcons - LoginSaved ![Icon of LoginSaved](/Users/prad/Sonr/docs/icons/PNG/LoginSaved.png)
  static const IconData LoginSaved = IconData(0xe987, fontFamily: _fontFamily);

  /// SonrIcons - Love ![Icon of Love](/Users/prad/Sonr/docs/icons/PNG/Love.png)
  static const IconData Love = IconData(0xe988, fontFamily: _fontFamily);

  /// SonrIcons - Mail ![Icon of Mail](/Users/prad/Sonr/docs/icons/PNG/Mail.png)
  static const IconData Mail = IconData(0xe989, fontFamily: _fontFamily);

  /// SonrIcons - Mention ![Icon of Mention](/Users/prad/Sonr/docs/icons/PNG/Mention.png)
  static const IconData Mention = IconData(0xe98a, fontFamily: _fontFamily);

  /// SonrIcons - Mic ![Icon of Mic](/Users/prad/Sonr/docs/icons/PNG/Mic.png)
  static const IconData Mic = IconData(0xe98b, fontFamily: _fontFamily);

  /// SonrIcons - MoreCircle ![Icon of MoreCircle](/Users/prad/Sonr/docs/icons/PNG/MoreCircle.png)
  static const IconData MoreCircle = IconData(0xe98c, fontFamily: _fontFamily);

  /// SonrIcons - MoreSquare ![Icon of MoreSquare](/Users/prad/Sonr/docs/icons/PNG/MoreSquare.png)
  static const IconData MoreSquare = IconData(0xe98d, fontFamily: _fontFamily);

  /// SonrIcons - MutedCall ![Icon of MutedCall](/Users/prad/Sonr/docs/icons/PNG/MutedCall.png)
  static const IconData MutedCall = IconData(0xe98e, fontFamily: _fontFamily);

  /// SonrIcons - OfficeBag ![Icon of OfficeBag](/Users/prad/Sonr/docs/icons/PNG/OfficeBag.png)
  static const IconData OfficeBag = IconData(0xe990, fontFamily: _fontFamily);

  /// SonrIcons - Saved ![Icon of Saved](/Users/prad/Sonr/docs/icons/PNG/Saved.png)
  static const IconData Saved = IconData(0xe996, fontFamily: _fontFamily);

  /// SonrIcons - ShopBag ![Icon of ShopBag](/Users/prad/Sonr/docs/icons/PNG/ShopBag.png)
  static const IconData ShopBag = IconData(0xe99c, fontFamily: _fontFamily);

  /// SonrIcons - SquareClock ![Icon of SquareClock](/Users/prad/Sonr/docs/icons/PNG/SquareClock.png)
  static const IconData SquareClock = IconData(0xe99f, fontFamily: _fontFamily);

  /// SonrIcons - Statistic ![Icon of Statistic](/Users/prad/Sonr/docs/icons/PNG/Statistic.png)
  static const IconData Statistic = IconData(0xe9a0, fontFamily: _fontFamily);

  /// SonrIcons - StatisticAlt ![Icon of StatisticAlt](/Users/prad/Sonr/docs/icons/PNG/StatisticAlt.png)
  static const IconData StatisticAlt = IconData(0xe9a1, fontFamily: _fontFamily);

  /// SonrIcons - Theme ![Icon of Theme](/Users/prad/Sonr/docs/icons/PNG/Theme.png)
  static const IconData Theme = IconData(0xe9a5, fontFamily: _fontFamily);

  /// SonrIcons - Trash ![Icon of Trash](/Users/prad/Sonr/docs/icons/PNG/Trash.png)
  static const IconData Trash = IconData(0xe9a7, fontFamily: _fontFamily);

  /// SonrIcons - Typing ![Icon of Typing](/Users/prad/Sonr/docs/icons/PNG/Typing.png)
  static const IconData Typing = IconData(0xe9a8, fontFamily: _fontFamily);

  /// SonrIcons - CheckShield ![Icon of CheckShield](/Users/prad/Sonr/docs/icons/PNG/CheckShield.png)
  static const IconData CheckShield = IconData(0xe9a9, fontFamily: _fontFamily);

  /// SonrIcons - Unchecklist ![Icon of Unchecklist](/Users/prad/Sonr/docs/icons/PNG/Unchecklist.png)
  static const IconData Unchecklist = IconData(0xe9aa, fontFamily: _fontFamily);

  /// SonrIcons - Unlocked ![Icon of Unlocked](/Users/prad/Sonr/docs/icons/PNG/Unlocked.png)
  static const IconData Unlocked = IconData(0xe9ab, fontFamily: _fontFamily);

  /// SonrIcons - UploadFile ![Icon of UploadFile](/Users/prad/Sonr/docs/icons/PNG/UploadFile.png)
  static const IconData UploadFile = IconData(0xe9ad, fontFamily: _fontFamily);

  /// SonrIcons - Success ![Icon of Success](/Users/prad/Sonr/docs/icons/PNG/Success.png)
  static const IconData Success = IconData(0xe9af, fontFamily: _fontFamily);

  /// SonrIcons - Verified ![Icon of Verified](/Users/prad/Sonr/docs/icons/PNG/Verified.png)
  static const IconData Verified = IconData(0xe9b0, fontFamily: _fontFamily);
}

enum ComplexIcons {
  /// ### SVGIcons - `SecureKeys`
  /// !["Image of SecureKeys"](/Users/prad/Sonr/app/assets/images/svg/secure-keys.svg)
  /// !["Image of SecureKeys as Dots"](/Users/prad/Sonr/app/assets/images/svg/secure-keys_dots.svg)
  SecureKeys,

  /// ### SVGIcons - `Book`
  /// !["Image of Book"](/Users/prad/Sonr/app/assets/images/svg/book.svg)
  /// !["Image of Book as Dots"](/Users/prad/Sonr/app/assets/images/svg/book_dots.svg)
  Book,

  /// ### SVGIcons - `HandShake`
  /// !["Image of HandShake"](/Users/prad/Sonr/app/assets/images/svg/hand-shake.svg)
  /// !["Image of HandShake as Dots"](/Users/prad/Sonr/app/assets/images/svg/hand-shake_dots.svg)
  HandShake,

  /// ### SVGIcons - `Mail`
  /// !["Image of Mail"](/Users/prad/Sonr/app/assets/images/svg/mail.svg)
  /// !["Image of Mail as Dots"](/Users/prad/Sonr/app/assets/images/svg/mail_dots.svg)
  Mail,

  /// ### SVGIcons - `Video`
  /// !["Image of Video"](/Users/prad/Sonr/app/assets/images/svg/video.svg)
  /// !["Image of Video as Dots"](/Users/prad/Sonr/app/assets/images/svg/video_dots.svg)
  Video,

  /// ### SVGIcons - `Article`
  /// !["Image of Article"](/Users/prad/Sonr/app/assets/images/svg/article.svg)
  /// !["Image of Article as Dots"](/Users/prad/Sonr/app/assets/images/svg/article_dots.svg)
  Article,

  /// ### SVGIcons - `PowerpointDocument`
  /// !["Image of PowerpointDocument"](/Users/prad/Sonr/app/assets/images/svg/powerpoint-document.svg)
  /// !["Image of PowerpointDocument as Dots"](/Users/prad/Sonr/app/assets/images/svg/powerpoint-document_dots.svg)
  PowerpointDocument,

  /// ### SVGIcons - `ExcelDocument`
  /// !["Image of ExcelDocument"](/Users/prad/Sonr/app/assets/images/svg/excel-document.svg)
  /// !["Image of ExcelDocument as Dots"](/Users/prad/Sonr/app/assets/images/svg/excel-document_dots.svg)
  ExcelDocument,

  /// ### SVGIcons - `MobileConnection`
  /// !["Image of MobileConnection"](/Users/prad/Sonr/app/assets/images/svg/mobile-connection.svg)
  /// !["Image of MobileConnection as Dots"](/Users/prad/Sonr/app/assets/images/svg/mobile-connection_dots.svg)
  MobileConnection,

  /// ### SVGIcons - `ViralPost`
  /// !["Image of ViralPost"](/Users/prad/Sonr/app/assets/images/svg/viral-post.svg)
  /// !["Image of ViralPost as Dots"](/Users/prad/Sonr/app/assets/images/svg/viral-post_dots.svg)
  ViralPost,

  /// ### SVGIcons - `UserSocialEngineering`
  /// !["Image of UserSocialEngineering"](/Users/prad/Sonr/app/assets/images/svg/user-social-engineering.svg)
  /// !["Image of UserSocialEngineering as Dots"](/Users/prad/Sonr/app/assets/images/svg/user-social-engineering_dots.svg)
  UserSocialEngineering,

  /// ### SVGIcons - `Diamond`
  /// !["Image of Diamond"](/Users/prad/Sonr/app/assets/images/svg/diamond.svg)
  /// !["Image of Diamond as Dots"](/Users/prad/Sonr/app/assets/images/svg/diamond_dots.svg)
  Diamond,

  /// ### SVGIcons - `SecurityLock`
  /// !["Image of SecurityLock"](/Users/prad/Sonr/app/assets/images/svg/security-lock.svg)
  /// !["Image of SecurityLock as Dots"](/Users/prad/Sonr/app/assets/images/svg/security-lock_dots.svg)
  SecurityLock,

  /// ### SVGIcons - `Search`
  /// !["Image of Search"](/Users/prad/Sonr/app/assets/images/svg/search.svg)
  /// !["Image of Search as Dots"](/Users/prad/Sonr/app/assets/images/svg/search_dots.svg)
  Search,

  /// ### SVGIcons - `Clip`
  /// !["Image of Clip"](/Users/prad/Sonr/app/assets/images/svg/clip.svg)
  /// !["Image of Clip as Dots"](/Users/prad/Sonr/app/assets/images/svg/clip_dots.svg)
  Clip,

  /// ### SVGIcons - `Calendar`
  /// !["Image of Calendar"](/Users/prad/Sonr/app/assets/images/svg/calendar.svg)
  /// !["Image of Calendar as Dots"](/Users/prad/Sonr/app/assets/images/svg/calendar_dots.svg)
  Calendar,

  /// ### SVGIcons - `Presentation`
  /// !["Image of Presentation"](/Users/prad/Sonr/app/assets/images/svg/presentation.svg)
  /// !["Image of Presentation as Dots"](/Users/prad/Sonr/app/assets/images/svg/presentation_dots.svg)
  Presentation,

  /// ### SVGIcons - `PeopleSearch`
  /// !["Image of PeopleSearch"](/Users/prad/Sonr/app/assets/images/svg/people-search.svg)
  /// !["Image of PeopleSearch as Dots"](/Users/prad/Sonr/app/assets/images/svg/people-search_dots.svg)
  PeopleSearch,

  /// ### SVGIcons - `CreditCard`
  /// !["Image of CreditCard"](/Users/prad/Sonr/app/assets/images/svg/credit-card.svg)
  /// !["Image of CreditCard as Dots"](/Users/prad/Sonr/app/assets/images/svg/credit-card_dots.svg)
  CreditCard,

  /// ### SVGIcons - `Apple`
  /// !["Image of Apple"](/Users/prad/Sonr/app/assets/images/svg/apple.svg)
  /// !["Image of Apple as Dots"](/Users/prad/Sonr/app/assets/images/svg/apple_dots.svg)
  Apple,

  /// ### SVGIcons - `LocationPin`
  /// !["Image of LocationPin"](/Users/prad/Sonr/app/assets/images/svg/location-pin.svg)
  /// !["Image of LocationPin as Dots"](/Users/prad/Sonr/app/assets/images/svg/location-pin_dots.svg)
  LocationPin,

  /// ### SVGIcons - `Earth`
  /// !["Image of Earth"](/Users/prad/Sonr/app/assets/images/svg/earth.svg)
  /// !["Image of Earth as Dots"](/Users/prad/Sonr/app/assets/images/svg/earth_dots.svg)
  Earth,

  /// ### SVGIcons - `Camera`
  /// !["Image of Camera"](/Users/prad/Sonr/app/assets/images/svg/camera.svg)
  /// !["Image of Camera as Dots"](/Users/prad/Sonr/app/assets/images/svg/camera_dots.svg)
  Camera,

  /// ### SVGIcons - `DocumentsBox`
  /// !["Image of DocumentsBox"](/Users/prad/Sonr/app/assets/images/svg/documents-box.svg)
  /// !["Image of DocumentsBox as Dots"](/Users/prad/Sonr/app/assets/images/svg/documents-box_dots.svg)
  DocumentsBox,

  /// ### SVGIcons - `AdminGroup`
  /// !["Image of AdminGroup"](/Users/prad/Sonr/app/assets/images/svg/admin-group.svg)
  /// !["Image of AdminGroup as Dots"](/Users/prad/Sonr/app/assets/images/svg/admin-group_dots.svg)
  AdminGroup,

  /// ### SVGIcons - `UserContact`
  /// !["Image of UserContact"](/Users/prad/Sonr/app/assets/images/svg/user-contact.svg)
  /// !["Image of UserContact as Dots"](/Users/prad/Sonr/app/assets/images/svg/user-contact_dots.svg)
  UserContact,

  /// ### SVGIcons - `Eye`
  /// !["Image of Eye"](/Users/prad/Sonr/app/assets/images/svg/eye.svg)
  /// !["Image of Eye as Dots"](/Users/prad/Sonr/app/assets/images/svg/eye_dots.svg)
  Eye,

  /// ### SVGIcons - `Anchor`
  /// !["Image of Anchor"](/Users/prad/Sonr/app/assets/images/svg/anchor.svg)
  /// !["Image of Anchor as Dots"](/Users/prad/Sonr/app/assets/images/svg/anchor_dots.svg)
  Anchor,

  /// ### SVGIcons - `DesktopBrowser`
  /// !["Image of DesktopBrowser"](/Users/prad/Sonr/app/assets/images/svg/desktop-browser.svg)
  /// !["Image of DesktopBrowser as Dots"](/Users/prad/Sonr/app/assets/images/svg/desktop-browser_dots.svg)
  DesktopBrowser,

  /// ### SVGIcons - `UserPortfolio`
  /// !["Image of UserPortfolio"](/Users/prad/Sonr/app/assets/images/svg/user-portfolio.svg)
  /// !["Image of UserPortfolio as Dots"](/Users/prad/Sonr/app/assets/images/svg/user-portfolio_dots.svg)
  UserPortfolio,

  /// ### SVGIcons - `Document`
  /// !["Image of Document"](/Users/prad/Sonr/app/assets/images/svg/document.svg)
  /// !["Image of Document as Dots"](/Users/prad/Sonr/app/assets/images/svg/document_dots.svg)
  Document,

  /// ### SVGIcons - `LobbyGroup`
  /// !["Image of LobbyGroup"](/Users/prad/Sonr/app/assets/images/svg/lobby-group.svg)
  /// !["Image of LobbyGroup as Dots"](/Users/prad/Sonr/app/assets/images/svg/lobby-group_dots.svg)
  LobbyGroup,

  /// ### SVGIcons - `InternetOfThings`
  /// !["Image of InternetOfThings"](/Users/prad/Sonr/app/assets/images/svg/internet-of-things.svg)
  /// !["Image of InternetOfThings as Dots"](/Users/prad/Sonr/app/assets/images/svg/internet-of-things_dots.svg)
  InternetOfThings,

  /// ### SVGIcons - `ArGlasses`
  /// !["Image of ArGlasses"](/Users/prad/Sonr/app/assets/images/svg/ar-glasses.svg)
  /// !["Image of ArGlasses as Dots"](/Users/prad/Sonr/app/assets/images/svg/ar-glasses_dots.svg)
  ArGlasses,

  /// ### SVGIcons - `DesktopLink`
  /// !["Image of DesktopLink"](/Users/prad/Sonr/app/assets/images/svg/desktop-link.svg)
  /// !["Image of DesktopLink as Dots"](/Users/prad/Sonr/app/assets/images/svg/desktop-link_dots.svg)
  DesktopLink,

  /// ### SVGIcons - `ArEarth`
  /// !["Image of ArEarth"](/Users/prad/Sonr/app/assets/images/svg/ar-earth.svg)
  /// !["Image of ArEarth as Dots"](/Users/prad/Sonr/app/assets/images/svg/ar-earth_dots.svg)
  ArEarth,

  /// ### SVGIcons - `PdfDocument`
  /// !["Image of PdfDocument"](/Users/prad/Sonr/app/assets/images/svg/pdf-document.svg)
  /// !["Image of PdfDocument as Dots"](/Users/prad/Sonr/app/assets/images/svg/pdf-document_dots.svg)
  PdfDocument,

  /// ### SVGIcons - `LockedFolder`
  /// !["Image of LockedFolder"](/Users/prad/Sonr/app/assets/images/svg/locked-folder.svg)
  /// !["Image of LockedFolder as Dots"](/Users/prad/Sonr/app/assets/images/svg/locked-folder_dots.svg)
  LockedFolder,

  /// ### SVGIcons - `Internet`
  /// !["Image of Internet"](/Users/prad/Sonr/app/assets/images/svg/internet.svg)
  /// !["Image of Internet as Dots"](/Users/prad/Sonr/app/assets/images/svg/internet_dots.svg)
  Internet,

  /// ### SVGIcons - `ContactCard`
  /// !["Image of ContactCard"](/Users/prad/Sonr/app/assets/images/svg/contact-card.svg)
  /// !["Image of ContactCard as Dots"](/Users/prad/Sonr/app/assets/images/svg/contact-card_dots.svg)
  ContactCard,

  /// ### SVGIcons - `MediaSelect`
  /// !["Image of MediaSelect"](/Users/prad/Sonr/app/assets/images/svg/media-select.svg)
  /// !["Image of MediaSelect as Dots"](/Users/prad/Sonr/app/assets/images/svg/media-select_dots.svg)
  MediaSelect,

  /// ### SVGIcons - `AppleWatch`
  /// !["Image of AppleWatch"](/Users/prad/Sonr/app/assets/images/svg/apple-watch.svg)
  /// !["Image of AppleWatch as Dots"](/Users/prad/Sonr/app/assets/images/svg/apple-watch_dots.svg)
  AppleWatch,

  /// ### SVGIcons - `AndroidWear`
  /// !["Image of AndroidWear"](/Users/prad/Sonr/app/assets/images/svg/android-wear.svg)
  /// !["Image of AndroidWear as Dots"](/Users/prad/Sonr/app/assets/images/svg/android-wear_dots.svg)
  AndroidWear,

  /// ### SVGIcons - `OldIPhone`
  /// !["Image of OldIPhone"](/Users/prad/Sonr/app/assets/images/svg/old-iphone.svg)
  /// !["Image of OldIPhone as Dots"](/Users/prad/Sonr/app/assets/images/svg/old-iphone_dots.svg)
  OldIPhone,

  /// ### SVGIcons - `CurrentIPhone`
  /// !["Image of CurrentIPhone"](/Users/prad/Sonr/app/assets/images/svg/current-iphone.svg)
  /// !["Image of CurrentIPhone as Dots"](/Users/prad/Sonr/app/assets/images/svg/current-iphone_dots.svg)
  CurrentIPhone,

  /// ### SVGIcons - `AndroidPhone`
  /// !["Image of AndroidPhone"](/Users/prad/Sonr/app/assets/images/svg/android-phone.svg)
  /// !["Image of AndroidPhone as Dots"](/Users/prad/Sonr/app/assets/images/svg/android-phone_dots.svg)
  AndroidPhone,

  /// ### SVGIcons - `IPad`
  /// !["Image of IPad"](/Users/prad/Sonr/app/assets/images/svg/ipad.svg)
  /// !["Image of IPad as Dots"](/Users/prad/Sonr/app/assets/images/svg/ipad_dots.svg)
  IPad,

  /// ### SVGIcons - `Laptop`
  /// !["Image of Laptop"](/Users/prad/Sonr/app/assets/images/svg/laptop.svg)
  /// !["Image of Laptop as Dots"](/Users/prad/Sonr/app/assets/images/svg/laptop_dots.svg)
  Laptop,

  /// ### SVGIcons - `Desktop`
  /// !["Image of Desktop"](/Users/prad/Sonr/app/assets/images/svg/desktop.svg)
  /// !["Image of Desktop as Dots"](/Users/prad/Sonr/app/assets/images/svg/desktop_dots.svg)
  Desktop,

  /// ### SVGIcons - `Devices`
  /// !["Image of Devices"](/Users/prad/Sonr/app/assets/images/svg/devices.svg)
  /// !["Image of Devices as Dots"](/Users/prad/Sonr/app/assets/images/svg/devices_dots.svg)
  Devices,

  /// ### SVGIcons - `Oculus`
  /// !["Image of Oculus"](/Users/prad/Sonr/app/assets/images/svg/oculus.svg)
  /// !["Image of Oculus as Dots"](/Users/prad/Sonr/app/assets/images/svg/oculus_dots.svg)
  Oculus,

  /// ### SVGIcons - `NintendoSwitch`
  /// !["Image of NintendoSwitch"](/Users/prad/Sonr/app/assets/images/svg/nintendo-switch.svg)
  /// !["Image of NintendoSwitch as Dots"](/Users/prad/Sonr/app/assets/images/svg/nintendo-switch_dots.svg)
  NintendoSwitch,

  /// ### SVGIcons - `Xbox`
  /// !["Image of Xbox"](/Users/prad/Sonr/app/assets/images/svg/xbox.svg)
  /// !["Image of Xbox as Dots"](/Users/prad/Sonr/app/assets/images/svg/xbox_dots.svg)
  Xbox,

  /// ### SVGIcons - `Playstation`
  /// !["Image of Playstation"](/Users/prad/Sonr/app/assets/images/svg/playstation.svg)
  /// !["Image of Playstation as Dots"](/Users/prad/Sonr/app/assets/images/svg/playstation_dots.svg)
  Playstation,
}
