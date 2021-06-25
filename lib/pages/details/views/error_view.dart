import 'package:sonr_app/style/style.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ErrorPageArgs args = Get.arguments;
    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: false,
      child: Stack(
        children: [
          Container(
            width: Get.width,
            height: Get.height,
            decoration: BoxDecoration(color: args.backgroundColor),
            foregroundDecoration: BoxDecoration(image: DecorationImage(image: AssetImage(args.imagePath), fit: BoxFit.fitHeight)),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 32),
            alignment: Alignment.bottomCenter,
            child: ColorButton.neutral(
              onPressed: () => args.action(),
              text: args.buttonText,
              textColor: args.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
