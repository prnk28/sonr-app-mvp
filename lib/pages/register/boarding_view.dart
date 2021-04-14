import 'package:sonr_app/theme/theme.dart';
import 'register_controller.dart';

class BoardingLocationView extends GetView<RegisterController> {
  BoardingLocationView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/illustrations/location_access.png"), fit: BoxFit.fill)),
      padding: EdgeInsets.symmetric(vertical: 64, horizontal: 24),
      child: Column(
        children: [
          "Location".h2,
          Spacer(),
          ColorButton.primary(onPressed: controller.requestLocation, text: "Grant Location"),
        ],
      ),
    );
  }
}

class BoardingGalleryView extends GetView<RegisterController> {
  BoardingGalleryView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      padding: EdgeInsets.only(top: 64, left: 48, right: 86, bottom: 48),
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/media.png"), fit: BoxFit.fill)),
      child: Column(
        children: [
          "Sonr needs access to your Gallery for sharing Files.".h4,
          Spacer(),
          ColorButton.primary(onPressed: controller.requestGallery, text: "Grant Gallery"),
        ],
      ),
    );
  }
}
