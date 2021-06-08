import 'package:sonr_app/style.dart';
import '../register_controller.dart';

class BoardingLocationView extends GetView<RegisterController> {
  BoardingLocationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      right: false,
      left: false,
      child: Stack(
        children: [
          Container(
            width: Get.width,
            height: Get.height,
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/illustrations/LocationPerm.png"), fit: BoxFit.fitHeight)),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 32),
            alignment: Alignment.bottomCenter,
            child: ColorButton.neutral(
              onPressed: controller.requestLocation,
              text: "Grant Location",
            ),
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
    return SafeArea(
      top: false,
      bottom: false,
      right: false,
      left: false,
      child: Stack(
        children: [
          Container(
            width: Get.width,
            height: Get.height,
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/illustrations/MediaPerm.png"), fit: BoxFit.fitHeight)),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 32),
            alignment: Alignment.bottomCenter,
            child: ColorButton.neutral(
              onPressed: controller.requestLocation,
              text: "Grant Gallery",
            ),
          )
        ],
      ),
    );
  }
}
