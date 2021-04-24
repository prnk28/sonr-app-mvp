import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';
import 'dart:math';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'share_controller.dart';

class ShareView extends GetView<ShareController> {
  final Animation<double> rotation;
  final Animation<double> translation;
  final Animation<double> scale;

  ShareView({
    Key key,
  })  : translation = Tween<double>(
          begin: 0.0,
          end: 120.0,
        ).animate(
          CurvedAnimation(parent: Get.find<ShareController>().animator, curve: Curves.elasticInOut),
        ),
        scale = Tween<double>(
          begin: 1.1,
          end: 0.0,
        ).animate(
          CurvedAnimation(parent: Get.find<ShareController>().animator, curve: Curves.fastOutSlowIn),
        ),
        rotation = Tween<double>(
          begin: 0.0,
          end: 360.0,
        ).animate(
          CurvedAnimation(
            parent: Get.find<ShareController>().animator,
            curve: Interval(
              0.0,
              0.9,
              curve: Curves.decelerate,
            ),
          ),
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 36),
      child: AnimatedBuilder(
          animation: Get.find<ShareController>().animator,
          builder: (context, widget) {
            return Transform.rotate(
                angle: vector.radians(rotation.value),
                child: Stack(alignment: Alignment.center, children: <Widget>[
                  _buildButton(210, color: Colors.red, icon: SonrIcons.Camera, onPressed: controller.openCamera),
                  _buildButton(250, color: Colors.green, icon: SonrIcons.Photos, onPressed: controller.selectMedia),
                  _buildButton(290, color: Colors.orange, icon: SonrIcons.Folder, onPressed: controller.selectFile),
                  _buildButton(330, color: Colors.blue, icon: SonrIcons.User, onPressed: controller.selectContact),
                  Transform.scale(
                    scale: scale.value - 1,
                    child: FloatingActionButton(child: Icon(SonrIcons.Close), onPressed: controller.toggle, backgroundColor: SonrColor.Critical),
                  ),
                  Transform.scale(
                    scale: scale.value,
                    child: FloatingActionButton(child: Icon(SonrIcons.Share), onPressed: controller.toggle, backgroundColor: SonrColor.Black),
                  )
                ]));
          }),
    );
  }

  _buildButton(double angle, {Color color, IconData icon, Function onPressed}) {
    return Transform(
        transform: Matrix4.identity()..translate((translation.value) * cos(vector.radians(angle)), (translation.value) * sin(vector.radians(angle))),
        child: FloatingActionButton(
          backgroundColor: color,
          child: icon.white,
          elevation: 0,
          isExtended: true,
          onPressed: () {
            onPressed();
            print("Tapped");
          },
        ));
  }
}
