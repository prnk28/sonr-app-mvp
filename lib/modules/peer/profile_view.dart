import 'package:sonr_app/style/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart';

/// Builds Avatar Image from [Profile] data
class ProfileAvatar extends StatelessWidget {
  final Profile profile;
  const ProfileAvatar({Key? key, required this.profile}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return profile.hasPicture()
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

/// Builds Header Style text from [Profile] data
class ProfileHeaderName extends StatelessWidget {
  final Profile profile;
  const ProfileHeaderName({Key? key, required this.profile}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      "${profile.firstName} ".h6,
      profile.lastName.l,
    ]);
  }
}
