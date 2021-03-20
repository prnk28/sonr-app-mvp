// ** Dialog Group View ** //
import 'package:sonr_app/theme/theme.dart';

class JoinGroupView extends StatelessWidget {
  const JoinGroupView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GlassContainer(
        width: Get.width - 24,
        height: Get.height / 2,
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          SonrHeaderBar.twoButton(
              title: SonrText.title("Groups"),
              leading: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: SonrIcon.close,
                  color: Colors.transparent),
              action: IconButton(
                  onPressed: () {
                    print("New Group");
                  },
                  icon: SonrIcon.add)),
          // ListView.builder(
          //     itemCount: controller.groups.length,
          //     itemBuilder: (context, index) {
          //       var group = controller.groups.values.toList()[index];
          //       return ListTile(onTap: () {}, title: SonrText.paragraph(group.name), subtitle: SonrText.paragraph(group.size.toString()));
          //     })
        ]));
  }
}

class JoinGroupViewController extends GetxController {
  final groups = RxMap<String, Group>(SonrService.groups);

  JoinGroupViewController() {
    SonrService.groups.listen((vals) {
      groups(vals);
    });
  }
}
