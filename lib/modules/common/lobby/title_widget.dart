import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sonr_app/theme/theme.dart';

// ^ Lobby Title View ^ //
class LobbyTitleView extends StatefulWidget {
  final Function(int) onChanged;
  final String title;
  const LobbyTitleView({Key key, @required this.onChanged, this.title = ''}) : super(key: key);

  @override
  _LobbyTitleViewState createState() => _LobbyTitleViewState();
}

class _LobbyTitleViewState extends State<LobbyTitleView> {
  int toggleIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // Build Title
      widget.title != '' ? Padding(padding: EdgeWith.top(8)) : Container(),
      widget.title != ''
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [SonrIcon.location, Padding(padding: EdgeWith.right(16)), widget.title.h3])
          : Container(),

      // Build Toggle View
      Container(
        padding: EdgeInsets.only(top: 8),
        margin: EdgeWith.horizontal(24),
        child: NeumorphicToggle(
          duration: 100.milliseconds,
          style: NeumorphicToggleStyle(depth: 20, backgroundColor: UserService.isDarkMode ? SonrColor.Dark : SonrColor.White),
          thumb: Neumorphic(style: SonrStyle.toggle),
          selectedIndex: toggleIndex,
          onChanged: (val) {
            setState(() {
              toggleIndex = val;
            });
            widget.onChanged(val);
          },
          children: [
            ToggleElement(
                background: Center(child: SonrText.medium("Mobile", color: SonrColor.Grey, size: 18)),
                foreground: SonrIcon.neumorphicGradient(Icons.smartphone, FlutterGradientNames.newRetrowave, size: 24)),
            ToggleElement(
                background: Center(child: SonrText.medium("All", color: SonrColor.Grey, size: 18)),
                foreground: SonrIcon.neumorphicGradient(
                    Icons.group, UserService.isDarkMode ? FlutterGradientNames.happyUnicorn : FlutterGradientNames.eternalConstance,
                    size: 22.5)),
            ToggleElement(
                background: Center(child: SonrText.medium("Desktop", color: SonrColor.Grey, size: 18)),
                foreground: SonrIcon.neumorphicGradient(Icons.computer, FlutterGradientNames.orangeJuice, size: 24)),
          ],
        ),
      ),
      Padding(padding: EdgeInsets.only(top: 24))
    ]);
  }
}
