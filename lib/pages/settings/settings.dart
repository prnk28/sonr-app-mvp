import 'package:sonr_app/pages/personal/personal.dart';
import 'package:sonr_app/style/style.dart';

import 'settings_controller.dart';

class SettingsPage extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    return SonrScaffold(
      appBar: DetailAppBar(
          onPressed: () {
            Get.back(closeOverlays: true);
          },
          title: "Settings",
          isClose: true),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 24),
              child: "General".subheading(align: TextAlign.start, color: Get.theme.focusColor)),
          Container(
              height: Height.ratio(0.475),
              padding: EdgeInsets.all(8),
              child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: UserOptions.values.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 24,
                  ),
                  itemBuilder: (context, index) {
                    return _SettingsOptionsButton(option: UserOptions.values[index]);
                  })),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 24),
              child: "Preferences".subheading(align: TextAlign.start, color: Get.theme.focusColor)),
          Obx(() => Container(
                height: Height.ratio(0.4),
                margin: EdgeInsets.symmetric(horizontal: 32),
                child: Column(children: [
                  // @ Dark Mode
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    // Dark Mode Title
                    "Dark Mode".light(color: AppTheme.ItemColor),

                    // Dark Mode Switch
                    Switch(
                      activeColor: AppTheme.BackgroundColor,
                      activeTrackColor: AppColor.Blue,
                      inactiveTrackColor: AppTheme.ItemColor,
                      value: controller.isDarkModeEnabled.value,
                      onChanged: (val) => controller.setDarkMode(val),
                    )
                  ]),
                  Padding(padding: EdgeWith.top(8)),

                  // @ Flat Mode
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    // Dark Mode Title
                    "Flat Mode".light(color: AppTheme.ItemColor),

                    // Dark Mode Switch
                    Switch(
                      activeColor: AppTheme.BackgroundColor,
                      activeTrackColor: AppColor.Blue,
                      inactiveTrackColor: AppTheme.ItemColor,
                      value: controller.isFlatModeEnabled.value,
                      onChanged: (val) => controller.setFlatMode(val),
                    )
                  ]),
                  Padding(padding: EdgeWith.top(8)),

                  // @ PointShare Mode
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    // Point Share Title
                    "Point To Share".light(color: AppTheme.ItemColor),

                    // Point Share Mode Switch
                    Switch(
                        activeColor: AppTheme.BackgroundColor,
                        activeTrackColor: AppColor.Blue,
                        inactiveTrackColor: AppTheme.ItemColor,
                        value: controller.isPointToShareEnabled.value,
                        onChanged: (val) async {
                          controller.setPointShare(val);
                        })
                  ]),
                  // @ Version Number
                  Container(
                    padding: EdgeInsets.only(bottom: 4, top: 16),
                    alignment: Alignment.topCenter,
                    child: _buildInfoText(controller.buildTrack.value, controller.buildVersion.value, controller.buildNumber.value),
                  ),
                ]),
              ))
        ]),
      ),
    );
  }

  // Method Builds bottom info text
  Widget _buildInfoText(String track, String version, String build) {
    if (build == "") {
      return "${track} - ${version}".light(color: AppTheme.ItemColor);
    } else {
      return "${track} - ${version}+${build}".light(color: AppTheme.ItemColor);
    }
  }
}

class _SettingsOptionsButton extends GetView<SettingsController> {
  final UserOptions option;

  const _SettingsOptionsButton({Key? key, required this.option}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.shiftScreen(option),
      child: BoxContainer(
        margin: EdgeInsets.all(24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Preferences.isDarkMode ? option.iconData.whiteWith(size: 40) : option.iconData.blackWith(size: 40),
          Padding(padding: EdgeInsets.only(top: 4)),
          Preferences.isDarkMode ? option.name.light(color: AppTheme.ItemColor) : option.name.light(color: AppTheme.ItemColor),
        ]),
      ),
    );
  }
}
