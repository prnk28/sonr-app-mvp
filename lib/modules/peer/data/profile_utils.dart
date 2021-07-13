import 'package:sonr_app/style/style.dart';
import 'package:sonr_app/style/buttons/utility.dart';

/// Builds Header Style text from [Profile] data
class ProfileFullName extends StatelessWidget {
  final Profile profile;

  /// If true Widget will use Gradient Text
  final bool isHeader;
  const ProfileFullName({Key? key, required this.profile, required this.isHeader}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (this.isHeader) {
      return profile.fullName.gradient(value: DesignGradients.SolidStone);
    } else {
      return Row(children: [
        "${profile.firstName.capitalizeFirst} ".paragraph(),
        profile.lastName.capitalizeFirst!.light(),
      ]);
    }
  }
}

/// Widget Text of SName from [Profile] data
class ProfileSName extends StatelessWidget {
  final Profile profile;

  /// If true Widget will use Gradient Text
  const ProfileSName({Key? key, required this.profile}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onLongPress: () async {
          await HapticFeedback.mediumImpact();
          Future.delayed(ButtonUtility.K_BUTTON_DURATION, () {
            Clipboard.setData(ClipboardData(text: ContactService.contact.value.sName));
            AppRoute.snack(
                SnackArgs.alert(title: "Copied!", message: "SName copied to clipboard", icon: Icon(SimpleIcons.Copy, color: Colors.white)));
          });
        },
        child: [
          profile.sName.lightSpan(fontSize: 20, color: AppTheme.ItemColor),
          ".snr/".paragraphSpan(fontSize: 20, color: AppTheme.GreyColor),
        ].rich());
  }
}

/// Builds Avatar Image from [Profile] data
class ProfileAvatar extends StatelessWidget {
  final Profile profile;
  final double size;
  final Color? backgroundColor;
  const ProfileAvatar({Key? key, required this.profile, this.size = 100, this.backgroundColor}) : super(key: key);

  factory ProfileAvatar.fromContact(Contact contact, {double size = 100, Color? backgroundColor}) {
    return ProfileAvatar(
      profile: contact.profile,
      size: size,
      backgroundColor: backgroundColor,
    );
  }

  factory ProfileAvatar.fromPeer(Peer peer, {double size = 100, Color? backgroundColor}) {
    return ProfileAvatar(
      profile: peer.profile,
      size: size,
      backgroundColor: backgroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
          width: size,
          height: size,
          margin: EdgeInsets.all(8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: backgroundColor ?? AppTheme.ForegroundColor,
            shape: BoxShape.circle,
          ),
          child: profile.profileImage(
            width: size * 0.7,
            height: size * 0.7,
            placeholder: SimpleIcons.User.gradient(size: size * 0.7),
          )),
    );
  }
}

/// #### View for Post View owner of File Received
class ProfileOwnerRow extends StatelessWidget {
  final Profile profile;
  const ProfileOwnerRow({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        child: Row(
          children: [
            Container(
                margin: EdgeInsets.only(top: 8, left: 8),
                decoration: BoxDecoration(color: AppColor.White, shape: BoxShape.circle, boxShadow: [
                  BoxShadow(offset: Offset(2, 2), blurRadius: 8, color: AppColor.Black.withOpacity(0.2)),
                ]),
                padding: EdgeInsets.all(4),
                child: Container(
                  child: profile.hasPicture()
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(Uint8List.fromList(profile.picture)),
                        )
                      : SimpleIcons.User.gradient(size: 24),
                )),
            Padding(child: ProfileSName(profile: profile), padding: EdgeInsets.only(left: 4)),
            Spacer(),
            Padding(
                child: ActionButton(
                  onPressed: () {},
                  iconData: SimpleIcons.Statistic,
                ),
                padding: EdgeInsets.only(right: 4)),
            ActionButton(
              onPressed: () {},
              iconData: SimpleIcons.Menu,
            ),
          ],
        ));
  }
}
