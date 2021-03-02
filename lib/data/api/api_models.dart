import 'dart:math';
import 'dart:typed_data';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_app/modules/profile/edit_dialog.dart';
import 'package:sonr_core/sonr_core.dart';

// ^ Contact Model Extensions ^ //
extension ContactUtils on Contact {
  String get tempUsername {
    return "@TempUsername";
  }

  SonrText get phoneNumber {
    return this.hasPhone() ? SonrText.light(this.phone, size: 16) : SonrText.light("1-555-555-5555", size: 16);
  }

  Row get headerName {
    return Row(children: [
      SonrText.bold(this.firstName + " "),
      SonrText.light(this.lastName),
    ]);
  }

  SonrText get fullName {
    return this.hasLastName()
        ? SonrText.gradient(this.firstName + " " + this.lastName, FlutterGradientNames.solidStone, size: 32)
        : SonrText.gradient(this.firstName, FlutterGradientNames.solidStone, size: 32);
  }

  Widget get profilePicture {
    return this.hasPicture()
        ? Image.memory(Uint8List.fromList(this.picture))
        : Icon(
            Icons.insert_emoticon,
            size: 120,
            color: Colors.black.withOpacity(0.5),
          );
  }

  Widget get webSite {
    return this.hasWebsite() ? SonrText.medium(this.website) : Container();
  }
}

// ^ Edit Sheet View for Profile ^ //
enum EditType { ColorCombo, NameField }

extension EditTypeUtils on EditType {
  Widget get view {
    switch (this) {
      case EditType.ColorCombo:
        return EditColorsView();
        break;
      case EditType.NameField:
        return EditNameView();
        break;
      default:
        return Container();
        break;
    }
  }
}

// ^ Peer Model Extensions ^ //
extension PeerUtils on Peer {
  SonrText get initials {
    var first = this.profile.firstName[0].toUpperCase();
    var last = this.profile.lastName[0].toUpperCase();
    return SonrText(first + last, isGradient: true, weight: FontWeight.bold, size: 36, gradient: FlutterGradientNames.glassWater.linear());
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
              TextSpan(text: this.platform.toString(), style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.black87)),
              TextSpan(text: " - ${this.model}", style: GoogleFonts.poppins(fontWeight: FontWeight.w300, fontSize: 20, color: Colors.black)),
            ])));
  }

  Widget get fullName {
    return this.profile.hasLastName()
        ? SonrText.gradient(this.profile.firstName + " " + this.profile.lastName, FlutterGradientNames.frozenHeat, size: 32)
        : SonrText.gradient(this.profile.firstName, FlutterGradientNames.frozenHeat, size: 32);
  }

  Widget get profilePicture {
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
              size: 100,
              color: Colors.black.withOpacity(0.5),
            ),
    );
  }
}

// ^ Payload Model Extensions ^ //
extension PayloadUtils on Payload {
  FlutterGradientNames get gradientName {
    return [
      FlutterGradientNames.itmeoBranding,
      FlutterGradientNames.norseBeauty,
      FlutterGradientNames.summerGames,
      FlutterGradientNames.healthyWater,
      FlutterGradientNames.frozenHeat,
      FlutterGradientNames.mindCrawl,
      FlutterGradientNames.seashore
    ].random();
  }
}

// ^ TransferCard Model Extensions ^ //
extension TransferCardUtils on TransferCard {
  String get hasExportedString {
    if (this.hasExported) {
      return "YES";
    } else {
      return "NO";
    }
  }

  String get inviteSizeString {
    return this.properties.size.sizeText();
  }

  String get metaSizeString {
    // @ Less than 1KB
    if (this.metadata.size < pow(10, 3)) {
      return "$this B";
    }
    // @ Less than 1MB
    else if (this.metadata.size >= pow(10, 3) && this.metadata.size < pow(10, 6)) {
      // Adjust Size Value, Return String
      var adjusted = this.metadata.size / pow(10, 3);
      return "${double.parse((adjusted).toStringAsFixed(2))} KB";
    }
    // @ Less than 1GB
    else if (this.metadata.size >= pow(10, 6) && this.metadata.size < pow(10, 9)) {
      // Adjust Size Value, Return String
      var adjusted = this.metadata.size / pow(10, 6);
      return "${double.parse((adjusted).toStringAsFixed(2))} MB";
    }
    // @ Greater than GB
    else {
      // Adjust Size Value, Return String
      var adjusted = this.metadata.size / pow(10, 9);
      return "${double.parse((adjusted).toStringAsFixed(2))} GB";
    }
  }

  String get metaMimeString {
    return this.metadata.mime.type.toString().capitalizeFirst;
  }

  SonrText get ownerNameText {
    return SonrText.bold(" ${this.firstName} ${this.lastName}", size: 16, color: Colors.grey[600]);
  }

  SonrIcon get ownerPlatformIcon {
    return this.platform.icon(IconType.Normal, color: Colors.grey[600], size: 18);
  }

  String get payloadString {
    if (this.payload == Payload.PDF) {
      return this.payload.toString();
    }
    return this.payload.toString().capitalizeFirst;
  }
}
