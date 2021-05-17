import 'package:sonr_app/style/style.dart';
import 'register_controller.dart';

class BackupCodeView extends GetView<RegisterController> {
  BackupCodeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      color: Color.fromRGBO(255, 255, 255, 1),
      child: Stack(
        children: [
          SonrAssetIllustration.LocationAccess.widget,
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: 32),
            child: ColorButton.primary(onPressed: controller.requestLocation, text: "Grant Location"),
          )
        ],
      ),
    );
  }
}
