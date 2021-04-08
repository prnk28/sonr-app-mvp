import 'package:sonr_app/pages/transfer/compass_view.dart';
import 'package:sonr_app/pages/transfer/transfer_controller.dart';
import 'package:sonr_app/theme/theme.dart';
import 'sheet_view.dart';
import 'stack_view.dart';

// ^ Local Lobby View ^ //
class LocalLobbyView extends StatelessWidget {
  final TransferController controller;

  const LocalLobbyView(this.controller, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SonrScaffold.appBarLeadingAction(
      disableDynamicLobbyTitle: true,
      titleWidget: GestureDetector(child: SonrText.appBar(controller.title.value), onTap: () => Get.bottomSheet(LobbySheet())),
      leading: ShapeButton.circle(icon: SonrIcon.close, onPressed: () => Get.offNamed("/home/transfer"), shape: NeumorphicShape.flat),
      action: Get.find<SonrService>().payload != Payload.CONTACT
          ? ShapeButton.circle(icon: SonrIcon.remote, onPressed: () async => controller.startRemote(), shape: NeumorphicShape.flat)
          : Container(),
      body: GestureDetector(
        onDoubleTap: () => controller.toggleBirdsEye(),
        child: Stack(
          children: <Widget>[
            // @ Range Lines
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Stack(
                  children: [
                    Neumorphic(style: SonrStyle.zonePath(proximity: Position_Proximity.Distant)),
                    Neumorphic(style: SonrStyle.zonePath(proximity: Position_Proximity.Near)),
                  ],
                )),

            // @ Lobby View
            LobbyService.localSize.value > 0 ? LocalLobbyStack(controller) : Container(),

            // @ Compass View
            Padding(
              padding: EdgeInsetsX.bottom(32.0),
              child: GestureDetector(
                onTap: () {
                  controller.toggleShifting();
                },
                child: CompassView(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
