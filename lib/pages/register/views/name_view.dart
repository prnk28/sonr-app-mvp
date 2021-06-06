import 'package:sonr_app/style/style.dart';
import '../register_controller.dart';

class NamePage extends GetView<RegisterController> {
  NamePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final hint = SonrTextField.hintName();
    return SonrScaffold(
        gradient: SonrGradients.SeaShore,
        body: Container(
          width: Get.width,
          height: Get.height,
          margin: EdgeInsets.only(bottom: 8, top: 72),
          child: Column(children: <Widget>[
            Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _NameStatus(),
                  Padding(padding: EdgeInsets.all(8)),
                  Container(
                      decoration: Neumorphic.floating(theme: Get.theme),
                      margin: EdgeInsets.only(left: 16, right: 16, top: 6, bottom: 6),
                      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                      child: Stack(children: [
                        TextField(
                          style: TextStyle(
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w400,
                              color: UserService.isDarkMode ? Colors.white : SonrColor.Black,
                              fontSize: 24),
                          autofocus: true,
                          textInputAction: TextInputAction.done,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          onEditingComplete: controller.setName,
                          onChanged: controller.checkName,
                          decoration: InputDecoration.collapsed(
                              hintText: hint.item1,
                              hintStyle: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontWeight: FontWeight.w400,
                                  color: UserService.isDarkMode ? Colors.white38 : Colors.black38)),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(right: 36),
                          child: Text(
                            ".snr/",
                            style: TextStyle(
                                fontFamily: 'Manrope',
                                fontWeight: FontWeight.w400,
                                color: UserService.isDarkMode ? Colors.white : SonrColor.Black,
                                fontSize: 24),
                          ),
                        ),
                      ])),
                ],
              ),
            )
          ]),
        ));
  }
}

class _NameStatus extends GetView<RegisterController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.nameStatus.value == RegisterNameStatus.Default
        ? Container()
        : Container(
            width: 200,
            child: Container(
                padding: EdgeInsets.all(12),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  Stack(
                    children: <Widget>[
                      Positioned(
                        top: 2.0,
                        child: Icon(_buildIconData(controller.nameStatus.value), color: SonrColor.Black.withOpacity(0.5), size: 20),
                      ),
                      Icon(_buildIconData(controller.nameStatus.value), color: Colors.white, size: 20),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  _buildLabel(controller.nameStatus.value).paragraph(color: SonrColor.White)
                ])),
            decoration: BoxDecoration(gradient: _buildGradient(controller.nameStatus.value), borderRadius: BorderRadius.circular(8), boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
                color: SonrColor.Primary.withOpacity(0.4),
                blurRadius: Get.theme.blurRadius,
                spreadRadius: Get.theme.spreadRadius,
              )
            ]),
          ));
  }

  String _buildLabel(RegisterNameStatus status) {
    switch (status) {
      case RegisterNameStatus.Default:
        return "Pick Name";
      case RegisterNameStatus.Available:
        return "Available!";
      case RegisterNameStatus.TooShort:
        return "Too Short";
      case RegisterNameStatus.Unavailable:
        return "Unavailable";
      case RegisterNameStatus.Blocked:
        return "Blocked";
      case RegisterNameStatus.Restricted:
        return "Restricted";
      case RegisterNameStatus.DeviceRegistered:
        return "Invalid";
      case RegisterNameStatus.Returning:
        return "Welcome Back!";
    }
  }

  Gradient _buildGradient(RegisterNameStatus status) {
    switch (status) {
      case RegisterNameStatus.Default:
        return SonrGradient.Primary;
      case RegisterNameStatus.Available:
        return SonrGradient.Tertiary;
      case RegisterNameStatus.Returning:
        return SonrGradient.Secondary;
      default:
        return SonrGradient.Critical;
    }
  }

  IconData _buildIconData(RegisterNameStatus status) {
    switch (status) {
      case RegisterNameStatus.Default:
        return SonrIcons.ATSign;
      case RegisterNameStatus.Available:
        return SonrIcons.Check;
      case RegisterNameStatus.Returning:
        return SonrIcons.Zap;
      default:
        return SonrIcons.Warning;
    }
  }
}
