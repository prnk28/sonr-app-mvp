import 'package:sonr_app/theme/theme.dart';
import 'register_controller.dart';

class BoardingLocationView extends GetView<RegisterController> {
  BoardingLocationView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      color: SonrPalette.Tertiary,
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          "Getting Started".h3,
          Padding(padding: EdgeInsets.all(8)),
          "Sonr needs your Location in order to find other devices around you".p_Grey,
          LottieContainer(
            type: LottieBoard.Location,
            width: Get.width,
          ),
          Spacer(),
          ColorButton.primary(onPressed: controller.requestLocation, text: "Proceed"),
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
      margin: EdgeInsets.all(8),
      color: SonrPalette.Secondary,
      child: Column(
        children: [
          "Gallery".h3,
          Padding(padding: EdgeInsets.all(8)),
          "Sonr needs access to your Gallery for sharing Files.".p_Grey,
          LottieContainer(
            type: LottieBoard.Gallery,
            width: Get.width,
          ),
          Spacer(),
          ColorButton.primary(onPressed: controller.requestLocation, text: "Proceed"),
        ],
      ),
    );
  }
}

class CompleteView extends GetView<RegisterController> {
  const CompleteView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          "All Set!".hero,
          Spacer(),
          ColorButton.primary(onPressed: controller.setContact, text: "Continue"),
        ],
      ),
    );
  }
}
