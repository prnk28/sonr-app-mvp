import 'dart:typed_data';

import 'package:sonr_app/theme/text.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

extension ContactUtils on Contact {
  String get tempUsername {
    return "@${this.firstName.substring(0, 1)}${this.lastName.substring(1)}";
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

  SonrText get webSite {
    return this.hasWebsite() ? SonrText.medium(this.website) : SonrText.medium(this.website);
  }
}

extension PeerUtils on Peer {
  SonrText initials(
      {Color color,
      FlutterGradientNames gradient = FlutterGradientNames.glassWater,
      FontWeight weight = FontWeight.bold,
      double size = 36,
      Key key}) {
    return SonrText(this.profile.firstName[0].toUpperCase(), isGradient: true, weight: weight, size: size, key: key, gradient: gradient.linear());
  }
}
