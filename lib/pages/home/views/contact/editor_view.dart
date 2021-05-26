import 'package:sonr_app/pages/home/views/contact/profile_controller.dart';
import 'package:sonr_app/style/style.dart';

class EditOptionsView extends GetView<ProfileController> {
  EditOptionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Build GridView
    return Container(
      height: Height.ratio(0.7),
      padding: EdgeInsets.all(8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          PlainIconButton(icon: SonrIcons.Backward.whiteWith(size: 32), onPressed: () => controller.exitToViewing()),
          "Edit Contact".headFour(align: TextAlign.center, color: Get.theme.focusColor),
          Spacer()
        ]),
        Padding(padding: EdgeInsets.only(top: 4)),
        Container(
          height: Height.ratio(0.45),
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
              }),
        ),
      ]),
    );
  }
}

class _EditOptionsButton extends GetView<ProfileController> {
  final ContactOptions option;

  const _EditOptionsButton({Key? key, required this.option}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.shiftScreen(option),
      child: Container(
        margin: EdgeInsets.all(12),
        decoration: Neumorphic.floating(theme: Get.theme, radius: 24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          option.iconData.whiteWith(size: 40),
          Padding(padding: EdgeInsets.only(top: 4)),
          option.name.h6_White,
        ]),
      ),
    );
  }
}
