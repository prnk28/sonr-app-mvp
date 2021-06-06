import 'package:sonr_app/style.dart';

class LinkerSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: UserService.isDarkMode ? SonrColor.Black : SonrColor.White,
    );
  }
}
