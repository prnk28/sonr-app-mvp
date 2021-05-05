import 'package:sonr_app/theme/theme.dart';
import 'settings_controller.dart';
class SettingsSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetX<SettingsController>(
      init: SettingsController(),
      builder: (controller) {
        return Container(
          decoration: Neumorphic.floating(),
          height: Get.height / 2,
          child: Stack(children: [
            Container(
                width: Get.width,
                child: Container(
                  child: Column(children: [
                    // @ Title of Pane
                    Align(
                      heightFactor: 0.9,
                      alignment: Alignment.topCenter,
                      child: "Settings".h2,
                    ),
                    Padding(padding: EdgeWith.top(24)),

                    // @ Dark Mode
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      // Dark Mode Title
                      "Dark Mode".h6,

                      // Dark Mode Switch
                      // NeumorphicSwitch(
                      //   style: NeumorphicSwitchStyle(
                      //     activeTrackColor: UserService.isDarkMode ? SonrColor.Critical : SonrColor.Primary,
                      //     inactiveTrackColor: UserService.isDarkMode ? SonrColor.Black : SonrColor.White,
                      //   ),
                      //   value: controller.isDarkModeEnabled.value,
                      //   onChanged: (val) => controller.setDarkMode(val),
                      // )
                    ]),
                    Padding(padding: EdgeWith.top(16)),

                    // @ Flat Mode
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      // Dark Mode Title
                      "Flat Mode".h6,

                      // Dark Mode Switch
                      // NeumorphicSwitch(
                      //   style: NeumorphicSwitchStyle(
                      //     activeTrackColor: UserService.isDarkMode ? SonrColor.Critical : SonrColor.Primary,
                      //     inactiveTrackColor: UserService.isDarkMode ? SonrColor.Black : SonrColor.White,
                      //   ),
                      //   value: controller.isFlatModeEnabled.value,
                      //   onChanged: (val) => controller.setFlatMode(val),
                      // )
                    ]),
                    Padding(padding: EdgeWith.top(16)),

                    // @ PointShare Mode
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      // Point Share Title
                      "Point To Share".h6,

                      // Point Share Mode Switch
                      // NeumorphicSwitch(
                      //     style: NeumorphicSwitchStyle(
                      //       activeTrackColor: UserService.isDarkMode ? SonrColor.Critical : SonrColor.Primary,
                      //       inactiveTrackColor: UserService.isDarkMode ? SonrColor.Black : SonrColor.White,
                      //     ),
                      //     value: controller.isDarkModeEnabled.value,
                      //     onChanged: (val) async {
                      //       controller.setPointShare(val);
                      //     })
                    ]),

                    Spacer(),
                    // @ Version Number
                    Align(
                      heightFactor: 0.9,
                      alignment: Alignment.topCenter,
                      child: "Alpha - 0.9.2".l,
                    ),
                    Padding(padding: EdgeWith.top(16)),
                  ]),
                ))
          ]),
        );
      },
    );
  }
}
