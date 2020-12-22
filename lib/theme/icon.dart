import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
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

    // Get Icon
    switch (kind) {
      case MIME_Type.audio:
        return SonrIcon(
          Icons.audiotrack,
          type,
          color,
          gradient,
          thumbnail: thumbnail,
          size: size,
        );
        break;
      case MIME_Type.image:
        return SonrIcon(
          Icons.image,
          type,
          color,
          gradient,
          thumbnail: thumbnail,
          size: size,
        );
        break;
      case MIME_Type.video:
        return SonrIcon(
          Icons.video_collection,
          type,
          color,
          gradient,
          thumbnail: thumbnail,
          size: size,
        );
        break;
      case MIME_Type.text:
        return SonrIcon(
          Icons.sort_by_alpha,
          type,
          color,
          gradient,
          thumbnail: thumbnail,
          size: size,
        );
        break;
      default:
        return SonrIcon(
          Icons.device_unknown,
          type,
          color,
          gradient,
          thumbnail: thumbnail,
          size: size,
        );
        break;
    }
  }

  // ^ Payload Data File Type to Icon
  factory SonrIcon.socialFromProvider(
      IconType type, Contact_SocialTile_Provider provider,
      {double size}) {
    // Set Size
    if (type == IconType.Normal && size == null) {
      size = 24;
    } else {
      size = 40;
    }

    // Get Icon
    switch (provider) {
      case Contact_SocialTile_Provider.Facebook:
        return SonrIcon(
          Boxicons.bxl_facebook_square,
          type,
          Colors.black,
          FlutterGradientNames.perfectBlue,
          size: size,
        );
        break;
      case Contact_SocialTile_Provider.Instagram:
        return SonrIcon(
          Boxicons.bxl_instagram,
          type,
          Colors.black,
          FlutterGradientNames.ripeMalinka,
          size: size,
        );
        break;
      case Contact_SocialTile_Provider.Medium:
        return SonrIcon(
          Boxicons.bxl_medium,
          type,
          Colors.black,
          FlutterGradientNames.mountainRock,
          size: size,
        );
        break;
      case Contact_SocialTile_Provider.Spotify:
        return SonrIcon(Boxicons.bxl_spotify, type, Colors.black,
            FlutterGradientNames.newLife,
            size: size);
        break;
      case Contact_SocialTile_Provider.TikTok:
        // TODO
        return SonrIcon(
          Boxicons.bxl_creative_commons,
          type,
          Colors.black,
          FlutterGradientNames.premiumDark,
          size: size,
        );
        break;
      case Contact_SocialTile_Provider.Twitter:
        return SonrIcon(
          Boxicons.bxl_twitter,
          type,
          Colors.black,
          FlutterGradientNames.partyBliss,
          size: size,
        );
        break;
      case Contact_SocialTile_Provider.YouTube:
        return SonrIcon(
          Boxicons.bxl_youtube,
          type,
          Colors.black,
          FlutterGradientNames.loveKiss,
          size: size,
        );
        break;
      default:
        return SonrIcon(
          Icons.device_unknown_rounded,
          type,
          Colors.black,
          FlutterGradientNames.aboveTheSky,
          size: size,
        );
    }
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
