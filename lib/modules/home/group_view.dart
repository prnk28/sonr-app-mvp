// ** Dialog Group View ** //
import 'package:sonr_app/theme/theme.dart';

const double K_EXPANDED_HEIGHT = 30;
const double K_EXPANDED_WIDTH = 165;
const double K_DEFAULT_HEIGHT = 5;
const double K_DEFAULT_WIDTH = 5;

class JoinGroupView extends StatelessWidget {
  const JoinGroupView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GlassContainer(
        width: Get.width - 24,
        height: Get.height / 2,
        child: GetX<JoinGroupViewController>(
            init: JoinGroupViewController(),
            builder: (controller) {
              return Container(
                height: Get.height / 2,
                child: Column(children: [
                  SonrHeaderBar.twoButton(
                      title: SonrText.title("Groups"),
                      leading: IconButton(onPressed: () => Get.back(), icon: SonrIcon.close, color: Colors.transparent),
                      action: IconButton(onPressed: () => controller.toggleAddView(), icon: SonrIcon.add)),
                  _GroupCodeEntryView(controller),
                  // ListView.builder(
                  //     itemCount: controller.groups.length,
                  //     itemBuilder: (context, index) {
                  //       var group = controller.groups.values.toList()[index];
                  //       return ListTile(onTap: () {}, title: SonrText.paragraph(group.name), subtitle: SonrText.paragraph(group.size.toString()));
                  //     })
                ]),
              );
            }));
  }
}

class _GroupCodeEntryView extends StatelessWidget {
  final JoinGroupViewController controller;

  const _GroupCodeEntryView(this.controller, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.easeInBack,
      duration: const Duration(milliseconds: 200),
      width: controller.isAdding.value ? K_EXPANDED_WIDTH : K_DEFAULT_WIDTH,
      height: controller.isAdding.value ? K_EXPANDED_HEIGHT : K_DEFAULT_HEIGHT,
      color: controller.isAdding.value ? Colors.red : Colors.transparent,
    );
  }
}

class JoinGroupViewController extends GetxController {
  final groups = RxMap<String, Group>(SonrService.groups);
  final isAdding = false.obs;

  JoinGroupViewController() {
    SonrService.groups.listen((vals) {
      groups(vals);
    });
  }

  toggleAddView() {
    isAdding(!isAdding.value);
  }
}
