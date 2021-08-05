import 'package:card_settings/card_settings.dart';
import 'package:sonr_app/pages/personal/personal.dart';
import 'package:sonr_app/style/style.dart';

import 'settings_controller.dart';

class SettingsPage extends StatelessWidget {
  final bool alternate;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SettingsPage({Key? key, this.alternate = true}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (alternate) {
      return _SettingsAlternateView();
    }
    String title = "Spheria";
    String author = "Cody Leet";
    String url = "http://www.codyleet.com/spheria";
    return SonrScaffold(
      appBar: DetailAppBar(
        onPressed: () {
          Get.back();
        },
        title: "Settings",
        isClose: true,
      ),
      body: Form(
        key: _formKey,
        child: _SettingsCardTheme(
          child: CardSettings(
              divider: Divider(
                color: AppTheme.DividerColor,
              ),
              //cardless: true,
              showMaterialonIOS: true,
              children: <CardSettingsSection>[
                CardSettingsSection(
                  header: CardSettingsHeader(
                    label: 'Favorite Book',
                  ),
                  children: <CardSettingsWidget>[
                    CardSettingsText(
                      label: 'Title',
                      labelAlign: TextAlign.left,
                      contentAlign: TextAlign.right,
                      initialValue: title,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Title is required.';
                      },
                      onSaved: (value) => title = value ?? "",
                    ),
                    CardSettingsText(
                      label: 'Author',
                      labelAlign: TextAlign.left,
                      contentAlign: TextAlign.right,
                      initialValue: author,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Author is required.';
                      },
                      onSaved: (value) => author = value ?? "",
                    ),
                    CardSettingsText(
                      label: 'URL',
                      initialValue: url,
                      labelAlign: TextAlign.left,
                      contentAlign: TextAlign.right,
                      validator: (value) {
                        if (!value!.contains('http:')) return 'Must be a valid website.';
                      },
                      onSaved: (value) => url = value ?? "",
                    ),
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}

class _SettingsCardTheme extends StatelessWidget {
  final Widget child;

  const _SettingsCardTheme({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
          cardTheme: CardTheme(
            elevation: 10,
            shadowColor: Get.isDarkMode ? Colors.black.withOpacity(0.4) : Color(0xffD4D7E0).withOpacity(0.75),
            shape: Get.isDarkMode
                ? null
                : RoundedRectangleBorder(
                    side: BorderSide(color: AppTheme.BackgroundColor, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
          ),
          secondaryHeaderColor: Colors.transparent, // card header background
          cardColor: AppTheme.ForegroundColor, // card field background
          textTheme: TextTheme(
            button: TextStyle(color: Colors.deepPurple[900]), // button text
            subtitle1: DisplayTextStyle.Light.style(color: AppTheme.GreyColor), // input text
            headline6: DisplayTextStyle.Section.style(color: AppTheme.ItemColor), // card header text
          ),
          primaryTextTheme: TextTheme(
            headline6: TextStyle(color: Colors.lightBlue[50]), // app header text
          ),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: DisplayTextStyle.Subheading.style(color: AppTheme.ItemColor, fontSize: 20), // style for labels
          ),
        ),
        child: child);
  }
}

class _SettingsAlternateView extends GetView<SettingsController> {
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
                  Spacer(),
                  // @ Version Number
                  Container(
                    padding: EdgeInsets.only(bottom: 8),
                    alignment: Alignment.topCenter,
                    child: "Alpha - 0.9.3".light(color: AppTheme.ItemColor),
                  ),
                ]),
              ))
        ]),
      ),
    );
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
