export 'bubble_view.dart';
export 'item_view.dart';
export 'peer_controller.dart';
export 'extensions.dart';
export 'vector_position.dart';
import 'dart:typed_data';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:sonr_app/data/data.dart';

// ^ Platform Model Extensions ^ //
extension PlatformUtils on Platform {
  FlutterGradientNames get gradient {
    switch (this) {
      case Platform.Android:
        return FlutterGradientNames.hiddenJaguar;
      case Platform.iOS:
        return FlutterGradientNames.morpheusDen;
      case Platform.MacOS:
        return FlutterGradientNames.octoberSilence;
      case Platform.Windows:
        return FlutterGradientNames.deepBlue;
      default:
        return FlutterGradientNames.viciousStance;
    }
  }
}

// ^ Proximity Model Extensions ^ //
extension ProximityUtils on Position_Proximity {
  double get maxHeight {
    // Bottom Zone
    if (this == Position_Proximity.Immediate) {
      return 235;
    }
    // Middle Zone
    else if (this == Position_Proximity.Near) {
      return 150;
    }
    // Top Zone
    else {
      return 75;
    }
  }

  double get topOffset {
    // Bottom Zone
    if (this == Position_Proximity.Immediate) {
      return 185;
    }
    // Middle Zone
    else if (this == Position_Proximity.Near) {
      return 100;
    }
    // Top Zone
    else {
      return 25;
    }
  }
}

// ^ Peer Value Checker Extensions ^ //
extension CheckerUtils on Peer {
  bool get isOnMobile {
    return this.platform == Platform.Android || this.platform == Platform.iOS;
  }

  bool get isOnDesktop {
    return this.platform == Platform.MacOS || this.platform == Platform.Windows || this.platform == Platform.Linux;
  }
}

// ^ Peer Widget Builder Extensions ^ //
extension WidgetUtils on Peer {
  SonrText get initials {
    var first = this.profile.firstName[0].toUpperCase();
    var last = this.profile.lastName[0].toUpperCase();
    return SonrText(first + last, isGradient: true, weight: FontWeight.bold, size: 34, gradient: this.platform.gradient.linear());
  }

  SonrIcon get platformIcon {
    return this.platform.icon(IconType.Gradient, size: 24);
  }

  Widget get platformExpanded {
    return SonrText("",
        isRich: true,
        richText: RichText(
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade,
            text: TextSpan(children: [
              TextSpan(
                  text: this.platform.toString(),
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 20, color: Colors.black87)),
              TextSpan(
                  text: " - ${this.model}",
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w300, fontSize: 20, color: SonrColor.Black)),
            ])));
  }

  Widget get fullName {
    return this.profile.hasLastName()
        ? SonrText.gradient(this.profile.firstName + " " + this.profile.lastName, FlutterGradientNames.frozenHeat, size: 32)
        : SonrText.gradient(this.profile.firstName, FlutterGradientNames.frozenHeat, size: 32);
  }

  Widget profilePicture({double size = 100}) {
    return Neumorphic(
      padding: EdgeInsets.all(4),
      style: NeumorphicStyle(
        boxShape: NeumorphicBoxShape.circle(),
        depth: -10,
      ),
      child: this.profile.hasPicture()
          ? Image.memory(Uint8List.fromList(this.profile.picture))
          : Icon(
              Icons.insert_emoticon,
              size: size,
              color: SonrColor.Black.withOpacity(0.5),
            ),
    );
  }
}

// ^ Position Designation Extensions ^ //
extension DesignationUtils on Position_Designation {
  bool isFacing(Position_Proximity prox) {
    return this == Position_Designation.NNE ||
        this == Position_Designation.NEbN ||
        this == Position_Designation.NbE ||
        this == Position_Designation.NE ||
        this == Position_Designation.NNE ||
        this == Position_Designation.N;
  }
}
