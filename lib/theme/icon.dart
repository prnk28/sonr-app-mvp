import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

// ^ SonrIcon from SVG Data ^ //
enum IconType {
  Download,
  Settings,
  Home,
  Camera,
  Mail,
  Diamond,
  Folder,
  Gallery,
  Printer,
  Eye,
  Sandclock,
  ZoomIn,
  ZoomOut,
  Placeholder,
  Idea,
  TrashBin,
  Happy,
  Microphone,
  Notification,
  Compass,
  File,
  Alarm,
  Lock,
  Layer,
  Sound,
  Book,
  Dialogue,
  Upload,
  Target,
  Mute,
  Lifesaver,
  Protection,
  LineBars,
  Flag,
  Menu,
  Share,
  Calendar,
  Control,
  PieChart,
  User,
  BookMark,
  Battery,
  Megaphone,
  ShoppingCart,
  Medal,
  Hierarchy,
  PiggyBank,
  Internet,
  Edit,
  Filter
}

class SonrIcon extends StatelessWidget {
  final IconType icon;
  final String fileName;
  const SonrIcon({
    this.icon,
    this.fileName = "",
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (fileName.isEmpty) {
      String iconValue = icon.toString().split('.').last;
      var name = iconValue.replaceAll(new RegExp(r'/([A-Z]+)/g'), ' ');
      var idx = icon.index;
      var path = "0$idx-$name";
      return SvgPicture.asset("assets/icons/" + path);
    } else {
      String iconValue = icon.toString().split('.').last;
      var name = iconValue.replaceAll(new RegExp(r'/([A-Z]+)/g'), ' ');
      var idx = icon.index;
      var path = "0$idx-$name";
      return SvgPicture.asset("assets/icons/" + path);
    }
  }
}
