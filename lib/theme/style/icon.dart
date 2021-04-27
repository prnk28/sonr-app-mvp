import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonr_core/sonr_core.dart';
import 'color.dart';
export 'package:flutter_gradients/flutter_gradients.dart';
import '../theme.dart';

extension MimeIcon on MIME_Type {
  Widget gradient({double size = 32}) {
    switch (this) {
      case MIME_Type.audio:
        return SonrIcons.Audio.gradientNamed(name: FlutterGradientNames.flyingLemon, size: size);
      case MIME_Type.image:
        return SonrIcons.Photos.gradientNamed(name: FlutterGradientNames.juicyCake, size: size);
      case MIME_Type.text:
        return SonrIcons.Document.gradientNamed(name: FlutterGradientNames.farawayRiver, size: size);
      case MIME_Type.video:
        return SonrIcons.Video.gradientNamed(name: FlutterGradientNames.nightCall, size: size);
      default:
        return SonrIcons.Unknown.gradientNamed(name: FlutterGradientNames.newRetrowave, size: size);
    }
  }

  Icon get black {
    switch (this) {
      case MIME_Type.audio:
        return SonrIcons.Audio.black;
      case MIME_Type.image:
        return SonrIcons.Photos.black;
      case MIME_Type.text:
        return SonrIcons.Document.black;
      case MIME_Type.video:
        return SonrIcons.Video.black;
      default:
        return SonrIcons.Unknown.black;
    }
  }

  Icon get white {
    switch (this) {
      case MIME_Type.audio:
        return SonrIcons.Audio.white;
      case MIME_Type.image:
        return SonrIcons.Photos.white;
      case MIME_Type.text:
        return SonrIcons.Document.white;
      case MIME_Type.video:
        return SonrIcons.Video.white;
      default:
        return SonrIcons.Unknown.white;
    }
  }
}

extension PayloadIcon on Payload {
  Widget gradient({double size = 32}) {
    if (this == Payload.CONTACT) {
      return SonrIcons.Avatar.gradientNamed(name: FlutterGradientNames.colorfulPeach, size: size);
    } else if (this == Payload.MEDIA) {
      return SonrIcons.Video.gradientNamed(name: FlutterGradientNames.loveKiss, size: size);
    } else if (this == Payload.URL) {
      return SonrIcons.Discover.gradientNamed(name: FlutterGradientNames.partyBliss, size: size);
    } else if (this == Payload.PDF) {
      return SonrIcons.PDF.gradientNamed(name: FlutterGradientNames.royalGarden, size: size);
    } else if (this == Payload.SPREADSHEET) {
      return SonrIcons.Spreadsheet.gradientNamed(name: FlutterGradientNames.itmeoBranding, size: size);
    } else if (this == Payload.PRESENTATION) {
      return SonrIcons.Presentation.gradientNamed(name: FlutterGradientNames.orangeJuice, size: size);
    } else if (this == Payload.TEXT) {
      return SonrIcons.Document.gradientNamed(name: FlutterGradientNames.spaceShift, size: size);
    } else {
      return SonrIcons.Unknown.gradientNamed(name: FlutterGradientNames.midnightBloom, size: size);
    }
  }

  Icon get black {
    if (this == Payload.CONTACT) {
      return SonrIcons.Avatar.black;
    } else if (this == Payload.MEDIA) {
      return SonrIcons.Video.black;
    } else if (this == Payload.URL) {
      return SonrIcons.Discover.black;
    } else if (this == Payload.PDF) {
      return SonrIcons.PDF.black;
    } else if (this == Payload.SPREADSHEET) {
      return SonrIcons.Spreadsheet.black;
    } else if (this == Payload.PRESENTATION) {
      return SonrIcons.Presentation.black;
    } else if (this == Payload.TEXT) {
      return SonrIcons.Document.black;
    } else {
      return SonrIcons.Unknown.black;
    }
  }

  Icon get white {
    if (this == Payload.CONTACT) {
      return SonrIcons.Avatar.white;
    } else if (this == Payload.MEDIA) {
      return SonrIcons.Video.white;
    } else if (this == Payload.URL) {
      return SonrIcons.Discover.white;
    } else if (this == Payload.PDF) {
      return SonrIcons.PDF.white;
    } else if (this == Payload.SPREADSHEET) {
      return SonrIcons.Spreadsheet.white;
    } else if (this == Payload.PRESENTATION) {
      return SonrIcons.Presentation.white;
    } else if (this == Payload.TEXT) {
      return SonrIcons.Document.white;
    } else {
      return SonrIcons.Unknown.white;
    }
  }
}

extension PlatformIcon on Platform {
  ///-- Returns Icon Widget -- //
  Widget gradient({double size = 32}) {
    switch (this) {
      case Platform.Android:
        return SonrIcons.Android.gradientNamed(name: FlutterGradientNames.glassWater, size: size);
      case Platform.IOS:
        return SonrIcons.IPhone.gradientNamed(name: FlutterGradientNames.glassWater, size: size);
      case Platform.MacOS:
        return SonrIcons.IMac.gradientNamed(name: FlutterGradientNames.glassWater, size: size);
      case Platform.Windows:
        return SonrIcons.Windows.gradientNamed(name: FlutterGradientNames.glassWater, size: size);
      default:
        return SonrIcons.Unknown.gradientNamed(name: FlutterGradientNames.glassWater, size: size);
    }
  }

  Icon black({double size = 32}) {
    switch (this) {
      case Platform.Android:
        return SonrIcons.Android.blackWith(size: size);
      case Platform.IOS:
        return SonrIcons.IPhone.blackWith(size: size);
      case Platform.MacOS:
        return SonrIcons.IMac.blackWith(size: size);
      case Platform.Windows:
        return SonrIcons.Windows.blackWith(size: size);
      default:
        return SonrIcons.Unknown.blackWith(size: size);
    }
  }

  Icon grey({double size = 32}) {
    switch (this) {
      case Platform.Android:
        return SonrIcons.Android.greyWith(size: size);
      case Platform.IOS:
        return SonrIcons.IPhone.greyWith(size: size);
      case Platform.MacOS:
        return SonrIcons.IMac.greyWith(size: size);
      case Platform.Windows:
        return SonrIcons.Windows.greyWith(size: size);
      default:
        return SonrIcons.Unknown.greyWith(size: size);
    }
  }

  Icon white({double size = 32}) {
    switch (this) {
      case Platform.Android:
        return SonrIcons.Android.whiteWith(size: size);
      case Platform.IOS:
        return SonrIcons.IPhone.whiteWith(size: size);
      case Platform.MacOS:
        return SonrIcons.IMac.whiteWith(size: size);
      case Platform.Windows:
        return SonrIcons.Windows.whiteWith(size: size);
      default:
        return SonrIcons.Unknown.whiteWith(size: size);
    }
  }
}

extension SocialIconUtils on Contact_SocialTile_Provider {
  Widget gradient({double size = 32}) {
    switch (this) {
      case Contact_SocialTile_Provider.Snapchat:
        return SonrIcons.Snapchat.gradientNamed(name: FlutterGradientNames.sunnyMorning, size: size);
      case Contact_SocialTile_Provider.Github:
        return SonrIcons.Github.gradientNamed(name: FlutterGradientNames.solidStone, size: size);
      case Contact_SocialTile_Provider.Facebook:
        return SonrIcons.Facebook.gradientNamed(name: FlutterGradientNames.perfectBlue, size: size);
      case Contact_SocialTile_Provider.Medium:
        return SonrIcons.Medium.gradientNamed(name: FlutterGradientNames.eternalConstance, size: size);
      case Contact_SocialTile_Provider.YouTube:
        return SonrIcons.YouTube.gradientNamed(name: FlutterGradientNames.loveKiss, size: size);
      case Contact_SocialTile_Provider.Twitter:
        return SonrIcons.Twitter.gradientNamed(name: FlutterGradientNames.partyBliss, size: size);
      case Contact_SocialTile_Provider.Instagram:
        return SonrIcons.Instagram.gradientNamed(name: FlutterGradientNames.ripeMalinka, size: size);
      case Contact_SocialTile_Provider.TikTok:
        return SonrIcons.Tiktok.gradientNamed(name: FlutterGradientNames.premiumDark, size: size);
      default:
        return SonrIcons.Spotify.gradientNamed(name: FlutterGradientNames.newLife, size: size);
    }
  }

  Icon get black {
    switch (this) {
      case Contact_SocialTile_Provider.Snapchat:
        return SonrIcons.Snapchat.blackWith(size: 30);
      case Contact_SocialTile_Provider.Github:
        return SonrIcons.Github.blackWith(size: 30);
      case Contact_SocialTile_Provider.Facebook:
        return SonrIcons.Facebook.blackWith(size: 30);
      case Contact_SocialTile_Provider.Medium:
        return SonrIcons.Medium.blackWith(size: 30);
      case Contact_SocialTile_Provider.YouTube:
        return SonrIcons.YouTube.blackWith(size: 30);
      case Contact_SocialTile_Provider.Twitter:
        return SonrIcons.Twitter.blackWith(size: 30);
      case Contact_SocialTile_Provider.Instagram:
        return SonrIcons.Instagram.blackWith(size: 30);
      case Contact_SocialTile_Provider.TikTok:
        return SonrIcons.Tiktok.blackWith(size: 30);
      default:
        return SonrIcons.Spotify.blackWith(size: 30);
    }
  }

  Icon get white {
    switch (this) {
      case Contact_SocialTile_Provider.Snapchat:
        return SonrIcons.Snapchat.whiteWith(size: 30);
      case Contact_SocialTile_Provider.Github:
        return SonrIcons.Github.whiteWith(size: 30);
      case Contact_SocialTile_Provider.Facebook:
        return SonrIcons.Facebook.whiteWith(size: 30);
      case Contact_SocialTile_Provider.Medium:
        return SonrIcons.Medium.whiteWith(size: 30);
      case Contact_SocialTile_Provider.YouTube:
        return SonrIcons.YouTube.whiteWith(size: 30);
      case Contact_SocialTile_Provider.Twitter:
        return SonrIcons.Twitter.whiteWith(size: 30);
      case Contact_SocialTile_Provider.Instagram:
        return SonrIcons.Instagram.whiteWith(size: 30);
      case Contact_SocialTile_Provider.TikTok:
        return SonrIcons.Tiktok.whiteWith(size: 30);
      default:
        return SonrIcons.Spotify.whiteWith(size: 30);
    }
  }
}

extension DesignIcon on IconData {
  Icon get black {
    return Icon(
      this,
      size: 24,
      color: SonrColor.Black,
    );
  }

  Widget blackWith({double size = 24}) {
    return Icon(
      this,
      size: size,
      color: SonrColor.Black,
    );
  }

  Icon get grey {
    return Icon(
      this,
      size: 24,
      color: SonrColor.Grey,
    );
  }

  Widget greyWith({double size = 24}) {
    return Icon(
      this,
      size: size,
      color: SonrColor.Grey,
    );
  }

  Icon get white {
    return Icon(
      this,
      size: 24,
      color: SonrColor.White,
    );
  }

  Widget whiteWith({double size = 24}) {
    return Icon(
      this,
      size: size,
      color: SonrColor.White,
    );
  }

  Widget gradient({Gradient gradient, double size = 32}) {
    return ShaderMask(
      blendMode: BlendMode.modulate,
      shaderCallback: (bounds) {
        var grad = gradient ?? SonrGradient.Primary;
        return grad.createShader(bounds);
      },
      child: Icon(
        this,
        size: size,
        color: Colors.white,
      ),
    );
  }

  Widget gradientNamed({@required FlutterGradientNames name, double size = 32, Key key}) {
    return ShaderMask(
      key: key,
      blendMode: BlendMode.modulate,
      shaderCallback: (bounds) {
        return FlutterGradients.findByName(name, tileMode: TileMode.clamp).createShader(bounds);
      },
      child: Icon(
        this,
        size: size,
        color: Colors.white,
      ),
    );
  }
}

// ^ Sonr Icon Class ^ //

class SonrIcons {
  // * ^.*(\s+([a-zA-Z]+\s+)+).*[a-zA-Z]+.*[a-zA-Z]+.*[a-zA-Z]+.*$ > Regex
  // Substitution: /// Sonricons - $2 ![Icon of $2](/Users/prad/Sonr/docs/icons/PNG/$2.png) \n static const IconData $2 = IconData(0xe914, fontFamily: _fontFamily);
  // Expression for Comment Generation * //
  //! Dont use underscores for fonts //

  SonrIcons._();
  static const String _fontFamily = 'SonrIcons';

  /// Sonricons - Archive  ![Icon of Archive ](/Users/prad/Sonr/docs/icons/PNG/Archive.png)
  static const IconData Archive = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - ATSign  ![Icon of ATSign ](/Users/prad/Sonr/docs/icons/PNG/ATSign.png)
  static const IconData ATSign = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Barcode  ![Icon of Barcode ](/Users/prad/Sonr/docs/icons/PNG/Barcode.png)
  static const IconData Barcode = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Camera  ![Icon of Camera ](/Users/prad/Sonr/docs/icons/PNG/Camera.png)
  static const IconData Camera = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Capture  ![Icon of Capture ](/Users/prad/Sonr/docs/icons/PNG/Capture.png)
  static const IconData Capture = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Clear  ![Icon of Clear ](/Users/prad/Sonr/docs/icons/PNG/Clear.png)
  static const IconData Clear = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Compass  ![Icon of Compass ](/Users/prad/Sonr/docs/icons/PNG/Compass.png)
  static const IconData Compass = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Database  ![Icon of Database ](/Users/prad/Sonr/docs/icons/PNG/Database.png)
  static const IconData Database = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Diagram  ![Icon of Diagram ](/Users/prad/Sonr/docs/icons/PNG/Diagram.png)
  static const IconData Diagram = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Diamond  ![Icon of Diamond ](/Users/prad/Sonr/docs/icons/PNG/Diamond.png)
  static const IconData Diamond = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Gamepad  ![Icon of Gamepad ](/Users/prad/Sonr/docs/icons/PNG/Gamepad.png)
  static const IconData Gamepad = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Heart  ![Icon of Heart ](/Users/prad/Sonr/docs/icons/PNG/Heart.png)
  static const IconData Heart = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Help  ![Icon of Help ](/Users/prad/Sonr/docs/icons/PNG/Help.png)
  static const IconData Help = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - NoConnection  ![Icon of NoConnection ](/Users/prad/Sonr/docs/icons/PNG/NoConnection.png)
  static const IconData NoConnection = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Pause  ![Icon of Pause ](/Users/prad/Sonr/docs/icons/PNG/Pause.png)
  static const IconData Pause = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - WifiOff  ![Icon of WifiOff ](/Users/prad/Sonr/docs/icons/PNG/WifiOff.png)
  static const IconData WifiOff = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Alexa  ![Icon of Alexa ](/Users/prad/Sonr/docs/icons/PNG/Alexa.png)
  static const IconData Alexa = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - AndroidClassic  ![Icon of AndroidClassic ](/Users/prad/Sonr/docs/icons/PNG/AndroidClassic.png)
  static const IconData AndroidClassic = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - GoogleHome  ![Icon of GoogleHome ](/Users/prad/Sonr/docs/icons/PNG/GoogleHome.png)
  static const IconData GoogleHome = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - IMac  ![Icon of IMac ](/Users/prad/Sonr/docs/icons/PNG/IMac.png)
  static const IconData IMac = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - IPad  ![Icon of IPad ](/Users/prad/Sonr/docs/icons/PNG/IPad.png)
  static const IconData IPad = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - IPadClassic  ![Icon of IPadClassic ](/Users/prad/Sonr/docs/icons/PNG/IPadClassic.png)
  static const IconData IPadClassic = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - IPhoneClassic  ![Icon of IPhoneClassic ](/Users/prad/Sonr/docs/icons/PNG/IPhoneClassic.png)
  static const IconData IPhoneClassic = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - LinuxDesktop  ![Icon of LinuxDesktop ](/Users/prad/Sonr/docs/icons/PNG/LinuxDesktop.png)
  static const IconData LinuxDesktop = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - LinuxLaptop  ![Icon of LinuxLaptop ](/Users/prad/Sonr/docs/icons/PNG/LinuxLaptop.png)
  static const IconData LinuxLaptop = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Macbook  ![Icon of Macbook ](/Users/prad/Sonr/docs/icons/PNG/Macbook.png)
  static const IconData Macbook = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - NintendoSwitch  ![Icon of NintendoSwitch ](/Users/prad/Sonr/docs/icons/PNG/NintendoSwitch.png)
  static const IconData NintendoSwitch = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - WatchAndroid  ![Icon of WatchAndroid ](/Users/prad/Sonr/docs/icons/PNG/WatchAndroid.png)
  static const IconData WatchAndroid = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - WatchApple  ![Icon of WatchApple ](/Users/prad/Sonr/docs/icons/PNG/WatchApple.png)
  static const IconData WatchApple = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - WindowsDesktop  ![Icon of WindowsDesktop ](/Users/prad/Sonr/docs/icons/PNG/WindowsDesktop.png)
  static const IconData WindowsDesktop = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - WindowsLaptop  ![Icon of WindowsLaptop ](/Users/prad/Sonr/docs/icons/PNG/WindowsLaptop.png)
  static const IconData WindowsLaptop = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - AddFolder  ![Icon of AddFolder ](/Users/prad/Sonr/docs/icons/PNG/AddFolder.png)
  static const IconData AddFolder = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - ContactCard  ![Icon of ContactCard ](/Users/prad/Sonr/docs/icons/PNG/ContactCard.png)
  static const IconData ContactCard = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - DeleteFolder  ![Icon of DeleteFolder ](/Users/prad/Sonr/docs/icons/PNG/DeleteFolder.png)
  static const IconData DeleteFolder = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Message  ![Icon of Message ](/Users/prad/Sonr/docs/icons/PNG/Message.png)
  static const IconData Message = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Unknown  ![Icon of Unknown ](/Users/prad/Sonr/docs/icons/PNG/Unknown.png)
  static const IconData Unknown = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Refresh  ![Icon of Refresh ](/Users/prad/Sonr/docs/icons/PNG/Refresh.png)
  static const IconData Refresh = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Open  ![Icon of Open ](/Users/prad/Sonr/docs/icons/PNG/Open.png)
  static const IconData Open = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Safe  ![Icon of Safe ](/Users/prad/Sonr/docs/icons/PNG/Safe.png)
  static const IconData Safe = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Sale  ![Icon of Sale ](/Users/prad/Sonr/docs/icons/PNG/Sale.png)
  static const IconData Sale = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Science  ![Icon of Science ](/Users/prad/Sonr/docs/icons/PNG/Science.png)
  static const IconData Science = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Sync  ![Icon of Sync ](/Users/prad/Sonr/docs/icons/PNG/Sync.png)
  static const IconData Sync = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Transform  ![Icon of Transform ](/Users/prad/Sonr/docs/icons/PNG/Transform.png)
  static const IconData Transform = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Apple  ![Icon of Apple ](/Users/prad/Sonr/docs/icons/PNG/Apple.png)
  static const IconData Apple = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Browser  ![Icon of Browser ](/Users/prad/Sonr/docs/icons/PNG/Browser.png)
  static const IconData Browser = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - ColorPalette  ![Icon of ColorPalette ](/Users/prad/Sonr/docs/icons/PNG/ColorPalette.png)
  static const IconData ColorPalette = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Clip  ![Icon of Clip ](/Users/prad/Sonr/docs/icons/PNG/Clip.png)
  static const IconData Clip = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Like  ![Icon of Like ](/Users/prad/Sonr/docs/icons/PNG/Like.png)
  static const IconData Like = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Album  ![Icon of Album ](/Users/prad/Sonr/docs/icons/PNG/Album.png)
  static const IconData Album = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Alert  ![Icon of Alert ](/Users/prad/Sonr/docs/icons/PNG/Alert.png)
  static const IconData Alert = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - CircleDown  ![Icon of CircleDown ](/Users/prad/Sonr/docs/icons/PNG/CircleDown.png)
  static const IconData CircleDown = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - CircleLeft  ![Icon of CircleLeft ](/Users/prad/Sonr/docs/icons/PNG/CircleLeft.png)
  static const IconData CircleLeft = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - CircleRight  ![Icon of CircleRight ](/Users/prad/Sonr/docs/icons/PNG/CircleRight.png)
  static const IconData CircleRight = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - CircleTop  ![Icon of CircleTop ](/Users/prad/Sonr/docs/icons/PNG/CircleTop.png)
  static const IconData CircleTop = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Bolt  ![Icon of Bolt ](/Users/prad/Sonr/docs/icons/PNG/Bolt.png)
  static const IconData Bolt = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Burger  ![Icon of Burger ](/Users/prad/Sonr/docs/icons/PNG/Burger.png)
  static const IconData Burger = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Lens  ![Icon of Lens ](/Users/prad/Sonr/docs/icons/PNG/Lens.png)
  static const IconData Lens = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Clock  ![Icon of Clock ](/Users/prad/Sonr/docs/icons/PNG/Clock.png)
  static const IconData Clock = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Crown  ![Icon of Crown ](/Users/prad/Sonr/docs/icons/PNG/Crown.png)
  static const IconData Crown = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Exchange  ![Icon of Exchange ](/Users/prad/Sonr/docs/icons/PNG/Exchange.png)
  static const IconData Exchange = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Eye  ![Icon of Eye ](/Users/prad/Sonr/docs/icons/PNG/Eye.png)
  static const IconData Eye = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - FaceID  ![Icon of FaceID ](/Users/prad/Sonr/docs/icons/PNG/FaceID.png)
  static const IconData FaceID = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Hdd  ![Icon of Hdd ](/Users/prad/Sonr/docs/icons/PNG/Hdd.png)
  static const IconData Hdd = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Info  ![Icon of Info ](/Users/prad/Sonr/docs/icons/PNG/Info.png)
  static const IconData Info = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Pen  ![Icon of Pen ](/Users/prad/Sonr/docs/icons/PNG/Pen.png)
  static const IconData Pen = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Rocket  ![Icon of Rocket ](/Users/prad/Sonr/docs/icons/PNG/Rocket.png)
  static const IconData Rocket = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Star  ![Icon of Star ](/Users/prad/Sonr/docs/icons/PNG/Star.png)
  static const IconData Star = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Ufo  ![Icon of Ufo ](/Users/prad/Sonr/docs/icons/PNG/Ufo.png)
  static const IconData Ufo = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Upload  ![Icon of Upload ](/Users/prad/Sonr/docs/icons/PNG/Upload.png)
  static const IconData Upload = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - ZoomMinus  ![Icon of ZoomMinus ](/Users/prad/Sonr/docs/icons/PNG/ZoomMinus.png)
  static const IconData ZoomMinus = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - ZoomPlus  ![Icon of ZoomPlus ](/Users/prad/Sonr/docs/icons/PNG/ZoomPlus.png)
  static const IconData ZoomPlus = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - of  ![Icon of of ](/Users/prad/Sonr/docs/icons/PNG/of.png)
  static const IconData of = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Audio  ![Icon of Audio ](/Users/prad/Sonr/docs/icons/PNG/Audio.png)
  static const IconData Audio = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Yoda  ![Icon of Yoda ](/Users/prad/Sonr/docs/icons/PNG/Yoda.png)
  static const IconData Yoda = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Cancel  ![Icon of Cancel ](/Users/prad/Sonr/docs/icons/PNG/Cancel.png)
  static const IconData Cancel = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Plus  ![Icon of Plus ](/Users/prad/Sonr/docs/icons/PNG/Plus.png)
  static const IconData Plus = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Copy  ![Icon of Copy ](/Users/prad/Sonr/docs/icons/PNG/Copy.png)
  static const IconData Copy = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Panorama  ![Icon of Panorama ](/Users/prad/Sonr/docs/icons/PNG/Panorama.png)
  static const IconData Panorama = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - WebApp  ![Icon of WebApp ](/Users/prad/Sonr/docs/icons/PNG/WebApp.png)
  static const IconData WebApp = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - DarthVader  ![Icon of DarthVader ](/Users/prad/Sonr/docs/icons/PNG/DarthVader.png)
  static const IconData DarthVader = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - PDF  ![Icon of PDF ](/Users/prad/Sonr/docs/icons/PNG/PDF.png)
  static const IconData PDF = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - IPhone  ![Icon of IPhone ](/Users/prad/Sonr/docs/icons/PNG/IPhone.png)
  static const IconData IPhone = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Android  ![Icon of Android ](/Users/prad/Sonr/docs/icons/PNG/Android.png)
  static const IconData Android = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Stop  ![Icon of Stop ](/Users/prad/Sonr/docs/icons/PNG/Stop.png)
  static const IconData Stop = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Anchor  ![Icon of Anchor ](/Users/prad/Sonr/docs/icons/PNG/Anchor.png)
  static const IconData Anchor = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - CheckAll  ![Icon of CheckAll ](/Users/prad/Sonr/docs/icons/PNG/CheckAll.png)
  static const IconData CheckAll = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Close  ![Icon of Close ](/Users/prad/Sonr/docs/icons/PNG/Close.png)
  static const IconData Close = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Gift  ![Icon of Gift ](/Users/prad/Sonr/docs/icons/PNG/Gift.png)
  static const IconData Gift = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Scan  ![Icon of Scan ](/Users/prad/Sonr/docs/icons/PNG/Scan.png)
  static const IconData Scan = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Server  ![Icon of Server ](/Users/prad/Sonr/docs/icons/PNG/Server.png)
  static const IconData Server = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Ship  ![Icon of Ship ](/Users/prad/Sonr/docs/icons/PNG/Ship.png)
  static const IconData Ship = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Tag  ![Icon of Tag ](/Users/prad/Sonr/docs/icons/PNG/Tag.png)
  static const IconData Tag = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - TrendUp  ![Icon of TrendUp ](/Users/prad/Sonr/docs/icons/PNG/TrendUp.png)
  static const IconData TrendUp = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Update  ![Icon of Update ](/Users/prad/Sonr/docs/icons/PNG/Update.png)
  static const IconData Update = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Facebook  ![Icon of Facebook ](/Users/prad/Sonr/docs/icons/PNG/Facebook.png)
  static const IconData Facebook = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Files  ![Icon of Files ](/Users/prad/Sonr/docs/icons/PNG/Files.png)
  static const IconData Files = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Video  ![Icon of Video ](/Users/prad/Sonr/docs/icons/PNG/Video.png)
  static const IconData Video = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Internet  ![Icon of Internet ](/Users/prad/Sonr/docs/icons/PNG/Internet.png)
  static const IconData Internet = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Link  ![Icon of Link ](/Users/prad/Sonr/docs/icons/PNG/Link.png)
  static const IconData Link = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Linkedin  ![Icon of Linkedin ](/Users/prad/Sonr/docs/icons/PNG/Linkedin.png)
  static const IconData Linkedin = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Remote  ![Icon of Remote ](/Users/prad/Sonr/docs/icons/PNG/Remote.png)
  static const IconData Remote = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Photos  ![Icon of Photos ](/Users/prad/Sonr/docs/icons/PNG/Photos.png)
  static const IconData Photos = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Activity  ![Icon of Activity ](/Users/prad/Sonr/docs/icons/PNG/Activity.png)
  static const IconData Activity = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Bug  ![Icon of Bug ](/Users/prad/Sonr/docs/icons/PNG/Bug.png)
  static const IconData Bug = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Check  ![Icon of Check ](/Users/prad/Sonr/docs/icons/PNG/Check.png)
  static const IconData Check = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Backward  ![Icon of Backward ](/Users/prad/Sonr/docs/icons/PNG/Backward.png)
  static const IconData Backward = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Down  ![Icon of Down ](/Users/prad/Sonr/docs/icons/PNG/Down.png)
  static const IconData Down = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Forward  ![Icon of Forward ](/Users/prad/Sonr/docs/icons/PNG/Forward.png)
  static const IconData Forward = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Up  ![Icon of Up ](/Users/prad/Sonr/docs/icons/PNG/Up.png)
  static const IconData Up = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Collapse  ![Icon of Collapse ](/Users/prad/Sonr/docs/icons/PNG/Collapse.png)
  static const IconData Collapse = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Screenshot  ![Icon of Screenshot ](/Users/prad/Sonr/docs/icons/PNG/Screenshot.png)
  static const IconData Screenshot = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Download  ![Icon of Download ](/Users/prad/Sonr/docs/icons/PNG/Download.png)
  static const IconData Download = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Grid  ![Icon of Grid ](/Users/prad/Sonr/docs/icons/PNG/Grid.png)
  static const IconData Grid = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Group  ![Icon of Group ](/Users/prad/Sonr/docs/icons/PNG/Group.png)
  static const IconData Group = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Hide  ![Icon of Hide ](/Users/prad/Sonr/docs/icons/PNG/Hide.png)
  static const IconData Hide = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Image  ![Icon of Image ](/Users/prad/Sonr/docs/icons/PNG/Image.png)
  static const IconData Image = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Inbox  ![Icon of Inbox ](/Users/prad/Sonr/docs/icons/PNG/Inbox.png)
  static const IconData Inbox = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Instagram  ![Icon of Instagram ](/Users/prad/Sonr/docs/icons/PNG/Instagram.png)
  static const IconData Instagram = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Layers  ![Icon of Layers ](/Users/prad/Sonr/docs/icons/PNG/Layers.png)
  static const IconData Layers = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Leaderboard  ![Icon of Leaderboard ](/Users/prad/Sonr/docs/icons/PNG/Leaderboard.png)
  static const IconData Leaderboard = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Spreadsheet  ![Icon of Spreadsheet ](/Users/prad/Sonr/docs/icons/PNG/Spreadsheet.png)
  static const IconData Spreadsheet = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Login  ![Icon of Login ](/Users/prad/Sonr/docs/icons/PNG/Login.png)
  static const IconData Login = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Logout  ![Icon of Logout ](/Users/prad/Sonr/docs/icons/PNG/Logout.png)
  static const IconData Logout = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Map  ![Icon of Map ](/Users/prad/Sonr/docs/icons/PNG/Map.png)
  static const IconData Map = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Medal  ![Icon of Medal ](/Users/prad/Sonr/docs/icons/PNG/Medal.png)
  static const IconData Medal = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Moon  ![Icon of Moon ](/Users/prad/Sonr/docs/icons/PNG/Moon.png)
  static const IconData Moon = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - MoreHorizontal  ![Icon of MoreHorizontal ](/Users/prad/Sonr/docs/icons/PNG/MoreHorizontal.png)
  static const IconData MoreHorizontal = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - MoreVertical  ![Icon of MoreVertical ](/Users/prad/Sonr/docs/icons/PNG/MoreVertical.png)
  static const IconData MoreVertical = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - User  ![Icon of User ](/Users/prad/Sonr/docs/icons/PNG/User.png)
  static const IconData User = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Presentation  ![Icon of Presentation ](/Users/prad/Sonr/docs/icons/PNG/Presentation.png)
  static const IconData Presentation = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Avatar  ![Icon of Avatar ](/Users/prad/Sonr/docs/icons/PNG/Avatar.png)
  static const IconData Avatar = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Reload  ![Icon of Reload ](/Users/prad/Sonr/docs/icons/PNG/Reload.png)
  static const IconData Reload = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Search  ![Icon of Search ](/Users/prad/Sonr/docs/icons/PNG/Search.png)
  static const IconData Search = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Settings  ![Icon of Settings ](/Users/prad/Sonr/docs/icons/PNG/Settings.png)
  static const IconData Settings = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Show  ![Icon of Show ](/Users/prad/Sonr/docs/icons/PNG/Show.png)
  static const IconData Show = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Expand  ![Icon of Expand ](/Users/prad/Sonr/docs/icons/PNG/Expand.png)
  static const IconData Expand = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - SmartWatch  ![Icon of SmartWatch ](/Users/prad/Sonr/docs/icons/PNG/SmartWatch.png)
  static const IconData SmartWatch = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Snapchat  ![Icon of Snapchat ](/Users/prad/Sonr/docs/icons/PNG/Snapchat.png)
  static const IconData Snapchat = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Sun  ![Icon of Sun ](/Users/prad/Sonr/docs/icons/PNG/Sun.png)
  static const IconData Sun = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Twitter  ![Icon of Twitter ](/Users/prad/Sonr/docs/icons/PNG/Twitter.png)
  static const IconData Twitter = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Undo  ![Icon of Undo ](/Users/prad/Sonr/docs/icons/PNG/Undo.png)
  static const IconData Undo = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Warning  ![Icon of Warning ](/Users/prad/Sonr/docs/icons/PNG/Warning.png)
  static const IconData Warning = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Wind  ![Icon of Wind ](/Users/prad/Sonr/docs/icons/PNG/Wind.png)
  static const IconData Wind = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Zap  ![Icon of Zap ](/Users/prad/Sonr/docs/icons/PNG/Zap.png)
  static const IconData Zap = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - AndroidLogo  ![Icon of AndroidLogo ](/Users/prad/Sonr/docs/icons/PNG/AndroidLogo.png)
  static const IconData AndroidLogo = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Github  ![Icon of Github ](/Users/prad/Sonr/docs/icons/PNG/Github.png)
  static const IconData Github = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Medium  ![Icon of Medium ](/Users/prad/Sonr/docs/icons/PNG/Medium.png)
  static const IconData Medium = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Spotify  ![Icon of Spotify ](/Users/prad/Sonr/docs/icons/PNG/Spotify.png)
  static const IconData Spotify = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Tiktok  ![Icon of Tiktok ](/Users/prad/Sonr/docs/icons/PNG/Tiktok.png)
  static const IconData Tiktok = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Windows  ![Icon of Windows ](/Users/prad/Sonr/docs/icons/PNG/Windows.png)
  static const IconData Windows = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - YouTube  ![Icon of YouTube ](/Users/prad/Sonr/docs/icons/PNG/YouTube.png)
  static const IconData YouTube = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Add  ![Icon of Add ](/Users/prad/Sonr/docs/icons/PNG/Add.png)
  static const IconData Add = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - BlockedAccount  ![Icon of BlockedAccount ](/Users/prad/Sonr/docs/icons/PNG/BlockedAccount.png)
  static const IconData BlockedAccount = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - BlockedUser  ![Icon of BlockedUser ](/Users/prad/Sonr/docs/icons/PNG/BlockedUser.png)
  static const IconData BlockedUser = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - CallIn  ![Icon of CallIn ](/Users/prad/Sonr/docs/icons/PNG/CallIn.png)
  static const IconData CallIn = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - CallRinging  ![Icon of CallRinging ](/Users/prad/Sonr/docs/icons/PNG/CallRinging.png)
  static const IconData CallRinging = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Call  ![Icon of Call ](/Users/prad/Sonr/docs/icons/PNG/Call.png)
  static const IconData Call = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - CanceledCall  ![Icon of CanceledCall ](/Users/prad/Sonr/docs/icons/PNG/CanceledCall.png)
  static const IconData CanceledCall = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Cart  ![Icon of Cart ](/Users/prad/Sonr/docs/icons/PNG/Cart.png)
  static const IconData Cart = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Category  ![Icon of Category ](/Users/prad/Sonr/docs/icons/PNG/Category.png)
  static const IconData Category = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Caution  ![Icon of Caution ](/Users/prad/Sonr/docs/icons/PNG/Caution.png)
  static const IconData Caution = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Coupon  ![Icon of Coupon ](/Users/prad/Sonr/docs/icons/PNG/Coupon.png)
  static const IconData Coupon = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Discount  ![Icon of Discount ](/Users/prad/Sonr/docs/icons/PNG/Discount.png)
  static const IconData Discount = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Dislike  ![Icon of Dislike ](/Users/prad/Sonr/docs/icons/PNG/Dislike.png)
  static const IconData Dislike = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Edit  ![Icon of Edit ](/Users/prad/Sonr/docs/icons/PNG/Edit.png)
  static const IconData Edit = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Favorite  ![Icon of Favorite ](/Users/prad/Sonr/docs/icons/PNG/Favorite.png)
  static const IconData Favorite = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Hastag  ![Icon of Hastag ](/Users/prad/Sonr/docs/icons/PNG/Hastag.png)
  static const IconData Hastag = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Key  ![Icon of Key ](/Users/prad/Sonr/docs/icons/PNG/Key.png)
  static const IconData Key = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Liked  ![Icon of Liked ](/Users/prad/Sonr/docs/icons/PNG/Liked.png)
  static const IconData Liked = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Location  ![Icon of Location ](/Users/prad/Sonr/docs/icons/PNG/Location.png)
  static const IconData Location = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Muted  ![Icon of Muted ](/Users/prad/Sonr/docs/icons/PNG/Muted.png)
  static const IconData Muted = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Pin  ![Icon of Pin ](/Users/prad/Sonr/docs/icons/PNG/Pin.png)
  static const IconData Pin = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Play  ![Icon of Play ](/Users/prad/Sonr/docs/icons/PNG/Play.png)
  static const IconData Play = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Pocket  ![Icon of Pocket ](/Users/prad/Sonr/docs/icons/PNG/Pocket.png)
  static const IconData Pocket = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Seen  ![Icon of Seen ](/Users/prad/Sonr/docs/icons/PNG/Seen.png)
  static const IconData Seen = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Share  ![Icon of Share ](/Users/prad/Sonr/docs/icons/PNG/Share.png)
  static const IconData Share = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Silent  ![Icon of Silent ](/Users/prad/Sonr/docs/icons/PNG/Silent.png)
  static const IconData Silent = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - SoundOne  ![Icon of SoundOne ](/Users/prad/Sonr/docs/icons/PNG/SoundOne.png)
  static const IconData SoundOne = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - SoundTwo  ![Icon of SoundTwo ](/Users/prad/Sonr/docs/icons/PNG/SoundTwo.png)
  static const IconData SoundTwo = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - SwitchCamera  ![Icon of SwitchCamera ](/Users/prad/Sonr/docs/icons/PNG/SwitchCamera.png)
  static const IconData SwitchCamera = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Ticket  ![Icon of Ticket ](/Users/prad/Sonr/docs/icons/PNG/Ticket.png)
  static const IconData Ticket = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - VideoCamera  ![Icon of VideoCamera ](/Users/prad/Sonr/docs/icons/PNG/VideoCamera.png)
  static const IconData VideoCamera = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - About  ![Icon of About ](/Users/prad/Sonr/docs/icons/PNG/About.png)
  static const IconData About = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - AddFile  ![Icon of AddFile ](/Users/prad/Sonr/docs/icons/PNG/AddFile.png)
  static const IconData AddFile = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Chat  ![Icon of Chat ](/Users/prad/Sonr/docs/icons/PNG/Chat.png)
  static const IconData Chat = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Checklist  ![Icon of Checklist ](/Users/prad/Sonr/docs/icons/PNG/Checklist.png)
  static const IconData Checklist = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - CircleClock  ![Icon of CircleClock ](/Users/prad/Sonr/docs/icons/PNG/CircleClock.png)
  static const IconData CircleClock = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Discover  ![Icon of Discover ](/Users/prad/Sonr/docs/icons/PNG/Discover.png)
  static const IconData Discover = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - DownloadFile  ![Icon of DownloadFile ](/Users/prad/Sonr/docs/icons/PNG/DownloadFile.png)
  static const IconData DownloadFile = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Filter  ![Icon of Filter ](/Users/prad/Sonr/docs/icons/PNG/Filter.png)
  static const IconData Filter = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Folder  ![Icon of Folder ](/Users/prad/Sonr/docs/icons/PNG/Folder.png)
  static const IconData Folder = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Home  ![Icon of Home ](/Users/prad/Sonr/docs/icons/PNG/Home.png)
  static const IconData Home = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Calendar  ![Icon of Calendar ](/Users/prad/Sonr/docs/icons/PNG/Calendar.png)
  static const IconData Calendar = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Document  ![Icon of Document ](/Users/prad/Sonr/docs/icons/PNG/Document.png)
  static const IconData Document = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - List  ![Icon of List ](/Users/prad/Sonr/docs/icons/PNG/List.png)
  static const IconData List = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Lock  ![Icon of Lock ](/Users/prad/Sonr/docs/icons/PNG/Lock.png)
  static const IconData Lock = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - LoginSaved  ![Icon of LoginSaved ](/Users/prad/Sonr/docs/icons/PNG/LoginSaved.png)
  static const IconData LoginSaved = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Love  ![Icon of Love ](/Users/prad/Sonr/docs/icons/PNG/Love.png)
  static const IconData Love = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Mail  ![Icon of Mail ](/Users/prad/Sonr/docs/icons/PNG/Mail.png)
  static const IconData Mail = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Mention  ![Icon of Mention ](/Users/prad/Sonr/docs/icons/PNG/Mention.png)
  static const IconData Mention = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Mic  ![Icon of Mic ](/Users/prad/Sonr/docs/icons/PNG/Mic.png)
  static const IconData Mic = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - MoreCircle  ![Icon of MoreCircle ](/Users/prad/Sonr/docs/icons/PNG/MoreCircle.png)
  static const IconData MoreCircle = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - MoreSquare  ![Icon of MoreSquare ](/Users/prad/Sonr/docs/icons/PNG/MoreSquare.png)
  static const IconData MoreSquare = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - MutedCall  ![Icon of MutedCall ](/Users/prad/Sonr/docs/icons/PNG/MutedCall.png)
  static const IconData MutedCall = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Notification  ![Icon of Notification ](/Users/prad/Sonr/docs/icons/PNG/Notification.png)
  static const IconData Notification = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - OfficeBag  ![Icon of OfficeBag ](/Users/prad/Sonr/docs/icons/PNG/OfficeBag.png)
  static const IconData OfficeBag = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Saved  ![Icon of Saved ](/Users/prad/Sonr/docs/icons/PNG/Saved.png)
  static const IconData Saved = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - ShopBag  ![Icon of ShopBag ](/Users/prad/Sonr/docs/icons/PNG/ShopBag.png)
  static const IconData ShopBag = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - SquareClock  ![Icon of SquareClock ](/Users/prad/Sonr/docs/icons/PNG/SquareClock.png)
  static const IconData SquareClock = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Statistic  ![Icon of Statistic ](/Users/prad/Sonr/docs/icons/PNG/Statistic.png)
  static const IconData Statistic = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - StatisticAlt  ![Icon of StatisticAlt ](/Users/prad/Sonr/docs/icons/PNG/StatisticAlt.png)
  static const IconData StatisticAlt = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Theme  ![Icon of Theme ](/Users/prad/Sonr/docs/icons/PNG/Theme.png)
  static const IconData Theme = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Trash  ![Icon of Trash ](/Users/prad/Sonr/docs/icons/PNG/Trash.png)
  static const IconData Trash = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Typing  ![Icon of Typing ](/Users/prad/Sonr/docs/icons/PNG/Typing.png)
  static const IconData Typing = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - CheckShield  ![Icon of CheckShield ](/Users/prad/Sonr/docs/icons/PNG/CheckShield.png)
  static const IconData CheckShield = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Unchecklist  ![Icon of Unchecklist ](/Users/prad/Sonr/docs/icons/PNG/Unchecklist.png)
  static const IconData Unchecklist = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Unlocked  ![Icon of Unlocked ](/Users/prad/Sonr/docs/icons/PNG/Unlocked.png)
  static const IconData Unlocked = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - UploadFile  ![Icon of UploadFile ](/Users/prad/Sonr/docs/icons/PNG/UploadFile.png)
  static const IconData UploadFile = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Success  ![Icon of Success ](/Users/prad/Sonr/docs/icons/PNG/Success.png)
  static const IconData Success = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Verified  ![Icon of Verified ](/Users/prad/Sonr/docs/icons/PNG/Verified.png)
  static const IconData Verified = IconData(0xe914, fontFamily: _fontFamily);
}
