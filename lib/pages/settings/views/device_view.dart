import 'package:get/get.dart';
import 'package:sonr_app/pages/settings/settings_controller.dart';
import 'package:sonr_app/style/style.dart';
import 'package:code_input/code_input.dart';

class DevicesView extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => SonrScaffold(
          appBar: DetailAppBar(
            onPressed: controller.handleLeading,
            title: controller.title.value,
            action: ActionButton(iconData: SimpleIcons.Add, onPressed: () => AppRoute.popup(_DeviceLinkCodePopup(peer: Peer()))),
            isClose: true,
          ),
          body: ListView.builder(
            itemBuilder: (context, i) => _DeviceLinkerItem(peer: controller.linkers.value.list[i]),
            itemCount: controller.linkers.value.list.length,
          ),
        ));
  }
}

class _DeviceLinkerItem extends StatelessWidget {
  final Peer peer;
  const _DeviceLinkerItem({Key? key, required this.peer}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: peer.hostName.subheading(),
      leading: peer.platform.icon(),
      onTap: () => AppRoute.popup(_DeviceLinkCodePopup(peer: peer)),
    );
  }
}

class _DeviceLinkCodePopup extends StatelessWidget {
  final Peer peer;
  const _DeviceLinkCodePopup({Key? key, required this.peer}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        peer.hostName.subheading(),
        Padding(padding: EdgeInsets.only(top: 8)),
        CodeInput(
          length: 6,
          keyboardType: TextInputType.number,
          builder: CodeInputBuilders.darkCircle(),
          onFilled: (value) => print('Your input is $value.'),
        )
      ]),
    );
  }
}
