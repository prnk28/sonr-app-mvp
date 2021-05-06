import 'package:sonr_app/style/style.dart';
import 'register_controller.dart';

class BoardingLocationView extends GetView<RegisterController> {
  BoardingLocationView({Key? key}) : super(key: key);
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

class BoardingGalleryView extends GetView<RegisterController> {
  BoardingGalleryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      color: Color.fromRGBO(223, 138, 70, 1),
      child: Stack(
        children: [
          SonrAssetIllustration.MediaAccess.widget,
          Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(bottom: 32),
            child: ColorButton.primary(onPressed: controller.requestGallery, text: "Grant Gallery"),
          )
        ],
      ),
    );
  }
}
