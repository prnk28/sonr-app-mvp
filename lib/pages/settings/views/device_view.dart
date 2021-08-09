import 'package:get/get.dart';
import 'package:sonr_app/modules/peer/peer.dart';
import 'package:sonr_app/pages/settings/settings_controller.dart';
import 'package:sonr_app/style/buttons/utility.dart';
import 'package:sonr_app/style/style.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class DevicesView extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => SonrScaffold(
        appBar: DetailAppBar(
          onPressed: controller.handleLeading,
          title: "Nearby Linkers",
          isClose: true,
        ),
        body: ListView.builder(
          itemBuilder: (context, i) => PeerItem.linker(
            LobbyService.linkers[i],
            onPressed: () => AppRoute.popup(
              _DeviceLinkCodePopup(
                peer: LobbyService.linkers[i],
              ),
            ),
          ),
          itemCount: LobbyService.linkers.length,
        )));
  }
}

class _DeviceLinkCodePopup extends GetView<SettingsController> {
  final Peer peer;
  const _DeviceLinkCodePopup({Key? key, required this.peer}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    return Obx(() => SonrScaffold(
          appBar: DetailAppBar(
            onPressed: () => Get.back(),
            action: ActionButton(
              iconData: SimpleIcons.Clear,
              onPressed: () => textEditingController.clear(),
            ),
            title: "Link",
            isClose: true,
          ),
          body: Container(
            height: Height.full,
            width: Width.full,
            child: ListView(
              children: <Widget>[
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: 'Device Verification'.subheading(
                    align: TextAlign.center,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30.0,
                      vertical: 8,
                    ),
                    child: [
                      "Enter the code visible on ".paragraphSpan(),
                      "${peer.hostName}".paragraphSpan(
                        color: AppTheme.GreyColor,
                      )
                    ].rich()),
                SizedBox(
                  height: 20,
                ),
                Form(
                  key: controller.formKey,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                      child: PinCodeTextField(
                        appContext: context,
                        length: 6,
                        obscuringCharacter: '*',
                        blinkWhenObscuring: true,
                        animationType: AnimationType.fade,
                        pinTheme: PinTheme(
                          activeColor: AppColor.Blue,
                          inactiveColor: AppTheme.ForegroundColor,
                          inactiveFillColor: AppTheme.ForegroundColor,
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(12),
                          fieldHeight: 50,
                          fieldWidth: 40,
                          activeFillColor: AppTheme.ForegroundColor,
                        ),
                        cursorColor: AppTheme.DividerColor,
                        animationDuration: Duration(milliseconds: 300),
                        enableActiveFill: true,
                        errorAnimationController: controller.errorController,
                        controller: textEditingController,
                        autoFocus: true,
                        keyboardType: TextInputType.number,
                        boxShadows: [
                          BoxShadow(
                            offset: Offset(0, 1),
                            color: Colors.black12,
                            blurRadius: 10,
                          )
                        ],
                        onCompleted: (String s) => controller.onLinkInputCompleted(s, this.peer),
                        onChanged: controller.onLinkInputChanged,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    controller.hasError.value ? "*Please fill up the code properly" : "",
                    style: TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  constraints: BoxConstraints(maxWidth: 140, maxHeight: 60),
                  margin: EdgeInsets.symmetric(horizontal: 120),
                  child: ColorButton.primary(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                      onPressed: () => controller.onVerifyPressed(peer),
                      child: Container(
                          padding: EdgeInsets.all(8),
                          child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                            ButtonUtility.buildUiIcon(UIIcons.CheckCrFr),
                            Padding(padding: EdgeInsets.all(2)),
                            ButtonUtility.buildPrimaryText("Verify"),
                          ]))),
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ));
  }
}
