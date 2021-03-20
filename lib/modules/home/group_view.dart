// ** Dialog Group View ** //
import 'package:sonr_app/theme/theme.dart';

class JoinGroupView extends StatelessWidget {
  const JoinGroupView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetX<JoinGroupViewController>(
        init: JoinGroupViewController(),
        builder: (controller) {
          return GlassContainer(
              width: Get.width,
              height: Get.height / 2,
              child: Column(children: [
                SonrHeaderBar.twoButton(
                    title: controller.isAdding.value ? SonrText.title("Join Group") : SonrText.title("Groups"),
                    leading: IconButton(onPressed: () => SonrOverlay.back(), icon: SonrIcon.close, color: Colors.transparent),
                    action: IconButton(onPressed: () => controller.toggleAddView(), icon: SonrIcon.add)),
                controller.isAdding.value
                    ? _GroupCodeEntryView(controller)
                    : Container(
                        width: Get.width,
                        height: Get.height / 2 - 120,
                        child: ListView.builder(
                            itemCount: SonrService.groups.length,
                            itemBuilder: (context, index) {
                              var group = SonrService.groups.values.toList()[index];
                              return ListTile(
                                  onTap: () {}, title: SonrText.paragraph(group.name), subtitle: SonrText.paragraph(group.size.toString()));
                            }),
                      ),
              ]));
        });
  }
}

class _GroupCodeEntryView extends StatelessWidget {
  final JoinGroupViewController controller;

  const _GroupCodeEntryView(this.controller, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Focus Nodes
    final FocusNode first = FocusNode();
    final FocusNode second = FocusNode();
    final FocusNode third = FocusNode();
    final FocusNode fourth = FocusNode();
    return Obx(() => Neumorphic(
          style: SonrStyle.normal,
          child: Container(
              width: Get.width,
              height: 200,
              margin: EdgeInsets.symmetric(horizontal: 12),
              constraints: BoxConstraints.loose(Size(Get.width - 24, 200)),
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  Container(
                      width: 146,
                      child: SonrTextField(
                        focusNode: first,
                        hint: "First",
                        value: '',
                        onChanged: (val) => controller.firstWord(val),
                        textInputAction: TextInputAction.next,
                      )),
                  Container(
                      width: 146,
                      child: SonrTextField(
                        focusNode: second,
                        hint: "Second",
                        value: '',
                        onChanged: (val) => controller.secondWord(val),
                        textInputAction: TextInputAction.next,
                      )),
                ]),
                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  Container(
                      width: 146,
                      child: SonrTextField(
                        focusNode: third,
                        hint: "Third",
                        value: '',
                        textInputAction: TextInputAction.next,
                        onChanged: (val) => controller.thirdWord(val),
                      )),
                  Container(
                      width: 146,
                      child: SonrTextField(
                        textInputAction: TextInputAction.done,
                        focusNode: fourth,
                        hint: "Fourth",
                        value: '',
                        onChanged: (val) => controller.fourthWord(val),
                        onEditingComplete: () => controller.joinGroup(),
                      )),
                ]),
              ])),
        ));
  }
}

class JoinGroupViewController extends GetxController {

  // View State
  final isAdding = false.obs;

  // Words
  final firstWord = "".obs;
  final secondWord = "".obs;
  final thirdWord = "".obs;
  final fourthWord = "".obs;

  toggleAddView() {
    isAdding(!isAdding.value);
  }

  joinGroup() {
    // Clean words into new string
    var group = "${firstWord.value}-${secondWord.value}-${thirdWord.value}-${fourthWord.value}";
    SonrService.joinGroup(group);
    isAdding(false);
  }
}
