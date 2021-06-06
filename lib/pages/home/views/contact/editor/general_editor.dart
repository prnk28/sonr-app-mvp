import 'package:sonr_app/style.dart';
import 'editor_controller.dart';

class GeneralEditorView extends GetView<EditorController> {
  GeneralEditorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 24),
            child: "General".subheading(align: TextAlign.start, color: Get.theme.focusColor)),
        Container(
            height: Height.ratio(0.5),
            padding: EdgeInsets.all(8),
            child: GridView.builder(
                itemCount: ContactOptions.values.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 24,
                ),
                itemBuilder: (context, index) {
                  return _EditOptionsButton(option: ContactOptions.values[index]);
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
                  "Dark Mode".paragraph(),

                  // Dark Mode Switch
                  Switch(
                    activeColor: SonrTheme.textColor,
                    activeTrackColor: SonrColor.Primary,
                    inactiveTrackColor: SonrTheme.textColor,
                    value: controller.isDarkModeEnabled.value,
                    onChanged: (val) => controller.setDarkMode(val),
                  )
                ]),
                Padding(padding: EdgeWith.top(8)),

                // @ Flat Mode
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  // Dark Mode Title
                  "Flat Mode".paragraph(),

                  // Dark Mode Switch
                  Switch(
                    activeColor: SonrTheme.textColor,
                    activeTrackColor: SonrColor.Primary,
                    inactiveTrackColor: SonrTheme.textColor,
                    value: controller.isFlatModeEnabled.value,
                    onChanged: (val) => controller.setFlatMode(val),
                  )
                ]),
                Padding(padding: EdgeWith.top(8)),

                // @ PointShare Mode
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  // Point Share Title
                  "Point To Share".paragraph(),

                  // Point Share Mode Switch
                  Switch(
                      activeColor: SonrTheme.textColor,
                      activeTrackColor: SonrColor.Primary,
                      inactiveTrackColor: SonrTheme.textColor,
                      value: controller.isPointToShareEnabled.value,
                      onChanged: (val) async {
                        controller.setPointShare(val);
                      })
                ]),
                Padding(padding: EdgeWith.top(8)),
                // @ Version Number
                Align(
                  heightFactor: 0.9,
                  alignment: Alignment.topCenter,
                  child: "Alpha - 0.9.2".light(),
                ),
              ]),
            ))
      ]),
    );
  }
}

class _EditOptionsButton extends GetView<EditorController> {
  final ContactOptions option;

  const _EditOptionsButton({Key? key, required this.option}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.shiftScreen(option),
      child: Container(
        margin: EdgeInsets.all(24),
        decoration: SonrTheme.cardDecoration,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          UserService.isDarkMode ? option.iconData.whiteWith(size: 40) : option.iconData.blackWith(size: 40),
          Padding(padding: EdgeInsets.only(top: 4)),
          UserService.isDarkMode ? option.name.paragraph(color: SonrColor.White) : option.name.paragraph(),
        ]),
      ),
    );
  }
}
