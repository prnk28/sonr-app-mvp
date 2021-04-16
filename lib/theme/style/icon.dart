import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonr_core/sonr_core.dart';
import 'color.dart';
export 'package:flutter_gradients/flutter_gradients.dart';
import '../form/theme.dart';

extension MimeIcon on MIME_Type {
  Widget gradient({double size = 32}) {
    switch (this) {
      case MIME_Type.audio:
        return SonrIcons.Sound_2.gradientNamed(name: FlutterGradientNames.flyingLemon, size: size);
      case MIME_Type.image:
        return SonrIcons.Photos.gradientNamed(name: FlutterGradientNames.juicyCake, size: size);
      case MIME_Type.text:
        return SonrIcons.Typing.gradientNamed(name: FlutterGradientNames.farawayRiver, size: size);
      case MIME_Type.video:
        return SonrIcons.Video1.gradientNamed(name: FlutterGradientNames.nightCall, size: size);
      default:
        return SonrIcons.Add_File.gradientNamed(name: FlutterGradientNames.newRetrowave, size: size);
    }
  }

  Icon get black {
    switch (this) {
      case MIME_Type.audio:
        return SonrIcons.Sound_2.black;
      case MIME_Type.image:
        return SonrIcons.Photos.black;
      case MIME_Type.text:
        return SonrIcons.Typing.black;
      case MIME_Type.video:
        return SonrIcons.Video1.black;
      default:
        return SonrIcons.Add_File.black;
    }
  }

  Icon get white {
    switch (this) {
      case MIME_Type.audio:
        return SonrIcons.Sound_2.white;
      case MIME_Type.image:
        return SonrIcons.Photos.white;
      case MIME_Type.text:
        return SonrIcons.Typing.white;
      case MIME_Type.video:
        return SonrIcons.Video1.white;
      default:
        return SonrIcons.Add_File.white;
    }
  }
}

extension PayloadIcon on Payload {
  Widget gradient({double size = 32}) {
    if (this == Payload.CONTACT) {
      return SonrIcons.Avatar.gradientNamed(name: FlutterGradientNames.colorfulPeach, size: size);
    } else if (this == Payload.MEDIA) {
      return SonrIcons.Video1.gradientNamed(name: FlutterGradientNames.loveKiss, size: size);
    } else if (this == Payload.URL) {
      return SonrIcons.Discover.gradientNamed(name: FlutterGradientNames.partyBliss, size: size);
    } else if (this == Payload.PDF) {
      return SonrIcons.PDF.gradientNamed(name: FlutterGradientNames.royalGarden, size: size);
    } else if (this == Payload.SPREADSHEET) {
      return SonrIcons.Spreadsheet.gradientNamed(name: FlutterGradientNames.itmeoBranding, size: size);
    } else if (this == Payload.PRESENTATION) {
      return SonrIcons.Presentation.gradientNamed(name: FlutterGradientNames.orangeJuice, size: size);
    } else if (this == Payload.TEXT) {
      return SonrIcons.List_File.gradientNamed(name: FlutterGradientNames.spaceShift, size: size);
    } else {
      return SonrIcons.Add_File.gradientNamed(name: FlutterGradientNames.midnightBloom, size: size);
    }
  }

  Icon get black {
    if (this == Payload.CONTACT) {
      return SonrIcons.Avatar.black;
    } else if (this == Payload.MEDIA) {
      return SonrIcons.Video1.black;
    } else if (this == Payload.URL) {
      return SonrIcons.Discover.black;
    } else if (this == Payload.PDF) {
      return SonrIcons.PDF.black;
    } else if (this == Payload.SPREADSHEET) {
      return SonrIcons.Spreadsheet.black;
    } else if (this == Payload.PRESENTATION) {
      return SonrIcons.Presentation.black;
    } else if (this == Payload.TEXT) {
      return SonrIcons.List_File.black;
    } else {
      return SonrIcons.Add_File.black;
    }
  }

  Icon get white {
    if (this == Payload.CONTACT) {
      return SonrIcons.Avatar.white;
    } else if (this == Payload.MEDIA) {
      return SonrIcons.Video1.white;
    } else if (this == Payload.URL) {
      return SonrIcons.Discover.white;
    } else if (this == Payload.PDF) {
      return SonrIcons.PDF.white;
    } else if (this == Payload.SPREADSHEET) {
      return SonrIcons.Spreadsheet.white;
    } else if (this == Payload.PRESENTATION) {
      return SonrIcons.Presentation.white;
    } else if (this == Payload.TEXT) {
      return SonrIcons.List_File.white;
    } else {
      return SonrIcons.Add_File.white;
    }
  }
}

extension PlatformIcon on Platform {
  // -- Returns Icon Widget -- //
  Widget gradient({double size = 32}) {
    switch (this) {
      case Platform.Android:
        return SonrIcons.Android.gradientNamed(name: FlutterGradientNames.glassWater, size: size);
      case Platform.iOS:
        return SonrIcons.IPhone.gradientNamed(name: FlutterGradientNames.glassWater, size: size);
      case Platform.MacOS:
        return SonrIcons.Mac.gradientNamed(name: FlutterGradientNames.glassWater, size: size);
      case Platform.Windows:
        return SonrIcons.Windows.gradientNamed(name: FlutterGradientNames.glassWater, size: size);
      default:
        return SonrIcons.Lock.gradientNamed(name: FlutterGradientNames.glassWater, size: size);
    }
  }

  Icon get black {
    switch (this) {
      case Platform.Android:
        return SonrIcons.Android.black;
      case Platform.iOS:
        return SonrIcons.IPhone.black;
      case Platform.MacOS:
        return SonrIcons.Mac.black;
      case Platform.Windows:
        return SonrIcons.Windows.black;
      default:
        return SonrIcons.Lock.black;
    }
  }

  Icon get white {
    switch (this) {
      case Platform.Android:
        return SonrIcons.Android.white;
      case Platform.iOS:
        return SonrIcons.IPhone.white;
      case Platform.MacOS:
        return SonrIcons.Mac.white;
      case Platform.Windows:
        return SonrIcons.Windows.white;
      default:
        return SonrIcons.Lock.white;
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

class SonrIcons {
  SonrIcons._();
  static const String _fontFamily = 'SonrIcons';

  static const IconData Stop = IconData(0xe974, fontFamily: _fontFamily);
  static const IconData Anchor = IconData(0xe963, fontFamily: _fontFamily);
  static const IconData Check_All = IconData(0xe966, fontFamily: _fontFamily);
  static const IconData Close = IconData(0xe967, fontFamily: _fontFamily);
  static const IconData Gift = IconData(0xe968, fontFamily: _fontFamily);
  static const IconData Scan = IconData(0xe969, fontFamily: _fontFamily);
  static const IconData Server = IconData(0xe96a, fontFamily: _fontFamily);
  static const IconData Ship = IconData(0xe96e, fontFamily: _fontFamily);
  static const IconData Tag = IconData(0xe96f, fontFamily: _fontFamily);
  static const IconData Trend_Up = IconData(0xe970, fontFamily: _fontFamily);
  static const IconData Update = IconData(0xe972, fontFamily: _fontFamily);
  static const IconData Facebook = IconData(0xe900, fontFamily: _fontFamily);
  static const IconData Files = IconData(0xe929, fontFamily: _fontFamily);
  static const IconData Film = IconData(0xe93a, fontFamily: _fontFamily);
  static const IconData Internet = IconData(0xe94f, fontFamily: _fontFamily);
  static const IconData Link = IconData(0xe95c, fontFamily: _fontFamily);
  static const IconData Linkedin = IconData(0xe962, fontFamily: _fontFamily);
  static const IconData Remote = IconData(0xe922, fontFamily: _fontFamily);
  static const IconData Photos = IconData(0xe902, fontFamily: _fontFamily);
  static const IconData Activity = IconData(0xe910, fontFamily: _fontFamily);
  static const IconData Apple = IconData(0xe91a, fontFamily: _fontFamily);
  static const IconData Bug = IconData(0xe91c, fontFamily: _fontFamily);
  static const IconData Check = IconData(0xe91f, fontFamily: _fontFamily);
  static const IconData Backward = IconData(0xe920, fontFamily: _fontFamily);
  static const IconData Down = IconData(0xe921, fontFamily: _fontFamily);
  static const IconData Forward = IconData(0xe924, fontFamily: _fontFamily);
  static const IconData Up = IconData(0xe925, fontFamily: _fontFamily);
  static const IconData Collapse = IconData(0xe928, fontFamily: _fontFamily);
  static const IconData Screenshot = IconData(0xe92b, fontFamily: _fontFamily);
  static const IconData Download = IconData(0xe92c, fontFamily: _fontFamily);
  static const IconData Grid = IconData(0xe92d, fontFamily: _fontFamily);
  static const IconData Group = IconData(0xe92e, fontFamily: _fontFamily);
  static const IconData Hide = IconData(0xe92f, fontFamily: _fontFamily);
  static const IconData Image = IconData(0xe930, fontFamily: _fontFamily);
  static const IconData Inbox = IconData(0xe931, fontFamily: _fontFamily);
  static const IconData Instagram = IconData(0xe932, fontFamily: _fontFamily);
  static const IconData Layers = IconData(0xe933, fontFamily: _fontFamily);
  static const IconData Leaderboard = IconData(0xe934, fontFamily: _fontFamily);
  static const IconData Spreadsheet = IconData(0xe935, fontFamily: _fontFamily);
  static const IconData Login = IconData(0xe936, fontFamily: _fontFamily);
  static const IconData Logout = IconData(0xe938, fontFamily: _fontFamily);
  static const IconData Map = IconData(0xe939, fontFamily: _fontFamily);
  static const IconData Medal = IconData(0xe93b, fontFamily: _fontFamily);
  static const IconData Moon = IconData(0xe93f, fontFamily: _fontFamily);
  static const IconData More_Horizontal = IconData(0xe940, fontFamily: _fontFamily);
  static const IconData More_Vertical = IconData(0xe944, fontFamily: _fontFamily);
  static const IconData Open = IconData(0xe945, fontFamily: _fontFamily);
  static const IconData User = IconData(0xe949, fontFamily: _fontFamily);
  static const IconData Presentation = IconData(0xe94a, fontFamily: _fontFamily);
  static const IconData Avatar = IconData(0xe94b, fontFamily: _fontFamily);
  static const IconData Reload = IconData(0xe94c, fontFamily: _fontFamily);
  static const IconData Rocket = IconData(0xe94d, fontFamily: _fontFamily);
  static const IconData Search = IconData(0xe94e, fontFamily: _fontFamily);
  static const IconData Settings = IconData(0xe951, fontFamily: _fontFamily);
  static const IconData Show = IconData(0xe952, fontFamily: _fontFamily);
  static const IconData Size = IconData(0xe953, fontFamily: _fontFamily);
  static const IconData Smart_Watch = IconData(0xe954, fontFamily: _fontFamily);
  static const IconData Snapchat = IconData(0xe955, fontFamily: _fontFamily);
  static const IconData Sun = IconData(0xe956, fontFamily: _fontFamily);
  static const IconData Twitter = IconData(0xe958, fontFamily: _fontFamily);
  static const IconData Undo = IconData(0xe959, fontFamily: _fontFamily);
  static const IconData Warning = IconData(0xe95e, fontFamily: _fontFamily);
  static const IconData Wind = IconData(0xe95f, fontFamily: _fontFamily);
  static const IconData Zap = IconData(0xe960, fontFamily: _fontFamily);
  static const IconData Android = IconData(0xe903, fontFamily: _fontFamily);
  static const IconData Github = IconData(0xe901, fontFamily: _fontFamily);
  static const IconData Medium = IconData(0xe907, fontFamily: _fontFamily);
  static const IconData Spotify = IconData(0xe911, fontFamily: _fontFamily);
  static const IconData Tiktok = IconData(0xe912, fontFamily: _fontFamily);
  static const IconData Windows = IconData(0xe913, fontFamily: _fontFamily);
  static const IconData YouTube = IconData(0xe915, fontFamily: _fontFamily);
  static const IconData Add = IconData(0xe904, fontFamily: _fontFamily);
  static const IconData Blocked_Account = IconData(0xe905, fontFamily: _fontFamily);
  static const IconData Blocked_User = IconData(0xe906, fontFamily: _fontFamily);
  static const IconData Call_in = IconData(0xe908, fontFamily: _fontFamily);
  static const IconData Call_Ringing = IconData(0xe909, fontFamily: _fontFamily);
  static const IconData Call = IconData(0xe90a, fontFamily: _fontFamily);
  static const IconData Camera = IconData(0xe90b, fontFamily: _fontFamily);
  static const IconData Canceled_Call = IconData(0xe90c, fontFamily: _fontFamily);
  static const IconData Cart = IconData(0xe90d, fontFamily: _fontFamily);
  static const IconData Category = IconData(0xe90e, fontFamily: _fontFamily);
  static const IconData Caution_Circle = IconData(0xe90f, fontFamily: _fontFamily);
  static const IconData Coupon = IconData(0xe916, fontFamily: _fontFamily);
  static const IconData Discount = IconData(0xe917, fontFamily: _fontFamily);
  static const IconData Dislike = IconData(0xe919, fontFamily: _fontFamily);
  static const IconData Edit = IconData(0xe91d, fontFamily: _fontFamily);
  static const IconData Favorite = IconData(0xe91e, fontFamily: _fontFamily);
  static const IconData Hastag = IconData(0xe923, fontFamily: _fontFamily);
  static const IconData Key = IconData(0xe926, fontFamily: _fontFamily);
  static const IconData Liked = IconData(0xe927, fontFamily: _fontFamily);
  static const IconData Location = IconData(0xe92a, fontFamily: _fontFamily);
  static const IconData Muted_Mic = IconData(0xe937, fontFamily: _fontFamily);
  static const IconData Pin = IconData(0xe93c, fontFamily: _fontFamily);
  static const IconData Play = IconData(0xe93d, fontFamily: _fontFamily);
  static const IconData Pocket = IconData(0xe93e, fontFamily: _fontFamily);
  static const IconData Seen = IconData(0xe941, fontFamily: _fontFamily);
  static const IconData Setting = IconData(0xe942, fontFamily: _fontFamily);
  static const IconData Share = IconData(0xe943, fontFamily: _fontFamily);
  static const IconData Silent = IconData(0xe946, fontFamily: _fontFamily);
  static const IconData Sound_1 = IconData(0xe947, fontFamily: _fontFamily);
  static const IconData Sound_2 = IconData(0xe948, fontFamily: _fontFamily);
  static const IconData Switch_Camera = IconData(0xe957, fontFamily: _fontFamily);
  static const IconData Ticket = IconData(0xe950, fontFamily: _fontFamily);
  static const IconData Video1 = IconData(0xe95a, fontFamily: _fontFamily);
  static const IconData About = IconData(0xe95b, fontFamily: _fontFamily);
  static const IconData Add_File = IconData(0xe95d, fontFamily: _fontFamily);
  static const IconData Blocked = IconData(0xe961, fontFamily: _fontFamily);
  static const IconData Chat = IconData(0xe96b, fontFamily: _fontFamily);
  static const IconData Checklist = IconData(0xe96c, fontFamily: _fontFamily);
  static const IconData Circle_Clock = IconData(0xe96d, fontFamily: _fontFamily);
  static const IconData Discover = IconData(0xe971, fontFamily: _fontFamily);
  static const IconData Download_File = IconData(0xe973, fontFamily: _fontFamily);
  static const IconData Filter = IconData(0xe978, fontFamily: _fontFamily);
  static const IconData Folder = IconData(0xe979, fontFamily: _fontFamily);
  static const IconData Home = IconData(0xe97d, fontFamily: _fontFamily);
  static const IconData Calendar = IconData(0xe97e, fontFamily: _fontFamily);
  static const IconData List_File = IconData(0xe981, fontFamily: _fontFamily);
  static const IconData List = IconData(0xe982, fontFamily: _fontFamily);
  static const IconData Lock = IconData(0xe984, fontFamily: _fontFamily);
  static const IconData Login_Saved = IconData(0xe987, fontFamily: _fontFamily);
  static const IconData Love = IconData(0xe988, fontFamily: _fontFamily);
  static const IconData Mail = IconData(0xe989, fontFamily: _fontFamily);
  static const IconData Mention = IconData(0xe98a, fontFamily: _fontFamily);
  static const IconData Mic = IconData(0xe98b, fontFamily: _fontFamily);
  static const IconData More_Circle = IconData(0xe98c, fontFamily: _fontFamily);
  static const IconData More_Square = IconData(0xe98d, fontFamily: _fontFamily);
  static const IconData Muted_Call = IconData(0xe98e, fontFamily: _fontFamily);
  static const IconData Notification = IconData(0xe98f, fontFamily: _fontFamily);
  static const IconData Office_Bag = IconData(0xe990, fontFamily: _fontFamily);
  static const IconData Saved = IconData(0xe996, fontFamily: _fontFamily);
  static const IconData Shop_Bag = IconData(0xe99c, fontFamily: _fontFamily);
  static const IconData Square_Clock = IconData(0xe99f, fontFamily: _fontFamily);
  static const IconData Statistic = IconData(0xe9a0, fontFamily: _fontFamily);
  static const IconData Statistic_2 = IconData(0xe9a1, fontFamily: _fontFamily);
  static const IconData Theme = IconData(0xe9a5, fontFamily: _fontFamily);
  static const IconData Trash = IconData(0xe9a7, fontFamily: _fontFamily);
  static const IconData Typing = IconData(0xe9a8, fontFamily: _fontFamily);
  static const IconData Check_Shield = IconData(0xe9a9, fontFamily: _fontFamily);
  static const IconData Unchecklist = IconData(0xe9aa, fontFamily: _fontFamily);
  static const IconData Unlocked = IconData(0xe9ab, fontFamily: _fontFamily);
  static const IconData Upload_File = IconData(0xe9ad, fontFamily: _fontFamily);
  static const IconData Success = IconData(0xe9af, fontFamily: _fontFamily);
  static const IconData Verified = IconData(0xe9b0, fontFamily: _fontFamily);
  static const IconData IPhone = IconData(0xe918, fontFamily: _fontFamily);
  static const IconData Panorama = IconData(0xe914, fontFamily: _fontFamily);
  static const IconData Linux = IconData(0xe91b, fontFamily: _fontFamily);
  static const IconData PDF = IconData(0xe964, fontFamily: _fontFamily);
  static const IconData Mac = IconData(0xe965, fontFamily: _fontFamily);
}
