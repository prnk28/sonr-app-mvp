import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonr_core/sonr_core.dart';
import 'color.dart';
export 'package:flutter_gradients/flutter_gradients.dart';
import '../theme.dart';

enum IconType { Neumorphic, Normal, Gradient, Thumbnail, NeumorphicGradient }

class SonrIcon extends StatelessWidget {
  final IconData data;
  final IconType type;
  final double size;
  final FlutterGradientNames gradient;
  final Color color;
  final List<int> thumbnail;
  final NeumorphicStyle style;

  SonrIcon(this.data, this.type, this.color, this.gradient, {this.thumbnail, this.style, this.size, Key key}) : super(key: key);

  // ^ Gradient Icon with Provided Data
  factory SonrIcon.gradient(IconData data, FlutterGradientNames gradient, {double size = 40, Key key, Color color = Colors.white}) {
    return SonrIcon(
      data,
      IconType.Gradient,
      color,
      gradient,
      size: size,
      key: key,
    );
  }

  // ^ Neumorphic Icon with Provided Data
  factory SonrIcon.neumorphic(IconData data, {double size = 30, NeumorphicStyle style, Key key}) {
    return SonrIcon(
      data,
      IconType.Neumorphic,
      Colors.white,
      null,
      size: size,
      key: key,
      style: style ?? SonrStyle.gradientIcon,
    );
  }

  // ^ Neumorphic Gradient Icon with Provided Data
  factory SonrIcon.neumorphicGradient(IconData data, FlutterGradientNames gradient, {double size = 30, NeumorphicStyle style, Key key}) {
    return SonrIcon(
      data,
      IconType.NeumorphicGradient,
      Colors.white,
      gradient,
      size: size,
      key: key,
      style: style ?? SonrStyle.gradientIcon,
    );
  }

  // ^ Normal Icon with Provided Data
  factory SonrIcon.normal(IconData data, {double size = 24, Color color = SonrColor.White, Key key}) {
    return SonrIcon(
      data,
      IconType.Normal,
      color,
      null,
      size: size,
      key: key,
    );
  }

  // ^ Payload Data from TransferCard
  factory SonrIcon.withPreview(TransferCard card, {double size = 30, Color color = SonrColor.Black, Key key}) {
    IconGradientData iconData;
    switch (card.metadata.mime.type) {
      case MIME_Type.audio:
        iconData = IconGradientData(SonrIconData.audio, FlutterGradientNames.flyingLemon);
        break;
      case MIME_Type.image:
        iconData = IconGradientData(SonrIconData.photo, FlutterGradientNames.juicyCake);
        break;
      case MIME_Type.text:
        iconData = IconGradientData(SonrIconData.document, FlutterGradientNames.farawayRiver);
        break;
      case MIME_Type.video:
        iconData = IconGradientData(SonrIconData.video, FlutterGradientNames.nightCall);
        break;
      default:
        iconData = IconGradientData(SonrIconData.file_unknown, FlutterGradientNames.newRetrowave);
        break;
    }
    return SonrIcon(
      iconData.data,
      IconType.Thumbnail,
      color,
      iconData.gradient,
      thumbnail: card.preview,
      size: size,
      key: key,
    );
  }

  // ^ Payload Data from Mime
  factory SonrIcon.withMime(MIME mime,
      {double size = 30, Color color = SonrColor.Black, FlutterGradientNames gradient = FlutterGradientNames.orangeJuice, Key key}) {
    return SonrIcon(
      mime.type.gradientData.data,
      IconType.Gradient,
      color,
      gradient,
      size: size,
      key: key,
    );
  }

  // ^ UI Icons ^ //
  static SonrIcon get success => SonrIcon(SonrIconData.success, IconType.Normal, SonrColor.Black, null);
  static SonrIcon get missing => SonrIcon(SonrIconData.missing, IconType.Normal, SonrColor.Black, null);
  static SonrIcon get error => SonrIcon(SonrIconData.error, IconType.Normal, SonrColor.Black, null);
  static SonrIcon get cancel => SonrIcon(SonrIconData.cancel, IconType.Normal, SonrColor.Black, null);
  static SonrIcon get clear => SonrIcon.gradient(SonrIconData.cancel, FlutterGradientNames.happyMemories, size: 20);
  static SonrIcon get info => SonrIcon.gradient(SonrIconData.info, FlutterGradientNames.deepBlue, size: 20);
  static SonrIcon get back => SonrIcon.gradient(Icons.arrow_left, FlutterGradientNames.eternalConstance, size: 30);
  static SonrIcon get forward => SonrIcon.gradient(Icons.arrow_right, FlutterGradientNames.morpheusDen, size: 30);

  static SonrIcon get invite => SonrIcon.gradient(SonrIconData.share, FlutterGradientNames.aquaGuidance, size: 28);
  static SonrIcon get leave => SonrIcon.gradient(Icons.exit_to_app_rounded, FlutterGradientNames.happyMemories, size: 28);
  static SonrIcon get message => SonrIcon.gradient(Icons.message, FlutterGradientNames.aquaGuidance, size: 28);
  static SonrIcon get settings => SonrIcon.gradient(SonrIconData.settings, FlutterGradientNames.northMiracle, size: 36);
  static SonrIcon get multiSettings => SonrIcon.gradient(SonrIconData.params, FlutterGradientNames.northMiracle, size: 36);
  static SonrIcon get send => SonrIcon.gradient(SonrIconData.share, FlutterGradientNames.glassWater, size: 24);
  static SonrIcon get sonr => SonrIcon.gradient(SonrIconData.sonr, FlutterGradientNames.fabledSunset, size: 20);
  static SonrIcon get screenshots => SonrIcon.gradient(SonrIconData.screenshot, FlutterGradientNames.happyAcid, size: 20);
  static SonrIcon get photos => SonrIcon.gradient(SonrIconData.photo, FlutterGradientNames.shadyWater, size: 22);
  static SonrIcon get panorama => SonrIcon.gradient(SonrIconData.panorama, FlutterGradientNames.aboveTheSky, size: 20);
  static SonrIcon get video => SonrIcon.gradient(SonrIconData.video, FlutterGradientNames.octoberSilence, size: 40);
  static SonrIcon get url => SonrIcon.gradient(SonrIconData.url, FlutterGradientNames.magicRay, size: 24);
  static SonrIcon get location => SonrIcon.neumorphicGradient(Icons.location_city, FlutterGradientNames.itmeoBranding, size: 34);

  // ^ AppBar Icons ^ //
  static SonrIcon get accept => SonrIcon.neumorphicGradient(Icons.check, FlutterGradientNames.newLife, size: 36);
  static SonrIcon get groups => SonrIcon.neumorphicGradient(Icons.group, FlutterGradientNames.itmeoBranding, size: 34);
  static SonrIcon get search => SonrIcon.neumorphicGradient(Icons.search, FlutterGradientNames.plumBath, size: 36);
  static SonrIcon get more => SonrIcon.neumorphicGradient(Icons.more_horiz_outlined, FlutterGradientNames.northMiracle, size: 36);
  static SonrIcon get close => SonrIcon.normal(Icons.close, color: SonrPalette.Critical, size: 36);
  static SonrIcon get add => SonrIcon.normal(Icons.add, color: SonrColor.Blue, size: 36);
  static SonrIcon get remote => SonrIcon.normal(SonrIconData.remote, color: SonrColor.Blue, size: 28);

  // ^ Build View of Icon ^ //
  @override
  Widget build(BuildContext context) {
    Widget result;
    switch (type) {
      // @ Creates Neumorphic Icon
      case IconType.Neumorphic:
        result = NeumorphicIcon((data), size: size, style: style);
        break;

      // @ Creates Normal Icon
      case IconType.Normal:
        result = Icon(data, size: size, color: color);

        break;

      // @ Creates Neumorphic Gradient Icon
      case IconType.NeumorphicGradient:
        result = ShaderMask(
            blendMode: BlendMode.modulate,
            shaderCallback: (bounds) {
              var grad = FlutterGradients.findByName(gradient, tileMode: TileMode.clamp);
              return grad.createShader(bounds);
            },
            child: NeumorphicIcon((data), size: size, style: style));
        break;

      // @ Creates Gradient Icon
      case IconType.Gradient:
        result = ShaderMask(
          blendMode: BlendMode.modulate,
          shaderCallback: (bounds) {
            var grad = FlutterGradients.findByName(gradient, tileMode: TileMode.clamp);
            return grad.createShader(bounds);
          },
          child: Icon(
            data,
            size: size,
            color: color,
          ),
        );
        break;

      // @ Creates Thumbnail or Icon
      case IconType.Thumbnail:
        if (thumbnail.length == 0) {
          result = ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FittedBox(
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 1, minHeight: 1, maxWidth: 200, maxHeight: 200), // here
                      child: Image.memory(Uint8List.fromList(thumbnail)))));
        } else {
          result = Icon(data, size: size);
        }
        break;
    }
    return result;
  }
}

class SonrIconData {
  SonrIconData._();

  static const _kFontFam = 'SonrIcons';
  static const _kFontPkg = null;

  static const IconData all_categories = IconData(0xe81b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData profile = IconData(0xe81c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData spotify = IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData friends = IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData youtube = IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData tiktok = IconData(0xe803, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData compass = IconData(0xe804, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData android = IconData(0xe805, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData url = IconData(0xe806, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData contact = IconData(0xe807, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData error = IconData(0xe808, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData mac = IconData(0xe809, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData windows = IconData(0xe80a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData iphone = IconData(0xe80b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData settings = IconData(0xe80c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData params = IconData(0xe80d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData photo = IconData(0xe80e, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData sonr = IconData(0xe80f, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData screenshot = IconData(0xe810, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData document = IconData(0xe81a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData invite = IconData(0xe811, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData video = IconData(0xe812, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData audio = IconData(0xe813, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData videocamera = IconData(0xe814, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData success = IconData(0xe815, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData spreadsheet = IconData(0xe816, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData pdf = IconData(0xe817, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData cancel = IconData(0xe818, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData presentation = IconData(0xe819, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData missing = IconData(0xe81e, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData info = IconData(0xe81f, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData panorama = IconData(0xe88c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData camera = IconData(0xf039, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData github_alt = IconData(0xf09b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData file_unknown = IconData(0xf0f6, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData github = IconData(0xf113, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData youtube_alt = IconData(0xf167, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData instagram = IconData(0xf16d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData share = IconData(0xf1d9, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData medium = IconData(0xf23a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData snapchat = IconData(0xf2ac, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData snapchat_alt = IconData(0xf2ad, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData facebook = IconData(0xf300, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData facebook_fill = IconData(0xf301, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData twitter = IconData(0xf309, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData medium_alt = IconData(0xf3c7, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData media = IconData(0xf87c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData remote = IconData(0xe81d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}

class IconGradientData {
  final FlutterGradientNames gradient;
  final IconData _data;
  final IconData alt;
  const IconGradientData(this._data, this.gradient, {this.alt});
  IconData dataWithAlt(bool isAlt) {
    return isAlt ? alt : _data;
  }

  IconData get data {
    return _data;
  }
}

extension MimeIcon on MIME_Type {
  // -- Returns IconData with Gradient -- //
  IconGradientData get gradientData {
    switch (this) {
      case MIME_Type.audio:
        return IconGradientData(SonrIconData.audio, FlutterGradientNames.flyingLemon);
        break;
      case MIME_Type.image:
        return IconGradientData(SonrIconData.photo, FlutterGradientNames.juicyCake);
        break;
      case MIME_Type.text:
        return IconGradientData(SonrIconData.document, FlutterGradientNames.farawayRiver);
        break;
      case MIME_Type.video:
        return IconGradientData(SonrIconData.video, FlutterGradientNames.nightCall);
        break;
      default:
        return IconGradientData(SonrIconData.file_unknown, FlutterGradientNames.newRetrowave);
        break;
    }
  }
}

extension PayloadIcon on Payload {
  // -- Returns Icon Widget -- //
  SonrIcon icon(IconType type, {double size = 30, Color color = Colors.white, Key key, NeumorphicStyle style}) {
    IconData data;
    FlutterGradientNames gradient;
    if (this == Payload.CONTACT) {
      data = SonrIconData.contact;
      gradient = FlutterGradientNames.colorfulPeach;
    } else if (this == Payload.MEDIA) {
      data = SonrIconData.video;
      gradient = FlutterGradientNames.loveKiss;
    } else if (this == Payload.URL) {
      data = SonrIconData.url;
      gradient = FlutterGradientNames.partyBliss;
    } else if (this == Payload.PDF) {
      data = SonrIconData.pdf;
      gradient = FlutterGradientNames.royalGarden;
    } else if (this == Payload.SPREADSHEET) {
      data = SonrIconData.spreadsheet;
      gradient = FlutterGradientNames.itmeoBranding;
    } else if (this == Payload.PRESENTATION) {
      data = SonrIconData.presentation;
      gradient = FlutterGradientNames.orangeJuice;
    } else if (this == Payload.TEXT) {
      data = SonrIconData.document;
      gradient = FlutterGradientNames.spaceShift;
    } else {
      data = SonrIconData.file_unknown;
      gradient = FlutterGradientNames.midnightBloom;
    }
    return SonrIcon(
      data,
      type,
      color,
      gradient,
      size: size,
      style: style ?? SonrStyle.gradientIcon,
      key: key,
    );
  }
}

extension PlatformIcon on Platform {
  // -- Returns Icon Widget -- //
  SonrIcon icon(IconType type, {Color color, double size = 30, Key key, NeumorphicStyle style = const NeumorphicStyle(color: SonrColor.White)}) {
    IconGradientData gradientData;
    switch (this) {
      case Platform.Android:
        gradientData = IconGradientData(SonrIconData.android, FlutterGradientNames.glassWater);
        break;
      case Platform.iOS:
        gradientData = IconGradientData(SonrIconData.iphone, FlutterGradientNames.glassWater);
        break;
      case Platform.MacOS:
        gradientData = IconGradientData(SonrIconData.mac, FlutterGradientNames.glassWater);
        break;
      case Platform.Windows:
        gradientData = IconGradientData(SonrIconData.windows, FlutterGradientNames.glassWater);
        break;
      default:
        gradientData = IconGradientData(Icons.device_unknown, FlutterGradientNames.viciousStance);
        break;
    }
    return SonrIcon(gradientData.data, type, color, gradientData.gradient, size: size, key: key, style: style);
  }
}

extension SocialTileIcon on Contact_SocialTile_Provider {
  Padding badge(
      {Alignment alignment = Alignment.bottomRight,
      EdgeInsets padding = const EdgeInsets.only(
        bottom: 8.0,
        right: 8.0,
      ),
      double size = 30}) {
    return Padding(
      padding: padding,
      child: Align(
        alignment: alignment,
        child: this.icon(IconType.Gradient, size: size),
      ),
    );
  }

  // -- Returns Icon with Gradient -- //
  SonrIcon icon(IconType type, {double size = 24, Color color = Colors.white, bool alternate = false, Key key}) {
    IconGradientData gradientData;
    switch (this) {
      case Contact_SocialTile_Provider.Spotify:
        gradientData = IconGradientData(SonrIconData.spotify, FlutterGradientNames.newLife);
        break;
      case Contact_SocialTile_Provider.TikTok:
        gradientData = IconGradientData(SonrIconData.tiktok, FlutterGradientNames.premiumDark);
        break;
      case Contact_SocialTile_Provider.Instagram:
        gradientData = IconGradientData(SonrIconData.instagram, FlutterGradientNames.ripeMalinka);
        break;
      case Contact_SocialTile_Provider.Twitter:
        gradientData = IconGradientData(SonrIconData.twitter, FlutterGradientNames.partyBliss);
        break;
      case Contact_SocialTile_Provider.YouTube:
        gradientData = IconGradientData(SonrIconData.youtube, FlutterGradientNames.loveKiss, alt: SonrIconData.youtube_alt);
        break;
      case Contact_SocialTile_Provider.Medium:
        gradientData = IconGradientData(SonrIconData.medium, FlutterGradientNames.eternalConstance, alt: SonrIconData.medium_alt);
        break;
      case Contact_SocialTile_Provider.Facebook:
        gradientData = IconGradientData(SonrIconData.facebook, FlutterGradientNames.perfectBlue, alt: SonrIconData.facebook_fill);
        break;
      case Contact_SocialTile_Provider.Snapchat:
        gradientData = IconGradientData(SonrIconData.snapchat, FlutterGradientNames.sunnyMorning, alt: SonrIconData.snapchat_alt);
        break;
      case Contact_SocialTile_Provider.Github:
        gradientData = IconGradientData(SonrIconData.github, FlutterGradientNames.solidStone, alt: SonrIconData.github_alt);
        break;
      default:
        gradientData = IconGradientData(Icons.error, FlutterGradientNames.viciousStance);
        break;
    }

    return SonrIcon(
      gradientData.dataWithAlt(alternate),
      type,
      color,
      gradientData.gradient,
      size: size,
      key: key,
    );
  }
}
