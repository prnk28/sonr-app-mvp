import 'dart:typed_data';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_plugin/sonr_plugin.dart';

// ^ Proximity Model Extensions ^ //
extension PositionUtils on Position {
  double get maxHeight {
    // Bottom Zone
    if (this.proximity == Position_Proximity.Immediate) {
      return 235;
    }
    // Middle Zone
    else if (this.proximity == Position_Proximity.Near) {
      return 150;
    }
    // Top Zone
    else {
      return 75;
    }
  }

  double get topOffset {
    // Bottom Zone
    if (this.proximity == Position_Proximity.Immediate) {
      return 185;
    }
    // Middle Zone
    else if (this.proximity == Position_Proximity.Near) {
      return 100;
    }
    // Top Zone
    else {
      return 25;
    }
  }

  String get directionString {
    // Calculated
    var adjustedDegrees = this.heading.direction.round();
    final unit = "°";

    // @ Convert To String
    if (adjustedDegrees >= 0 && adjustedDegrees <= 9) {
      return "0" + "0" + adjustedDegrees.toString() + unit;
    } else if (adjustedDegrees > 9 && adjustedDegrees <= 99) {
      return "0" + adjustedDegrees.toString() + unit;
    } else {
      return adjustedDegrees.toString() + unit;
    }
  }

  String get cardinalValueString {
    var adjustedDesignation = ((this.heading.direction.round() / 11.25) + 0.25).toInt();
    var compassEnum = Cardinal.values[(adjustedDesignation % 32)];
    return compassEnum.toString().substring(compassEnum.toString().indexOf('.') + 1);
  }
}

// ^ Peer Widget Builder Extensions ^ //
extension WidgetUtils on Peer {
  Widget get initials => this.profile.initials.h6;

  Widget get platformExpanded {
    return RichText(
        textAlign: TextAlign.center,
        overflow: TextOverflow.fade,
        text: TextSpan(children: [
          TextSpan(
              text: this.platform.toString(),
              style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w600, fontSize: 20, color: Colors.black87)),
          TextSpan(
              text: " - ${this.model}", style: TextStyle(fontFamily: 'Manrope', fontWeight: FontWeight.w300, fontSize: 20, color: SonrColor.Black)),
        ]));
  }

  Widget get fullName {
    return this.profile.hasLastName()
        ? "${this.profile.firstName} ${this.profile.lastName}".gradient(gradient: FlutterGradientNames.frozenHeat)
        : "${this.profile.firstName}".gradient(gradient: FlutterGradientNames.frozenHeat);
  }

  Widget profilePicture({double size = 100}) {
    return Container(
        decoration: Neumorph.indented(shape: BoxShape.circle),
        padding: EdgeInsets.all(4),
        child: Container(
          width: size,
          height: size,
          child: profile.hasPicture()
              ? CircleAvatar(
                  backgroundImage: MemoryImage(Uint8List.fromList(profile.picture)),
                )
              : SonrIcons.Avatar.greyWith(size: size),
        ));
  }
}
