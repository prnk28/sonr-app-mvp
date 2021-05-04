import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_plugin/sonr_plugin.dart';

// ^ Contact Model Extensions ^ //
extension ContactUtils on Contact {
  Row get headerName {
    return Row(children: [
      "${this.profile.firstName} ".h6,
      this.profile.lastName.l,
    ]);
  }

  Widget get fullName {
    return this.profile.hasLastName()
        ? "${this.profile.firstName} ${this.profile.lastName}".gradient(gradient: FlutterGradientNames.solidStone)
        : "${this.profile.firstName}".gradient(gradient: FlutterGradientNames.solidStone);
  }

  Widget get profilePicture {
    return this.profile.hasPicture()
        ? Container(
            width: 120,
            height: 120,
            child: CircleAvatar(
              backgroundImage: MemoryImage(this.profile.picture),
            ),
          )
        : Icon(
            Icons.insert_emoticon,
            size: 120,
            color: SonrColor.Black.withOpacity(0.5),
          );
  }
}
