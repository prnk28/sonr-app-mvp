import 'package:sonr_app/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart';

/// Builds Avatar Image from [Profile] data
class ProfileAvatar extends StatelessWidget {
  final Profile profile;
  final double size;
  const ProfileAvatar({Key? key, required this.profile, this.size = 100}) : super(key: key);

  factory ProfileAvatar.fromContact(Contact contact, {double size = 100}) {
    return ProfileAvatar(profile: contact.profile, size: size);
  }

  factory ProfileAvatar.fromPeer(Peer peer, {double size = 100}) {
    return ProfileAvatar(profile: peer.profile, size: size);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: SonrTheme.foregroundColor, shape: BoxShape.circle, boxShadow: SonrTheme.boxShadow),
            padding: EdgeInsets.all(4),
            child: Container(
              width: size,
              height: size,
              child: profile.hasPicture()
                  ? CircleAvatar(
                                              backgroundColor: SonrTheme.foregroundColor,
                      foregroundImage: MemoryImage(Uint8List.fromList(profile.picture)),
                    )
                  : SonrIcons.User.gradient(size: size * 0.7),
            )
    );
  }
}

/// Builds Header Style text from [Profile] data
class ProfileName extends StatelessWidget {
  final Profile profile;

  /// If true Widget will use Gradient Text
  final bool isHeader;
  const ProfileName({Key? key, required this.profile, required this.isHeader}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (this.isHeader) {
      return "${profile.firstName} ${profile.lastName}".gradient(value: SonrGradients.SolidStone);
    } else {
      return Row(children: ["${profile.firstName} ".paragraph(), profile.lastName.light()]);
    }
  }
}
