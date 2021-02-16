import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonr_core/sonr_core.dart';

import 'color.dart';
export 'package:flutter_gradients/flutter_gradients.dart';

enum IconType { Neumorphic, Normal, Gradient, Thumbnail }

class SonrIcon extends StatelessWidget {
  final IconData data;
  final IconType type;
  final double size;
  final FlutterGradientNames gradient;
  final Color color;
  final List<int> thumbnail;

  SonrIcon(this.data, this.type, this.color, this.gradient, {this.thumbnail, this.size});

  // ^ Gradient Icon with Provided Data
  factory SonrIcon.gradient(
    IconData data,
    FlutterGradientNames gradient, {
    double size = 40,
  }) {
    return SonrIcon(data, IconType.Gradient, Colors.white, gradient, size: size);
  }

  // ^ Gradient Icon with Provided Data
  factory SonrIcon.neumorphic(IconData data, {double size = 30, Color color = SonrColor.base}) {
    return SonrIcon(data, IconType.Neumorphic, color, null, size: size);
  }

  // ^ Gradient Icon with Provided Data
  factory SonrIcon.normal(IconData data, {double size = 24, Color color = SonrColor.base}) {
    return SonrIcon(data, IconType.Normal, color, null, size: size);
  }

  // ^ Social Type Icon
  factory SonrIcon.social(IconType type, Contact_SocialTile_Provider social, {double size = 24, Color color = Colors.black, bool alternate = false}) {
    // Init Icon Data
    _IconGradientWData result = _SonrIconData.socials[social];
    return SonrIcon(result.data(alternate), type, color, result.gradient, size: size);
  }

  // ^ Peer Data Platform to Icon
  factory SonrIcon.device(IconType type, Peer peer, {Color color, double size = 30}) {
    // Set Color
    _IconGradientWData result = _SonrIconData.devices[peer.platform];

    // Get Icon
    if (result != null) {
      return SonrIcon(
        result._data,
        type,
        color,
        result.gradient,
        size: size,
      );
    } else {
      return SonrIcon(
        Icons.device_unknown,
        type,
        color,
        FlutterGradientNames.viciousStance,
        size: size,
      );
    }
  }

  // ^ Payload Data File Type to Icon with Preview
  factory SonrIcon.payload(IconType type, Payload payload,
      {double size = 30, Color color = Colors.black, FlutterGradientNames gradient = FlutterGradientNames.orangeJuice}) {
    IconData data;
    if (payload == Payload.CONTACT) {
      data = _SonrIconData.contact;
    } else if (payload == Payload.MEDIA) {
      data = _SonrIconData.video;
    } else {
      data = _SonrIconData.url;
    }
    return SonrIcon(
      data,
      type,
      color,
      gradient,
      size: size,
    );
  }

  // ^ Peer Data Platform to Icon
  factory SonrIcon.platform(IconType type, Platform platform, {Color color, double size = 30}) {
    // Set Color
    _IconGradientWData result = _SonrIconData.devices[platform];

    // Get Icon
    if (result != null) {
      return SonrIcon(
        result._data,
        type,
        color,
        result.gradient,
        size: size,
      );
    } else {
      return SonrIcon(
        Icons.device_unknown,
        type,
        color,
        FlutterGradientNames.viciousStance,
        size: size,
      );
    }
  }

  // ^ Payload Data from Metadata
  factory SonrIcon.preview(IconType type, TransferCard card,
      {double size = 30, Color color = Colors.black, FlutterGradientNames gradient = FlutterGradientNames.orangeJuice}) {
    return SonrIcon(
      _SonrIconData.files[card.properties.mime.type],
      type,
      color,
      gradient,
      thumbnail: card.preview,
      size: size,
    );
  }

  // ^ Payload Data File Type to Icon
  factory SonrIcon.share({
    IconType type = IconType.Gradient,
    bool isUrl = false,
    double size = 40,
    Color color = Colors.black,
  }) {
    // Set Icon for URL and Media
    IconData data = isUrl ? _SonrIconData.url : _SonrIconData.video;
    FlutterGradientNames gradient = isUrl ? FlutterGradientNames.magicRay : FlutterGradientNames.octoberSilence;

    return SonrIcon(
      data,
      type,
      color,
      gradient,
      size: size,
    );
  }

  // ^ UI Icons ^ //
  static SonrIcon get success => SonrIcon(_SonrIconData.success, IconType.Normal, Colors.black, null);

  static SonrIcon get missing => SonrIcon(_SonrIconData.missing, IconType.Normal, Colors.black, null);

  static SonrIcon get error => SonrIcon(_SonrIconData.error, IconType.Normal, Colors.black, null);

  static SonrIcon get cancel => SonrIcon(_SonrIconData.cancel, IconType.Normal, Colors.black, null);

  static SonrIcon get info => SonrIcon.gradient(_SonrIconData.info, FlutterGradientNames.deepBlue, size: 20);

  static SonrIcon get back => SonrIcon.gradient(Icons.arrow_left, FlutterGradientNames.eternalConstance, size: 30);

  static SonrIcon get forward => SonrIcon.gradient(Icons.arrow_right, FlutterGradientNames.morpheusDen, size: 30);

  static SonrIcon get close => SonrIcon.gradient(Icons.close, FlutterGradientNames.phoenixStart, size: 36);

  static SonrIcon get accept => SonrIcon.gradient(Icons.check, FlutterGradientNames.newLife, size: 36);

  static SonrIcon get profile => SonrIcon.gradient(Icons.person_outline, FlutterGradientNames.itmeoBranding, size: 36);

  static SonrIcon get search => SonrIcon.gradient(Icons.search, FlutterGradientNames.plumBath, size: 36);

  static SonrIcon get more => SonrIcon.gradient(Icons.more_horiz_outlined, FlutterGradientNames.northMiracle, size: 36);

  static SonrIcon get settings => SonrIcon.gradient(_SonrIconData.gear, FlutterGradientNames.northMiracle, size: 36);

  static SonrIcon get multiSettings => SonrIcon.gradient(_SonrIconData.params, FlutterGradientNames.northMiracle, size: 36);

  static SonrIcon get send => SonrIcon.gradient(_SonrIconData.paperPlane, FlutterGradientNames.glassWater, size: 24);

  static SonrIcon get video => SonrIcon.gradient(_SonrIconData.video, FlutterGradientNames.glassWater, size: 28);

  static Padding socialBadge(Contact_SocialTile_Provider prov,
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
        child: SonrIcon.social(IconType.Gradient, prov, size: size),
      ),
    );
  }

  // ^ Build View of Icon ^ //
  @override
  Widget build(BuildContext context) {
    Widget result;
    switch (type) {
      // @ Creates Neumorphic Icon
      case IconType.Neumorphic:
        result = NeumorphicIcon((data), size: size, style: NeumorphicStyle(color: color));
        break;

      // @ Creates Normal Icon
      case IconType.Normal:
        result = Icon(data, size: size, color: color);
        break;

      // @ Creates Gradient Icon
      case IconType.Gradient:
        result = ShaderMask(
          shaderCallback: (bounds) {
            var grad = FlutterGradients.findByName(gradient);
            return grad.createShader(bounds);
          },
          child: Icon(
            data,
            size: size,
            color: Colors.white,
          ),
        );
        break;

      // @ Creates Thumbnail or Icon
      case IconType.Thumbnail:
        if (thumbnail != null) {
          result = ClipRRect(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
              child: FittedBox(
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.bottomCenter,
                  child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: 1, minHeight: 1, maxWidth: 200, maxHeight: 200), // here
                      child: Image.memory(thumbnail))));
        } else {
          result = Icon(data, size: size);
        }
        break;
    }
    return result;
  }
}

class _SonrIconData {
  _SonrIconData._();
  static const _kFontFam = 'SonrIcons';
  static const _kFontPkg = null;
  static const IconData iphone = IconData(0xe804, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData android = IconData(0xe805, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData mac = IconData(0xe809, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData windows = IconData(0xe80a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData spotify = IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData twitter_rt = IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData youtube_text = IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData tiktok = IconData(0xe803, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData url = IconData(0xe806, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData contact = IconData(0xe807, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData image = IconData(0xe80e, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData success = IconData(0xe815, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData cancel = IconData(0xe818, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData missing = IconData(0xe81e, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData info = IconData(0xe81f, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData github = IconData(0xf09b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData text = IconData(0xf0f6, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData github_alt = IconData(0xf113, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData youtube = IconData(0xf167, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData instagram = IconData(0xf16d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData audio = IconData(0xf1c7, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData medium_fill = IconData(0xf23a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData snapchat = IconData(0xf2ac, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData snapchat_fill = IconData(0xf2ad, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData facebook = IconData(0xf300, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData facebook_fill = IconData(0xf301, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData twitter = IconData(0xf309, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData medium = IconData(0xf3c7, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData video = IconData(0xf87c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData error = IconData(0xe808, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData paperPlane = IconData(0xf1d9, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData gear = IconData(0xe80c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData params = IconData(0xe80d, fontFamily: _kFontFam, fontPackage: _kFontPkg);

  // ^ SocialProvider to Icon Map ^ //
  static Map<Contact_SocialTile_Provider, _IconGradientWData> socials = {
    Contact_SocialTile_Provider.Spotify: _IconGradientWData(_SonrIconData.spotify, FlutterGradientNames.newLife),
    Contact_SocialTile_Provider.TikTok: _IconGradientWData(_SonrIconData.tiktok, FlutterGradientNames.premiumDark),
    Contact_SocialTile_Provider.Instagram: _IconGradientWData(_SonrIconData.instagram, FlutterGradientNames.ripeMalinka),
    Contact_SocialTile_Provider.Twitter: _IconGradientWData(_SonrIconData.twitter, FlutterGradientNames.partyBliss, alt: _SonrIconData.twitter_rt),
    Contact_SocialTile_Provider.YouTube: _IconGradientWData(_SonrIconData.youtube, FlutterGradientNames.loveKiss, alt: _SonrIconData.youtube_text),
    Contact_SocialTile_Provider.Medium:
        _IconGradientWData(_SonrIconData.medium, FlutterGradientNames.eternalConstance, alt: _SonrIconData.medium_fill),
    Contact_SocialTile_Provider.Facebook:
        _IconGradientWData(_SonrIconData.facebook, FlutterGradientNames.perfectBlue, alt: _SonrIconData.facebook_fill),
    Contact_SocialTile_Provider.Snapchat:
        _IconGradientWData(_SonrIconData.snapchat, FlutterGradientNames.sunnyMorning, alt: _SonrIconData.snapchat_fill),
    Contact_SocialTile_Provider.Github: _IconGradientWData(_SonrIconData.github, FlutterGradientNames.solidStone, alt: _SonrIconData.github_alt),
  };

  // ^ Device Platform to Icon Map ^ //
  static Map<Platform, _IconGradientWData> devices = {
    Platform.Android: _IconGradientWData(_SonrIconData.android, FlutterGradientNames.glassWater),
    Platform.iOS: _IconGradientWData(_SonrIconData.iphone, FlutterGradientNames.glassWater),
    Platform.MacOS: _IconGradientWData(_SonrIconData.mac, FlutterGradientNames.glassWater),
    Platform.Windows: _IconGradientWData(_SonrIconData.windows, FlutterGradientNames.glassWater),
  };

  // ^ File Type to Icon Map ^ //
  static Map<MIME_Type, IconData> files = {
    MIME_Type.audio: _SonrIconData.audio,
    MIME_Type.image: _SonrIconData.image,
    MIME_Type.text: _SonrIconData.text,
    MIME_Type.video: _SonrIconData.video,
  };
}

class _IconGradientWData {
  final FlutterGradientNames gradient;
  final IconData _data;
  final IconData alt;
  const _IconGradientWData(this._data, this.gradient, {this.alt});

  IconData data(bool isAlt) {
    return isAlt ? alt : _data;
  }
}
