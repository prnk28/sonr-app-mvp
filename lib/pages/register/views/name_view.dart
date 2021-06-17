import 'package:sonr_app/style.dart';
import '../register_controller.dart';

class NamePage extends GetView<RegisterController> {
  NamePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final hint = SonrTextField.hintName();
    return FormPanel.sName(
        titleBar: RegisterTitleBar(
          instruction: "Choose Your",
          title: 'SName',
          isGradient: true,
        ),
        children: [
          Container(
              width: Get.width,
              margin: EdgeInsets.only(left: 24),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  "Sonr Name".toUpperCase().light(
                        color: SonrTheme.greyColor,
                        fontSize: 20,
                      ),
                  Obx(() => Container(
                        child: controller.sName.value.length > 0
                            ? ActionButton(
                                onPressed: () {
                                  controller.sName("");
                                  controller.sName.refresh();
                                },
                                iconData: SonrIcons.Clear)
                            : Container(),
                      ))
                ],
              )),
          Container(
              decoration: BoxDecoration(color: SonrTheme.foregroundColor, borderRadius: BorderRadius.circular(22)),
              margin: EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 6),
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              child: ObxValue<RxDouble>(
                  (leftPadding) => Stack(children: [
                        TextField(
                          style: DisplayTextStyle.Paragraph.style(color: SonrTheme.itemColor, fontSize: 24),
                          autofocus: true,
                          textInputAction: TextInputAction.go,
                          autocorrect: false,
                          showCursor: false,
                          textCapitalization: TextCapitalization.none,
                          onEditingComplete: controller.setName,
                          onChanged: (val) {
                            final length = controller.checkName(val);
                            if (length > 0) {
                              leftPadding(length);
                            } else {
                              leftPadding(hint.item1.size(DisplayTextStyle.Paragraph, fontSize: 24).width + 1);
                            }
                          },
                          decoration: InputDecoration.collapsed(hintText: hint.item1),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: leftPadding.value),
                          child: Text(
                            ".snr/",
                            style: DisplayTextStyle.Subheading.style(color: SonrTheme.itemColor, fontSize: 24),
                          ),
                        ),
                      ]),
                  (hint.item1.length * 12.0).obs)),
          Padding(padding: EdgeInsets.all(8)),
          _NameStatus()
        ]);
  }
}

class _NameStatus extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.nameStatus.value == NewSNameStatus.Default || controller.sName.value.length == 0
        ? Container()
        : Container(
            padding: EdgeInsets.all(12),
            constraints: BoxConstraints(minWidth: 140, maxWidth: 285),
            child: Container(
              child: DashedRect(
                strokeWidth: 1,
                color: SonrTheme.greyColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    controller.nameStatus.value.icon(),
                    Padding(padding: EdgeInsets.only(left: 4)),
                    controller.nameStatus.value.label(),
                  ]),
                ),
              ),
            ),
          ));
  }
}
