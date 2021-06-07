import 'package:sonr_app/pages/detail/detail.dart';
import 'package:sonr_app/style.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({Key? key, required this.type}) : super(key: key);
  final DetailPageType type;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: Get.width,
          height: Get.height,
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage(type.errorImageAsset))),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 32),
          alignment: Alignment.bottomCenter,
          child: ColorButton.neutral(onPressed: () => Get.back(closeOverlays: true), text: "Return Home"),
        ),
      ],
    );
  }
}
