export 'auth_view.dart';
export 'card_view.dart';
export 'flat_view.dart';

import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

// ^ Contact Model Extensions ^ //
extension ContactUtils on Contact {
  String get tempUsername {
    return "@TempUsername";
  }

  Widget get phoneNumber {
    return this.hasPhone() ? this.phone.l : "1-555-555-5555".l;
  }

  Row get headerName {
    return Row(children: [
      SonrText.bold(this.firstName + " "),
      this.lastName.l,
    ]);
  }

  Widget get fullName {
    return this.hasLastName()
        ? SonrText.gradient(this.firstName + " " + this.lastName, FlutterGradientNames.solidStone, size: 32)
        : SonrText.gradient(this.firstName, FlutterGradientNames.solidStone, size: 32);
  }

  Widget get profilePicture {
    return this.hasPicture()
        ? Container(
            width: 120,
            height: 120,
            child: CircleAvatar(
              backgroundImage: MemoryImage(this.picture),
            ),
          )
        : Icon(
            Icons.insert_emoticon,
            size: 120,
            color: SonrColor.Black.withOpacity(0.5),
          );
  }

  Widget get webSite {
    return this.hasWebsite() ? this.website.p : Container();
  }
}
