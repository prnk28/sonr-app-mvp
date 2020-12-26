import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonr_core/sonr_core.dart';

import 'color.dart';
export 'package:flutter_gradients/flutter_gradients.dart';

enum IconType { Neumorphic, Normal, Gradient, Thumbnail }
enum SocialIcon {
  Spotify,
  Twitter,
  Instagram,
  YouTube,
  Medium,
  Facebook,
  Snapchat
}

class SonrIcon extends StatelessWidget {
  final IconData data;
  final IconType type;
  final double size;
  final FlutterGradientNames gradient;
  final Color color;
  final List<int> thumbnail;

  SonrIcon(this.data, this.type, this.color, this.gradient,
      {this.thumbnail, this.size});

  // ^ Gradient Icon with Provided Data
  factory SonrIcon.gradient(
    IconData data,
    FlutterGradientNames gradient, {
    double size = 40,
  }) {
    return SonrIcon(data, IconType.Gradient, Colors.white, gradient,
        size: size);
  }

  // ^ Gradient Icon with Provided Data
  factory SonrIcon.neumorphic(IconData data,
      {double size = 30, Color color = K_BASE_COLOR}) {
    return SonrIcon(data, IconType.Neumorphic, color, null, size: size);
  }

  // ^ Gradient Icon with Provided Data
  factory SonrIcon.normal(IconData data,
      {double size = 24, Color color = K_BASE_COLOR}) {
    return SonrIcon(data, IconType.Normal, color, null, size: size);
  }

  factory SonrIcon.social(IconType type, Contact_SocialTile_Provider social,
      {double size = 24, Color color = Colors.black, bool alternate = false}) {
    // Init Icon Data
    IconData data;
    FlutterGradientNames gradient;

    // Check Icon Type
    switch (social) {
      case Contact_SocialTile_Provider.Spotify:
        data = _SocialIcons.spotify;
        gradient = FlutterGradientNames.newLife;
        break;
      case Contact_SocialTile_Provider.TikTok:
        data = _SocialIcons.tiktok;
        gradient = FlutterGradientNames.premiumDark;
        break;
      case Contact_SocialTile_Provider.Instagram:
        data = _SocialIcons.instagram;
        gradient = FlutterGradientNames.ripeMalinka;
        break;
      case Contact_SocialTile_Provider.Twitter:
        data = alternate ? _SocialIcons.retweet : _SocialIcons.twitter;
        gradient = FlutterGradientNames.partyBliss;
        break;
      case Contact_SocialTile_Provider.YouTube:
        data = alternate ? _SocialIcons.youtube_text : _SocialIcons.youtube;
        gradient = FlutterGradientNames.loveKiss;
        break;
      case Contact_SocialTile_Provider.Medium:
        data = alternate ? _SocialIcons.medium_fill : _SocialIcons.medium;
        gradient = FlutterGradientNames.mountainRock;
        break;
      case Contact_SocialTile_Provider.Facebook:
        data = alternate ? _SocialIcons.facebook_fill : _SocialIcons.facebook;
        gradient = FlutterGradientNames.perfectBlue;
        break;
      // case Contact_SocialTile_Provider.Snapchat:
      //   data = alternate ? _SocialIcons.snapchat_fill : _SocialIcons.snapchat;
      //   break;
      default:
        data = Icons.device_unknown_rounded;
        gradient = FlutterGradientNames.aboveTheSky;
    }

    // Create Icon
    return SonrIcon(data, type, color, gradient, size: size);
  }

  // ^ Peer Data Platform to Icon
  factory SonrIcon.deviceFromPeer(IconType type, Peer peer,
      {Color color, double size = 30}) {
    // Set Color
    if (type == IconType.Normal) {
      color = Colors.white;
    } else {
      color = K_BASE_COLOR;
    }

    // Get Icon
    if (peer.device.platform == "Android") {
      return SonrIcon(
        Icons.android,
        type,
        color,
        FlutterGradientNames.dustyGrass,
        size: size,
      );
    } else if (peer.device.platform == "iOS") {
      return SonrIcon(
        Icons.phone_iphone,
        type,
        color,
        FlutterGradientNames.highFlight,
        size: size,
      );
    } else {
      return SonrIcon(
        Icons.device_unknown,
        type,
        color,
        FlutterGradientNames.highFlight,
        size: size,
      );
    }
  }

  // ^ Payload Data File Type to Icon
  factory SonrIcon.metaFromPayload(IconType type, Payload payload,
      {double size = 30,
      Color color = Colors.black,
      FlutterGradientNames gradient = FlutterGradientNames.orangeJuice}) {
    // Get Metadata
    var kind = payload.file.mime.type;
    var thumbnail = payload.file.thumbnail;
    IconData data;

    // Get Icon
    switch (kind) {
      case MIME_Type.audio:
        data = Icons.audiotrack;
        break;
      case MIME_Type.image:
        data = Icons.image;
        break;
      case MIME_Type.video:
        data = Icons.video_collection;
        break;
      case MIME_Type.text:
        data = Icons.sort_by_alpha;
        break;
      default:
        data = Icons.device_unknown;
        break;
    }

    // Return Widget
    return SonrIcon(
      data,
      type,
      color,
      gradient,
      thumbnail: thumbnail,
      size: size,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget result;
    switch (type) {
      // @ Creates Neumorphic Icon
      case IconType.Neumorphic:
        result = NeumorphicIcon((data),
            size: size, style: NeumorphicStyle(color: color));
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
                      constraints: BoxConstraints(
                          minWidth: 1, minHeight: 1, maxWidth: 200), // here
                      child: Image.memory(thumbnail))));
        } else {
          result = Icon(data, size: size);
        }
        break;
    }
    return result;
  }
}

class _SocialIcons {
  _SocialIcons._();

  static const _kFontFam = 'SonrSocialIcons';
  static const _kFontPkg = null;

  static const IconData spotify =
      IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData retweet =
      IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData youtube_text =
      IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData youtube =
      IconData(0xf167, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData instagram =
      IconData(0xf16d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData medium_fill =
      IconData(0xf23a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData snapchat =
      IconData(0xf2ac, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData snapchat_fill =
      IconData(0xf2ad, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData tiktok =
      IconData(0xe803, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData facebook =
      IconData(0xf300, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData facebook_fill =
      IconData(0xf301, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData twitter =
      IconData(0xf309, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData medium =
      IconData(0xf3c7, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}
