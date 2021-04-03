import 'package:sonr_app/theme/theme.dart';

class SettingsSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      height: Get.height / 3 + 40,
      child: Stack(children: [
        Container(
            width: Get.width,
            child: Container(
              child: Column(children: [
                // @ Title of Pane
                Align(
                  heightFactor: 0.9,
                  alignment: Alignment.topCenter,
                  child: SonrText.header("Settings", size: 45),
                ),
                Padding(padding: EdgeInsetsX.top(24)),

                // @ Dark Mode
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  // Dark Mode Title
                  SonrText.medium("Dark Mode"),

                  // Dark Mode Switch
                  NeumorphicSwitch(
                    style: NeumorphicSwitchStyle(
                      activeTrackColor: UserService.isDarkMode ? SonrPalette.Red : SonrColor.Blue,
                      inactiveTrackColor: UserService.isDarkMode ? SonrColor.Dark : SonrColor.White,
                    ),
                    value: UserService.isDarkMode,
                    onChanged: (val) => UserService.toggleDarkMode(),
                  )
                ]),
                Padding(padding: EdgeInsetsX.top(16)),

                // @ Flat Mode
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  // Dark Mode Title
                  SonrText.medium("Flat Mode"),

                  // Dark Mode Switch
                  NeumorphicSwitch(
                    style: NeumorphicSwitchStyle(
                      activeTrackColor: UserService.isDarkMode ? SonrPalette.Red : SonrColor.Blue,
                      inactiveTrackColor: UserService.isDarkMode ? SonrColor.Dark : SonrColor.White,
                    ),
                    value: UserService.flatModeEnabled,
                    onChanged: (val) => UserService.toggleFlatMode(),
                  )
                ]),
                Padding(padding: EdgeInsetsX.top(16)),
                // Dark Mode Title
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  // Dark Mode Title
                  SonrText.medium("Dark Mode"),

                  // Dark Mode Switch
                  NeumorphicSwitch(
                    style: NeumorphicSwitchStyle(
                      activeTrackColor: UserService.isDarkMode ? SonrPalette.Red : SonrColor.Blue,
                      inactiveTrackColor: UserService.isDarkMode ? SonrColor.Dark : SonrColor.White,
                    ),
                    value: UserService.isDarkMode,
                    onChanged: (val) => UserService.toggleDarkMode(),
                  )
                ]),
                Padding(padding: EdgeInsetsX.top(16)),

                // @ Dark Mode
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  // Dark Mode Title
                  SonrText.medium("Point To Share"),

                  // Dark Mode Switch
                  NeumorphicSwitch(
                    style: NeumorphicSwitchStyle(
                      activeTrackColor: UserService.isDarkMode ? SonrPalette.Red : SonrColor.Blue,
                      inactiveTrackColor: UserService.isDarkMode ? SonrColor.Dark : SonrColor.White,
                    ),
                    value: UserService.pointShareEnabled,
                    onChanged: (val) async {
                      if (val) {
                        // Overlay Prompt
                        SonrOverlay.question(
                                barrierDismissible: false,
                                title: "Wait!",
                                description: "Point To Share is still experimental, performance may not be stable. \n Do you still want to continue?",
                                acceptTitle: "Continue",
                                declineTitle: "Cancel")
                            .then((value) {
                          // Check Result
                          if (value) {
                            UserService.togglePointToShare();
                          } else {
                            Get.back();
                          }
                        });
                      } else {
                        UserService.togglePointToShare();
                      }
                    },
                  )
                ]),

                Spacer(),
                // @ Version Number
                Align(
                  heightFactor: 0.9,
                  alignment: Alignment.topCenter,
                  child: SonrText.light("Internal Alpha - 0.9.2", size: 16),
                ),
                Padding(padding: EdgeInsetsX.top(16)),
              ]),
            ))
      ]),
    );
  }
}
