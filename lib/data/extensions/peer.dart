import 'dart:typed_data';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart';

/// ^ Peer Widget Builder Extensions ^ //
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
        ? "${this.profile.firstName} ${this.profile.lastName}".gradient(value: SonrGradients.FrozenHeat)
        : "${this.profile.firstName}".gradient(value: SonrGradients.FrozenHeat);
  }

  Widget profilePicture({double size = 100}) {
    return Container(
        decoration: Neumorphic.indented(shape: BoxShape.circle),
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
