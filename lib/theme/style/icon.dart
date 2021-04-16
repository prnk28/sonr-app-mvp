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
        return SonrIcons.Unknown_File.gradientNamed(name: FlutterGradientNames.newRetrowave, size: size);
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
        return SonrIcons.Unknown_File.black;
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
        return SonrIcons.Unknown_File.white;
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
      return SonrIcons.Unknown_File.gradientNamed(name: FlutterGradientNames.midnightBloom, size: size);
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
      return SonrIcons.Unknown_File.black;
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
      return SonrIcons.Unknown_File.white;
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
        return SonrIcons.IOS.gradientNamed(name: FlutterGradientNames.glassWater, size: size);
      case Platform.MacOS:
        return SonrIcons.Mac.gradientNamed(name: FlutterGradientNames.glassWater, size: size);
      case Platform.Windows:
        return SonrIcons.Windows.gradientNamed(name: FlutterGradientNames.glassWater, size: size);
      default:
        return SonrIcons.Unknown_Device.gradientNamed(name: FlutterGradientNames.glassWater, size: size);
    }
  }

  Icon get black {
    switch (this) {
      case Platform.Android:
        return SonrIcons.Android.black;
      case Platform.IOS:
        return SonrIcons.IOS.black;
      case Platform.MacOS:
        return SonrIcons.Mac.black;
      case Platform.Windows:
        return SonrIcons.Windows.black;
      default:
        return SonrIcons.Unknown_Device.black;
    }
  }

  Icon get grey {
    switch (this) {
      case Platform.Android:
        return SonrIcons.Android.grey;
      case Platform.IOS:
        return SonrIcons.IOS.grey;
      case Platform.MacOS:
        return SonrIcons.Mac.grey;
      case Platform.Windows:
        return SonrIcons.Windows.grey;
      default:
        return SonrIcons.Unknown_Device.grey;
    }
  }

  Icon get white {
    switch (this) {
      case Platform.Android:
        return SonrIcons.Android.white;
      case Platform.IOS:
        return SonrIcons.IOS.white;
      case Platform.MacOS:
        return SonrIcons.Mac.white;
      case Platform.Windows:
        return SonrIcons.Windows.white;
      default:
        return SonrIcons.Unknown_Device.white;
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
      color: SonrColor.Neutral,
    );
  }

  Widget greyWith({double size = 24}) {
    return Icon(
      this,
      size: size,
      color: SonrColor.Neutral,
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
        var grad = gradient ?? SonrPalette.primary();
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
  // * [^.*(\s+([a-zA-Z]+\s+)+).*[a-zA-Z]+.*[a-zA-Z]+.*[a-zA-Z]+.*$] > Regex Expression for Comment Generation * //
  //! Dont use underscores for fonts //

  SonrIcons._();
  static const String _fontFamily = 'SonrIcons';

  /// Sonricons - Audio ![Icon of Audio](/Users/prad/Sonr/docs/icons/PNG/Audio.png)
  static const IconData Audio = IconData(0xe97c, fontFamily: _fontFamily);

  /// Sonricons - Yoda ![Icon of Yoda](/Users/prad/Sonr/docs/icons/PNG/Yoda.png)
  static const IconData Yoda = IconData(0xe942, fontFamily: _fontFamily);

  /// Sonricons - Cancel ![Icon of Cancel](/Users/prad/Sonr/docs/icons/PNG/Cancel.png)
  static const IconData Cancel = IconData(0xe94d, fontFamily: _fontFamily);

  /// Sonricons - Plus ![Icon of Plus](/Users/prad/Sonr/docs/icons/PNG/Plus.png)
  static const IconData Plus = IconData(0xe961, fontFamily: _fontFamily);

  /// Sonricons - Copy ![Icon of Copy](/Users/prad/Sonr/docs/icons/PNG/Copy.png)
  static const IconData Copy = IconData(0xe97b, fontFamily: _fontFamily);

  /// Sonricons - Unknown_Device ![Icon of Unknown_Device](/Users/prad/Sonr/docs/icons/PNG/Unknown-Device.png)
  static const IconData Unknown_Device = IconData(0xe914, fontFamily: _fontFamily);

  /// Sonricons - Unknown_File ![Icon of Unknown_File](/Users/prad/Sonr/docs/icons/PNG/Unknown-File.png)
  static const IconData Unknown_File = IconData(0xe918, fontFamily: _fontFamily);

  /// Sonricons - Panorama ![Icon of Panorama](/Users/prad/Sonr/docs/icons/PNG/Panorama.png)
  static const IconData Panorama = IconData(0xe91a, fontFamily: _fontFamily);

  /// Sonricons - WebApp ![Icon of WebApp](/Users/prad/Sonr/docs/icons/PNG/WebApp.png)
  static const IconData WebApp = IconData(0xe91b, fontFamily: _fontFamily);

  /// Sonricons - Linux ![Icon of Linux](/Users/prad/Sonr/docs/icons/PNG/Linux.png)
  static const IconData Linux = IconData(0xe964, fontFamily: _fontFamily);

  /// Sonricons - Darth_Vader ![Icon of Darth_Vader](/Users/prad/Sonr/docs/icons/PNG/Darth-Vader.png)
  static const IconData Darth_Vader = IconData(0xe965, fontFamily: _fontFamily);

  /// Sonricons - Mac ![Icon of Mac](/Users/prad/Sonr/docs/icons/PNG/Mac.png)
  static const IconData Mac = IconData(0xe975, fontFamily: _fontFamily);

  /// Sonricons - PDF ![Icon of PDF](/Users/prad/Sonr/docs/icons/PNG/PDF.png)
  static const IconData PDF = IconData(0xe976, fontFamily: _fontFamily);

  /// Sonricons - IOS ![Icon of IOS](/Users/prad/Sonr/docs/icons/PNG/iPhone.png)
  static const IconData IOS = IconData(0xe977, fontFamily: _fontFamily);

  /// Sonricons - Android ![Icon of Android](/Users/prad/Sonr/docs/icons/PNG/Android.png)
  static const IconData Android = IconData(0xe97a, fontFamily: _fontFamily);

  /// Sonricons - Stop ![Icon of Stop](/Users/prad/Sonr/docs/icons/PNG/Stop.png)
  static const IconData Stop = IconData(0xe974, fontFamily: _fontFamily);

  /// Sonricons - Anchor ![Icon of Anchor](/Users/prad/Sonr/docs/icons/PNG/Anchor.png)
  static const IconData Anchor = IconData(0xe963, fontFamily: _fontFamily);

  /// Sonricons - Check_All ![Icon of Check_All](/Users/prad/Sonr/docs/icons/PNG/Check-All.png)
  static const IconData Check_All = IconData(0xe966, fontFamily: _fontFamily);

  /// Sonricons - Close ![Icon of Close](/Users/prad/Sonr/docs/icons/PNG/Close.png)
  static const IconData Close = IconData(0xe967, fontFamily: _fontFamily);

  /// Sonricons - Gift ![Icon of Gift](/Users/prad/Sonr/docs/icons/PNG/Gift.png)
  static const IconData Gift = IconData(0xe968, fontFamily: _fontFamily);

  /// Sonricons - Scan ![Icon of Scan](/Users/prad/Sonr/docs/icons/PNG/Scan.png
  static const IconData Scan = IconData(0xe969, fontFamily: _fontFamily);

  /// Sonricons - Server ![Icon of Server](/Users/prad/Sonr/docs/icons/PNG/Server.png)
  static const IconData Server = IconData(0xe96a, fontFamily: _fontFamily);

  /// Sonricons - Ship ![Icon of Ship](/Users/prad/Sonr/docs/icons/PNG/Ship.png)
  static const IconData Ship = IconData(0xe96e, fontFamily: _fontFamily);

  /// Sonricons - Tag ![Icon of Tag](/Users/prad/Sonr/docs/icons/PNG/Tag.png)
  static const IconData Tag = IconData(0xe96f, fontFamily: _fontFamily);

  /// Sonricons - Trend_Up ![Icon of Trend_Up](/Users/prad/Sonr/docs/icons/PNG/Trend-Up.png)
  static const IconData Trend_Up = IconData(0xe970, fontFamily: _fontFamily);

  /// Sonricons - Update ![Icon of Update](/Users/prad/Sonr/docs/icons/PNG/Update.png)
  static const IconData Update = IconData(0xe972, fontFamily: _fontFamily);

  /// Sonricons - Facebook ![Icon of Facebook](/Users/prad/Sonr/docs/icons/PNG/Facebook.png)
  static const IconData Facebook = IconData(0xe900, fontFamily: _fontFamily);

  /// Sonricons - Files ![Icon of Files](/Users/prad/Sonr/docs/icons/PNG/Files.png)
  static const IconData Files = IconData(0xe929, fontFamily: _fontFamily);

  /// Sonricons - Video ![Icon of Video](/Users/prad/Sonr/docs/icons/PNG/Video.png)
  static const IconData Video = IconData(0xe93a, fontFamily: _fontFamily);

  /// Sonricons - Internet ![Icon of Internet](/Users/prad/Sonr/docs/icons/PNG/Internet.png)
  static const IconData Internet = IconData(0xe94f, fontFamily: _fontFamily);

  /// Sonricons - Link ![Icon of Link](/Users/prad/Sonr/docs/icons/PNG/Link.png)
  static const IconData Link = IconData(0xe95c, fontFamily: _fontFamily);

  /// Sonricons - Linkedin ![Icon of Linkedin](/Users/prad/Sonr/docs/icons/PNG/Linkedin.png)
  static const IconData Linkedin = IconData(0xe962, fontFamily: _fontFamily);

  /// Sonricons - Remote ![Icon of Remote](/Users/prad/Sonr/docs/icons/PNG/Remote.png)
  static const IconData Remote = IconData(0xe922, fontFamily: _fontFamily);

  /// Sonricons - Photos ![Icon of Photos](/Users/prad/Sonr/docs/icons/PNG/Photos.png)
  static const IconData Photos = IconData(0xe902, fontFamily: _fontFamily);

  /// Sonricons - Activity ![Icon of Activity](/Users/prad/Sonr/docs/icons/PNG/Activity.png)
  static const IconData Activity = IconData(0xe910, fontFamily: _fontFamily);

  /// Sonricons - Bug ![Icon of Bug](/Users/prad/Sonr/docs/icons/PNG/Bug.png)
  static const IconData Bug = IconData(0xe91c, fontFamily: _fontFamily);

  /// Sonricons - Check ![Icon of Check](/Users/prad/Sonr/docs/icons/PNG/Check.png)
  static const IconData Check = IconData(0xe91f, fontFamily: _fontFamily);

  /// Sonricons - Backward ![Icon of Backward](/Users/prad/Sonr/docs/icons/PNG/Backward.png)
  static const IconData Backward = IconData(0xe920, fontFamily: _fontFamily);

  /// Sonricons - Down ![Icon of Down](/Users/prad/Sonr/docs/icons/PNG/Down.png)
  static const IconData Down = IconData(0xe921, fontFamily: _fontFamily);

  /// Sonricons - Forward ![Icon of Forward](/Users/prad/Sonr/docs/icons/PNG/Forward.png)
  static const IconData Forward = IconData(0xe924, fontFamily: _fontFamily);

  /// Sonricons - Up ![Icon of Up](/Users/prad/Sonr/docs/icons/PNG/Up.png)
  static const IconData Up = IconData(0xe925, fontFamily: _fontFamily);

  /// Sonricons - Collapse ![Icon of Collapse](/Users/prad/Sonr/docs/icons/PNG/Collapse.png)
  static const IconData Collapse = IconData(0xe928, fontFamily: _fontFamily);

  /// Sonricons - Screenshot ![Icon of Screenshot](/Users/prad/Sonr/docs/icons/PNG/Screenshot.png)
  static const IconData Screenshot = IconData(0xe92b, fontFamily: _fontFamily);

  /// Sonricons - Download ![Icon of Download](/Users/prad/Sonr/docs/icons/PNG/Download.png)
  static const IconData Download = IconData(0xe92c, fontFamily: _fontFamily);

  /// Sonricons - Grid ![Icon of Grid](/Users/prad/Sonr/docs/icons/PNG/Grid.png)
  static const IconData Grid = IconData(0xe92d, fontFamily: _fontFamily);

  /// Sonricons - Group ![Icon of Group](/Users/prad/Sonr/docs/icons/PNG/Group.png)
  static const IconData Group = IconData(0xe92e, fontFamily: _fontFamily);

  /// Sonricons - Hide ![Icon of Hide](/Users/prad/Sonr/docs/icons/PNG/Hide.png)
  static const IconData Hide = IconData(0xe92f, fontFamily: _fontFamily);

  /// Sonricons - Image ![Icon of Image](/Users/prad/Sonr/docs/icons/PNG/Image.png)
  static const IconData Image = IconData(0xe930, fontFamily: _fontFamily);

  /// Sonricons - Inbox ![Icon of Inbox](/Users/prad/Sonr/docs/icons/PNG/Inbox.png)
  static const IconData Inbox = IconData(0xe931, fontFamily: _fontFamily);

  /// Sonricons - Instagram ![Icon of Instagram](/Users/prad/Sonr/docs/icons/PNG/Instagram.png)
  static const IconData Instagram = IconData(0xe932, fontFamily: _fontFamily);

  /// Sonricons - Layers ![Icon of Layers](/Users/prad/Sonr/docs/icons/PNG/Layers.png)
  static const IconData Layers = IconData(0xe933, fontFamily: _fontFamily);

  /// Sonricons - Leaderboard ![Icon of Leaderboard](/Users/prad/Sonr/docs/icons/PNG/Leaderboard.png)
  static const IconData Leaderboard = IconData(0xe934, fontFamily: _fontFamily);

  /// Sonricons - Spreadsheet ![Icon of Spreadsheet](/Users/prad/Sonr/docs/icons/PNG/Spreadsheet.png)
  static const IconData Spreadsheet = IconData(0xe935, fontFamily: _fontFamily);

  /// Sonricons - Login ![Icon of Login](/Users/prad/Sonr/docs/icons/PNG/Login.png)
  static const IconData Login = IconData(0xe936, fontFamily: _fontFamily);

  /// Sonricons - Logout ![Icon of Logout](/Users/prad/Sonr/docs/icons/PNG/Logout.png)
  static const IconData Logout = IconData(0xe938, fontFamily: _fontFamily);

  /// Sonricons - Map ![Icon of Map](/Users/prad/Sonr/docs/icons/PNG/Map.png)
  static const IconData Map = IconData(0xe939, fontFamily: _fontFamily);

  /// Sonricons - Medal ![Icon of Medal](/Users/prad/Sonr/docs/icons/PNG/Medal.png)
  static const IconData Medal = IconData(0xe93b, fontFamily: _fontFamily);

  /// Sonricons - Moon ![Icon of Moon](/Users/prad/Sonr/docs/icons/PNG/Moon.png)
  static const IconData Moon = IconData(0xe93f, fontFamily: _fontFamily);

  /// Sonricons - More_Horizontal ![Icon of More_Horizontal](/Users/prad/Sonr/docs/icons/PNG/More-Horizontal.png)
  static const IconData More_Horizontal = IconData(0xe940, fontFamily: _fontFamily);

  /// Sonricons - More_Vertical ![Icon of More_Vertical](/Users/prad/Sonr/docs/icons/PNG/More-Vertical.png)
  static const IconData More_Vertical = IconData(0xe944, fontFamily: _fontFamily);

  /// Sonricons - Open ![Icon of Open](/Users/prad/Sonr/docs/icons/PNG/Open.png)
  static const IconData Open = IconData(0xe945, fontFamily: _fontFamily);

  /// Sonricons - User ![Icon of User](/Users/prad/Sonr/docs/icons/PNG/User.png)
  static const IconData User = IconData(0xe949, fontFamily: _fontFamily);

  /// Sonricons - Presentation ![Icon of Presentation](/Users/prad/Sonr/docs/icons/PNG/Presentation.png)
  static const IconData Presentation = IconData(0xe94a, fontFamily: _fontFamily);

  /// Sonricons - Avatar ![Icon of Avatar](/Users/prad/Sonr/docs/icons/PNG/Avatar.png)
  static const IconData Avatar = IconData(0xe94b, fontFamily: _fontFamily);

  /// Sonricons - Reload ![Icon of Reload](/Users/prad/Sonr/docs/icons/PNG/Reload.png)
  static const IconData Reload = IconData(0xe94c, fontFamily: _fontFamily);

  /// Sonricons - Search ![Icon of Search](/Users/prad/Sonr/docs/icons/PNG/Search.png)
  static const IconData Search = IconData(0xe94e, fontFamily: _fontFamily);

  /// Sonricons - Settings ![Icon of Settings](/Users/prad/Sonr/docs/icons/PNG/Settings.png)
  static const IconData Settings = IconData(0xe951, fontFamily: _fontFamily);

  /// Sonricons - Show ![Icon of Show](/Users/prad/Sonr/docs/icons/PNG/Show.png)
  static const IconData Show = IconData(0xe952, fontFamily: _fontFamily);

  /// Sonricons - Expand ![Icon of Expand](/Users/prad/Sonr/docs/icons/PNG/Expand.png)
  static const IconData Expand = IconData(0xe953, fontFamily: _fontFamily);

  /// Sonricons - Smart_Watch ![Icon of ExpSmart_Watchand](/Users/prad/Sonr/docs/icons/PNG/Smart-Watch.png)
  static const IconData Smart_Watch = IconData(0xe954, fontFamily: _fontFamily);

  /// Sonricons - Snapchat ![Icon of Snapchat](/Users/prad/Sonr/docs/icons/PNG/Snapchat.png)
  static const IconData Snapchat = IconData(0xe955, fontFamily: _fontFamily);

  /// Sonricons - Sun ![Icon of Sun](/Users/prad/Sonr/docs/icons/PNG/Sun.png)
  static const IconData Sun = IconData(0xe956, fontFamily: _fontFamily);

  /// Sonricons - Twitter ![Icon of Twitter](/Users/prad/Sonr/docs/icons/PNG/Twitter.png)
  static const IconData Twitter = IconData(0xe958, fontFamily: _fontFamily);

  /// Sonricons - Undo ![Icon of Undo](/Users/prad/Sonr/docs/icons/PNG/Undo.png)
  static const IconData Undo = IconData(0xe959, fontFamily: _fontFamily);

  /// Sonricons - Warning ![Icon of Warning](/Users/prad/Sonr/docs/icons/PNG/Warning.png)
  static const IconData Warning = IconData(0xe95e, fontFamily: _fontFamily);

  /// Sonricons - Wind ![Icon of Wind](/Users/prad/Sonr/docs/icons/PNG/Wind.png)
  static const IconData Wind = IconData(0xe95f, fontFamily: _fontFamily);

  /// Sonricons - Zap ![Icon of Zap](/Users/prad/Sonr/docs/icons/PNG/Zap.png)
  static const IconData Zap = IconData(0xe960, fontFamily: _fontFamily);

  /// Sonricons - Android_Logo ![Icon of Android_Logo](/Users/prad/Sonr/docs/icons/PNG/Android-Logo.png)
  static const IconData Android_Logo = IconData(0xe903, fontFamily: _fontFamily);

  /// Sonricons - Github ![Icon of Github](/Users/prad/Sonr/docs/icons/PNG/Github.png)
  static const IconData Github = IconData(0xe901, fontFamily: _fontFamily);

  /// Sonricons - Medium ![Icon of Medium](/Users/prad/Sonr/docs/icons/PNG/Medium.png)
  static const IconData Medium = IconData(0xe907, fontFamily: _fontFamily);

  /// Sonricons - Spotify ![Icon of Spotify](/Users/prad/Sonr/docs/icons/PNG/Spotify.png)
  static const IconData Spotify = IconData(0xe911, fontFamily: _fontFamily);

  /// Sonricons - Tiktok ![Icon of Tiktok](/Users/prad/Sonr/docs/icons/PNG/Tiktok.png)
  static const IconData Tiktok = IconData(0xe912, fontFamily: _fontFamily);

  /// Sonricons - Windows ![Icon of Windows](/Users/prad/Sonr/docs/icons/PNG/Windows.png)
  static const IconData Windows = IconData(0xe913, fontFamily: _fontFamily);

  /// Sonricons - YouTube ![Icon of YouTube](/Users/prad/Sonr/docs/icons/PNG/YouTube.png)
  static const IconData YouTube = IconData(0xe915, fontFamily: _fontFamily);

  /// Sonricons - Add ![Icon of Add](/Users/prad/Sonr/docs/icons/PNG/Add.png)
  static const IconData Add = IconData(0xe904, fontFamily: _fontFamily);

  /// Sonricons - Blocked_Account ![Icon of Blocked_Account](/Users/prad/Sonr/docs/icons/PNG/Blocked-Account.png)
  static const IconData Blocked_Account = IconData(0xe905, fontFamily: _fontFamily);

  /// Sonricons - Blocked_User ![Icon of Blocked_User](/Users/prad/Sonr/docs/icons/PNG/Blocked-User.png)
  static const IconData Blocked_User = IconData(0xe906, fontFamily: _fontFamily);

  /// Sonricons - Call_in ![Icon of Call_in](/Users/prad/Sonr/docs/icons/PNG/Call-in.png)
  static const IconData Call_in = IconData(0xe908, fontFamily: _fontFamily);

  /// Sonricons - Call_Ringing ![Icon of Call_Ringing](/Users/prad/Sonr/docs/icons/PNG/Call-Ringing.png)
  static const IconData Call_Ringing = IconData(0xe909, fontFamily: _fontFamily);

  /// Sonricons - Call ![Icon of Call](/Users/prad/Sonr/docs/icons/PNG/Call.png)
  static const IconData Call = IconData(0xe90a, fontFamily: _fontFamily);

  /// Sonricons - Camera ![Icon of Camera](/Users/prad/Sonr/docs/icons/PNG/Camera.png)
  static const IconData Camera = IconData(0xe90b, fontFamily: _fontFamily);

  /// Sonricons - Canceled_Call ![Icon of Canceled_Call](/Users/prad/Sonr/docs/icons/PNG/Canceled-Call.png)
  static const IconData Canceled_Call = IconData(0xe90c, fontFamily: _fontFamily);

  /// Sonricons - Cart ![Icon of Cart](/Users/prad/Sonr/docs/icons/PNG/Cart.png)
  static const IconData Cart = IconData(0xe90d, fontFamily: _fontFamily);

  /// Sonricons - Category ![Icon of Category](/Users/prad/Sonr/docs/icons/PNG/Category.png)
  static const IconData Category = IconData(0xe90e, fontFamily: _fontFamily);

  static const IconData Caution_Circle = IconData(0xe90f, fontFamily: _fontFamily);

  /// Sonricons - Coupon ![Icon of Coupon](/Users/prad/Sonr/docs/icons/PNG/Coupon.png)
  static const IconData Coupon = IconData(0xe916, fontFamily: _fontFamily);

  /// Sonricons - Discount ![Icon of Discount](/Users/prad/Sonr/docs/icons/PNG/Discount.png)
  static const IconData Discount = IconData(0xe917, fontFamily: _fontFamily);

  /// Sonricons - Dislike ![Icon of Dislike](/Users/prad/Sonr/docs/icons/PNG/Dislike.png)
  static const IconData Dislike = IconData(0xe919, fontFamily: _fontFamily);

  /// Sonricons - Edit ![Icon of Edit](/Users/prad/Sonr/docs/icons/PNG/Edit.png)
  static const IconData Edit = IconData(0xe91d, fontFamily: _fontFamily);

  /// Sonricons - Favorite ![Icon of Favorite](/Users/prad/Sonr/docs/icons/PNG/Favorite.png)
  static const IconData Favorite = IconData(0xe91e, fontFamily: _fontFamily);

  /// Sonricons - Hastag ![Icon of Hastag](/Users/prad/Sonr/docs/icons/PNG/Hastag.png)
  static const IconData Hastag = IconData(0xe923, fontFamily: _fontFamily);

  /// Sonricons - Key ![Icon of Key](/Users/prad/Sonr/docs/icons/PNG/Key.png)
  static const IconData Key = IconData(0xe926, fontFamily: _fontFamily);

  /// Sonricons - Liked ![Icon of Liked](/Users/prad/Sonr/docs/icons/PNG/Liked.png)
  static const IconData Liked = IconData(0xe927, fontFamily: _fontFamily);

  /// Sonricons - Location ![Icon of Location](/Users/prad/Sonr/docs/icons/PNG/Location.png)
  static const IconData Location = IconData(0xe92a, fontFamily: _fontFamily);

  /// Sonricons - Muted_Mic ![Icon of Muted_Mic](/Users/prad/Sonr/docs/icons/PNG/Muted-Mic.png)
  static const IconData Muted_Mic = IconData(0xe937, fontFamily: _fontFamily);

  /// Sonricons - Pin ![Icon of Pin](/Users/prad/Sonr/docs/icons/PNG/Pin.png)
  static const IconData Pin = IconData(0xe93c, fontFamily: _fontFamily);

  /// Sonricons - Play ![Icon of Play](/Users/prad/Sonr/docs/icons/PNG/Play.png)
  static const IconData Play = IconData(0xe93d, fontFamily: _fontFamily);

  /// Sonricons - Pocket ![Icon of Pocket](/Users/prad/Sonr/docs/icons/PNG/Pocket.png)
  static const IconData Pocket = IconData(0xe93e, fontFamily: _fontFamily);

  /// Sonricons - Seen ![Icon of Seen](/Users/prad/Sonr/docs/icons/PNG/Seen.png)
  static const IconData Seen = IconData(0xe941, fontFamily: _fontFamily);

  /// Sonricons - Share ![Icon of Share](/Users/prad/Sonr/docs/icons/PNG/Share.png)
  static const IconData Share = IconData(0xe943, fontFamily: _fontFamily);

  /// Sonricons - Silent ![Icon of Silent](/Users/prad/Sonr/docs/icons/PNG/Silent.png)
  static const IconData Silent = IconData(0xe946, fontFamily: _fontFamily);

  /// Sonricons - Sound_1 ![Icon of Sound_1](/Users/prad/Sonr/docs/icons/PNG/Sound-1.png)
  static const IconData Sound_1 = IconData(0xe947, fontFamily: _fontFamily);

  /// Sonricons - Sound_2 ![Icon of Sound_2](/Users/prad/Sonr/docs/icons/PNG/Sound-2.png)
  static const IconData Sound_2 = IconData(0xe948, fontFamily: _fontFamily);

  /// Sonricons - Switch_Camera ![Icon of Switch_Camera](/Users/prad/Sonr/docs/icons/PNG/Switch-Camera.png)
  static const IconData Switch_Camera = IconData(0xe957, fontFamily: _fontFamily);

  /// Sonricons - Ticket ![Icon of Ticket](/Users/prad/Sonr/docs/icons/PNG/Ticket.png)
  static const IconData Ticket = IconData(0xe950, fontFamily: _fontFamily);

  /// Sonricons - Switch_Camera ![Icon of Switch_Camera](/Users/prad/Sonr/docs/icons/PNG/Switch-Camera.png)
  static const IconData Video_Camera = IconData(0xe95a, fontFamily: _fontFamily);

  /// Sonricons - About ![Icon of About](/Users/prad/Sonr/docs/icons/PNG/About.png)
  static const IconData About = IconData(0xe95b, fontFamily: _fontFamily);

  /// Sonricons - Add_File ![Icon of Add_File](/Users/prad/Sonr/docs/icons/PNG/Add-File.png)
  static const IconData Add_File = IconData(0xe95d, fontFamily: _fontFamily);

  /// Sonricons - Chat ![Icon of Chat](/Users/prad/Sonr/docs/icons/PNG/Chat.png)
  static const IconData Chat = IconData(0xe96b, fontFamily: _fontFamily);

  /// Sonricons - Checklist ![Icon of Checklist](/Users/prad/Sonr/docs/icons/PNG/Checklist.png)
  static const IconData Checklist = IconData(0xe96c, fontFamily: _fontFamily);

  /// Sonricons - Circle_Clock ![Icon of Circle_Clock](/Users/prad/Sonr/docs/icons/PNG/Circle-Clock.png)
  static const IconData Circle_Clock = IconData(0xe96d, fontFamily: _fontFamily);

  /// Sonricons - Discover ![Icon of Discover](/Users/prad/Sonr/docs/icons/PNG/Discover.png)
  static const IconData Discover = IconData(0xe971, fontFamily: _fontFamily);

  /// Sonricons - Download_File ![Icon of Circle_Clock](/Users/prad/Sonr/docs/icons/PNG/Download-File.png)
  static const IconData Download_File = IconData(0xe973, fontFamily: _fontFamily);

  /// Sonricons - Filter ![Icon of Filter](/Users/prad/Sonr/docs/icons/PNG/Filter.png)
  static const IconData Filter = IconData(0xe978, fontFamily: _fontFamily);

  /// Sonricons - Folder ![Icon of Folder](/Users/prad/Sonr/docs/icons/PNG/Folder.png)
  static const IconData Folder = IconData(0xe979, fontFamily: _fontFamily);

  /// Sonricons - Home ![Icon of Home](/Users/prad/Sonr/docs/icons/PNG/Home.png)
  static const IconData Home = IconData(0xe97d, fontFamily: _fontFamily);

  /// Sonricons - Calendar ![Icon of Calendar](/Users/prad/Sonr/docs/icons/PNG/Calendar.png)
  static const IconData Calendar = IconData(0xe97e, fontFamily: _fontFamily);

  /// Sonricons - Document ![Icon of Document](/Users/prad/Sonr/docs/icons/PNG/Document.png)
  static const IconData Document = IconData(0xe981, fontFamily: _fontFamily);

  /// Sonricons - List ![Icon of List](/Users/prad/Sonr/docs/icons/PNG/List.png)
  static const IconData List = IconData(0xe982, fontFamily: _fontFamily);

  /// Sonricons - Lock ![Icon of Lock](/Users/prad/Sonr/docs/icons/PNG/Lock.png)
  static const IconData Lock = IconData(0xe984, fontFamily: _fontFamily);

  /// Sonricons - Login_Saved ![Icon of Login_Saved](/Users/prad/Sonr/docs/icons/PNG/Login-Saved.png)
  static const IconData Login_Saved = IconData(0xe987, fontFamily: _fontFamily);

  /// Sonricons - Love ![Icon of Love](/Users/prad/Sonr/docs/icons/PNG/Love.png)
  static const IconData Love = IconData(0xe988, fontFamily: _fontFamily);

  /// Sonricons - Mail ![Icon of Mail](/Users/prad/Sonr/docs/icons/PNG/Mail.png)
  static const IconData Mail = IconData(0xe989, fontFamily: _fontFamily);

  /// Sonricons - Mention ![Icon of Mention](/Users/prad/Sonr/docs/icons/PNG/Mention.png)
  static const IconData Mention = IconData(0xe98a, fontFamily: _fontFamily);

  /// Sonricons - Mic ![Icon of Mic](/Users/prad/Sonr/docs/icons/PNG/Mic.png)
  static const IconData Mic = IconData(0xe98b, fontFamily: _fontFamily);

  /// Sonricons - More_Circle ![Icon of More_Circle](/Users/prad/Sonr/docs/icons/PNG/More-Circle.png)
  static const IconData More_Circle = IconData(0xe98c, fontFamily: _fontFamily);

  /// Sonricons - More_Square ![Icon of More_Square](/Users/prad/Sonr/docs/icons/PNG/More-Square.png)
  static const IconData More_Square = IconData(0xe98d, fontFamily: _fontFamily);

  /// Sonricons - Muted_Call ![Icon of Muted_Call](/Users/prad/Sonr/docs/icons/PNG/Muted-Call.png)
  static const IconData Muted_Call = IconData(0xe98e, fontFamily: _fontFamily);

  /// Sonricons - Notification ![Icon of Notification](/Users/prad/Sonr/docs/icons/PNG/Notification.png)
  static const IconData Notification = IconData(0xe98f, fontFamily: _fontFamily);

  /// Sonricons - Office_Bag ![Icon of Office_Bag](/Users/prad/Sonr/docs/icons/PNG/Office-Bag.png)
  static const IconData Office_Bag = IconData(0xe990, fontFamily: _fontFamily);

  /// Sonricons - Saved ![Icon of Saved](/Users/prad/Sonr/docs/icons/PNG/Saved.png)
  static const IconData Saved = IconData(0xe996, fontFamily: _fontFamily);

  /// Sonricons - Shop_Bag ![Icon of Shop_Bag](/Users/prad/Sonr/docs/icons/PNG/Shop-Bag.png)
  static const IconData Shop_Bag = IconData(0xe99c, fontFamily: _fontFamily);

  /// Sonricons - Square_Clock ![Icon of Square_Clock](/Users/prad/Sonr/docs/icons/PNG/Square-Clock.png)
  static const IconData Square_Clock = IconData(0xe99f, fontFamily: _fontFamily);

  /// Sonricons - Statistic ![Icon of Statistic](/Users/prad/Sonr/docs/icons/PNG/Statistic.png)
  static const IconData Statistic = IconData(0xe9a0, fontFamily: _fontFamily);

  /// Sonricons - Statistic_2 ![Icon of Statistic_2](/Users/prad/Sonr/docs/icons/PNG/Statistic-2.png)
  static const IconData Statistic_2 = IconData(0xe9a1, fontFamily: _fontFamily);

  /// Sonricons - Theme ![Icon of Theme](/Users/prad/Sonr/docs/icons/PNG/Theme.png)
  static const IconData Theme = IconData(0xe9a5, fontFamily: _fontFamily);

  /// Sonricons - Trash ![Icon of Trash](/Users/prad/Sonr/docs/icons/PNG/Trash.png)
  static const IconData Trash = IconData(0xe9a7, fontFamily: _fontFamily);

  /// Sonricons - Typing ![Icon of Typing](/Users/prad/Sonr/docs/icons/PNG/Typing.png)
  static const IconData Typing = IconData(0xe9a8, fontFamily: _fontFamily);

  /// Sonricons - Check_Shield ![Icon of Check_Shield](/Users/prad/Sonr/docs/icons/PNG/Check-Shield.png)
  static const IconData Check_Shield = IconData(0xe9a9, fontFamily: _fontFamily);

  /// Sonricons - Unchecklist ![Icon of Unchecklist](/Users/prad/Sonr/docs/icons/PNG/Unchecklist.png)
  static const IconData Unchecklist = IconData(0xe9aa, fontFamily: _fontFamily);

  /// Sonricons - Unlocked ![Icon of Unlocked](/Users/prad/Sonr/docs/icons/PNG/Unlocked.png)
  static const IconData Unlocked = IconData(0xe9ab, fontFamily: _fontFamily);

  /// Sonricons - Upload_File ![Icon of Upload_File](/Users/prad/Sonr/docs/icons/PNG/Upload-File.png)
  static const IconData Upload_File = IconData(0xe9ad, fontFamily: _fontFamily);

  /// Sonricons - Success ![Icon of Success](/Users/prad/Sonr/docs/icons/PNG/Success.png)
  static const IconData Success = IconData(0xe9af, fontFamily: _fontFamily);

  /// Sonricons - Verified ![Icon of Verified](/Users/prad/Sonr/docs/icons/PNG/Verified.png)
  static const IconData Verified = IconData(0xe9b0, fontFamily: _fontFamily);
}
