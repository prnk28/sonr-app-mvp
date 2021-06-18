import 'package:sonr_app/style.dart';

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
