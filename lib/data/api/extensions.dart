import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_app/modules/profile/edit_dialog.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:sonr_app/data/data.dart';


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

  String get asString {
    if (this == Payload.PDF) {
      return this.toString();
    }
    return this.toString().capitalizeFirst;
  }

  bool get isFile {
    return this != Payload.UNDEFINED && this != Payload.CONTACT && this != Payload.URL;
  }

  bool get isMedia {
    return this == Payload.MEDIA;
  }
}

// ^ TransferCard Model Extensions ^ //
extension TransferCardUtils on TransferCard {
  String get inviteSizeString {
    return this.metadata.size.sizeText();
  }

  SonrText get ownerNameText {
    return SonrText.bold(" ${this.firstName} ${this.lastName}", size: 16, color: Colors.grey[600]);
  }

  SonrIcon get ownerPlatformIcon {
    return this.owner.platform.icon(IconType.Normal, color: Colors.grey[600], size: 18);
  }

  String get payloadString {
    if (this.payload == Payload.PDF) {
      return this.payload.toString();
    }
    return this.payload.toString().capitalizeFirst;
  }
}

extension ProfileUtils on Profile {
  SonrText get nameText {
    return SonrText.bold(" ${this.firstName} ${this.lastName}", size: 16, color: Colors.grey[600]);
  }

  SonrIcon get platformIcon {
    return this.platform.icon(IconType.Normal, color: Colors.grey[600], size: 18);
  }
}
