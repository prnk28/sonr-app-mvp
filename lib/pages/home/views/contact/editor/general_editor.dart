import 'package:sonr_app/style/style.dart';

import 'editor_controller.dart';

class GeneralEditorView extends GetView<EditorController> {
  GeneralEditorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      child: Column(children: [
        Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 24),
            child: "General".headFour(align: TextAlign.start, color: Get.theme.focusColor)),
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

class _EditOptionsButton extends GetView<EditorController> {
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
