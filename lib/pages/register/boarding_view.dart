import 'package:sonr_app/theme/theme.dart';
import 'register_controller.dart';

class BoardingLocationView extends GetView<RegisterController> {
  BoardingLocationView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: SonrPalette.Tertiary,
      child: Column(
        children: [
          LottieContainer(
            type: LottieBoard.Location,
            width: Get.width,
          ),
          "Getting Started".h3,
          Padding(padding: EdgeInsets.all(8)),
          "Sonr needs your Location in order to find other devices around you".h6_Grey,
          Spacer(),
          ColorButton.primary(onPressed: controller.requestLocation, text: "Proceed"),
          Padding(padding: EdgeInsets.all(8)),
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
      color: SonrPalette.Secondary,
      child: Column(
        children: [
          LottieContainer(
            type: LottieBoard.Gallery,
            width: Get.width,
          ),
          "Gallery".h3,
          Padding(padding: EdgeInsets.all(8)),
          "Sonr needs access to your Gallery for sharing Files.".h6_Grey,
          Spacer(),
          ColorButton.primary(onPressed: controller.requestLocation, text: "Proceed"),
          Padding(padding: EdgeInsets.all(8)),
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
      color: SonrPalette.Secondary,
      child: Column(
        children: [
          "All Set!".hero,
          Padding(padding: EdgeInsets.all(8)),
          Spacer(),
          ColorButton.primary(onPressed: controller.completeForm, text: "Continue"),
          Padding(padding: EdgeInsets.all(8)),
        ],
      ),
    );
  }
}
