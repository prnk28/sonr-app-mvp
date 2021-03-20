// ** Dialog Group View ** //
import 'package:sonr_app/theme/theme.dart';

class GroupView extends StatelessWidget {
  final String name;

  const GroupView(this.name, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetX<GroupViewController>(
        init: GroupViewController(name),
        builder: (controller) {
          return Container(
              width: Get.width - 24,
              height: Get.height - 64,
              child: Column(children: [
                SonrText.title(name),
                ListView.builder(
                    itemCount: controller.members.length,
                    itemBuilder: (context, index) {
                      var peer = controller.members.values.toList()[index];
                      return ListTile(onTap: () {}, title: peer.fullName, subtitle: Text(peer.platform.toString()));
                    })
              ]));
        });
  }
}

class GroupViewController extends GetxController {
  final String _groupName;
  final members = RxMap<String, Peer>();

  GroupViewController(this._groupName) {
    SonrService.groups.listen((vals) {
      if (vals.containsKey(_groupName)) {
        var group = vals[_groupName];
        print(group.toString());
        members(group.members);
        members.refresh();
      }
    });
  }
}
