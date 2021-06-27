import 'package:sonr_app/style/style.dart';
import '../camera_controller.dart';

class PreviewView extends StatelessWidget {
  final CameraController controller;
  const PreviewView({Key? key, required this.controller}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return controller.result.value.single.mime.isVideo
        // Video Player View
        ? Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: AspectRatio(
                aspectRatio: 9 / 16,
                child: FileItemVideoBox(
                  fileItem: controller.result.value.single,
                )))

        // Photo View
        : Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              image: DecorationImage(image: FileImage(controller.result.value.single.file), fit: BoxFit.fill),
              borderRadius: BorderRadius.circular(30),
            ),
          );
  }
}
