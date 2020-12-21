import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_boxicons/flutter_boxicons.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonr_core/sonr_core.dart';
export 'package:flutter_gradients/flutter_gradients.dart';

// ^ Get Icon from Peer Data ^ //
NeumorphicIcon iconFromPeer(Peer peer,
    {double size = 30, Color color: Colors.white}) {
  if (peer.device.platform == "Android") {
    return NeumorphicIcon((Icons.android),
        size: size, style: NeumorphicStyle(color: color));
  } else if (peer.device.platform == "iOS") {
    return NeumorphicIcon((Icons.phone_iphone),
        size: size, style: NeumorphicStyle(color: color));
  } else {
    return NeumorphicIcon((Icons.device_unknown), size: size);
  }
}

// ^ Get Icon from Payload Data^ //
IconData iconDataFromPayload(Payload payload) {
  var kind = payload.file.mime.type;
  switch (kind) {
    case MIME_Type.audio:
      return Icons.audiotrack;
      break;
    case MIME_Type.image:
      return Icons.image;
      break;
    case MIME_Type.video:
      return Icons.video_collection;
      break;
    case MIME_Type.text:
      return Icons.sort_by_alpha;
      break;
    default:
      return Icons.device_unknown;
      break;
  }
}

// ^ Get Icon and Preview Thumbnail ^ //
Widget iconWithPreview(Metadata metadata) {
  switch (metadata.mime.type) {
    case MIME_Type.audio:
      return Icon(Icons.audiotrack, size: 100);
      break;
    case MIME_Type.image:
      if (metadata.thumbnail != null) {
        return ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
            child: FittedBox(
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: 1, minHeight: 1, maxWidth: 200), // here
                    child: Image.memory(metadata.thumbnail))));
      } else {
        return Icon(Icons.image, size: 100);
      }
      break;
    case MIME_Type.video:
      return Icon(Icons.video_collection, size: 100);
      break;
    case MIME_Type.text:
      return Icon(Icons.sort_by_alpha, size: 100);
      break;
    default:
      return Icon(Icons.device_unknown, size: 100);
      break;
  }
}

// ^ Get Gradient Icon from Social Provider ^ //
GradientIcon gradientIconFromSocialProvider(
    Contact_SocialTile_Provider provider) {
  switch (provider) {
    case Contact_SocialTile_Provider.Facebook:
      return GradientIcon(
          Boxicons.bxl_facebook_square, FlutterGradientNames.perfectBlue);
      break;
    case Contact_SocialTile_Provider.Instagram:
      return GradientIcon(
          Boxicons.bxl_instagram, FlutterGradientNames.ripeMalinka);
      break;
    case Contact_SocialTile_Provider.Medium:
      return GradientIcon(
          Boxicons.bxl_medium, FlutterGradientNames.mountainRock);
      break;
    case Contact_SocialTile_Provider.Spotify:
      return GradientIcon(Boxicons.bxl_spotify, FlutterGradientNames.newLife);
      break;
    case Contact_SocialTile_Provider.TikTok:
      return GradientIcon(Boxicons.bxl_creative_commons,
          FlutterGradientNames.premiumDark); // TODO
      break;
    case Contact_SocialTile_Provider.Twitter:
      return GradientIcon(
          Boxicons.bxl_twitter, FlutterGradientNames.partyBliss);
      break;
    case Contact_SocialTile_Provider.YouTube:
      return GradientIcon(Boxicons.bxl_youtube, FlutterGradientNames.loveKiss);
      break;
    default:
      return GradientIcon(
          Icons.device_unknown_rounded, FlutterGradientNames.aboveTheSky);
  }
}

// ^ Get Normal Icon from Social Provider ^ //
Icon iconFromSocialProvider(Contact_SocialTile_Provider provider) {
  switch (provider) {
    case Contact_SocialTile_Provider.Facebook:
      return Icon(Boxicons.bxl_facebook_square);
      break;
    case Contact_SocialTile_Provider.Instagram:
      return Icon(Boxicons.bxl_instagram);
      break;
    case Contact_SocialTile_Provider.Medium:
      return Icon(Boxicons.bxl_medium);
      break;
    case Contact_SocialTile_Provider.Spotify:
      return Icon(Boxicons.bxl_spotify);
      break;
    case Contact_SocialTile_Provider.TikTok:
      return Icon(Boxicons.bxl_creative_commons); // TODO
      break;
    case Contact_SocialTile_Provider.Twitter:
      return Icon(Boxicons.bxl_twitter);
      break;
    case Contact_SocialTile_Provider.YouTube:
      return Icon(Boxicons.bxl_youtube);
      break;
    default:
      return Icon(Icons.device_unknown_rounded);
  }
}

class GradientIcon extends StatelessWidget {
  const GradientIcon(this.iconData, this.gradientType,
      {this.size = 40, this.center = Alignment.topLeft});
  final IconData iconData;
  final double size;
  final Alignment center;
  final FlutterGradientNames gradientType;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        var gradient = FlutterGradients.findByName(gradientType);
        return gradient.createShader(bounds);
      },
      child: Icon(
        iconData,
        size: size,
        color: Colors.white,
      ),
    );
  }
}
