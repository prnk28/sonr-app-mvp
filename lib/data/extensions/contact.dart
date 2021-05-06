import 'package:sonr_app/style/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart';

// ^ Contact Model Extensions ^ //
extension ContactUtils on Contact {
  Widget headerNameText() {
    return Row(children: [
      "${this.firstName} ".h6,
      this.lastName.l,
    ]);
  }

  Widget fullNameText() {
    return "${this.fullName}".gradient(value: SonrGradients.SolidStone);
  }

  Widget pictureImage() {
    return this.hasPicture()
        ? Container(
            width: 120,
            height: 120,
            child: CircleAvatar(
              backgroundImage: MemoryImage(this.profile.picture as Uint8List),
            ),
          )
        : Icon(
            Icons.insert_emoticon,
            size: 120,
            color: SonrColor.Black.withOpacity(0.5),
          );
  }
}
