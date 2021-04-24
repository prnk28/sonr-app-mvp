import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';
import 'dart:math';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'share_controller.dart';

class ShareView extends GetView<ShareController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: RadialAnimation(
        animator: controller.animationController,
        cameraButton: RadialButton(color: Colors.red, icon: SonrIcons.Camera, onPressed: controller.openCamera),
        contactButton: RadialButton(color: Colors.blue, icon: SonrIcons.User, onPressed: controller.selectContact),
        filesButton: RadialButton(color: Colors.orange, icon: SonrIcons.Folder, onPressed: controller.selectFile),
        galleryButton: RadialButton(color: Colors.green, icon: SonrIcons.Photos, onPressed: controller.selectMedia),
      ),
    );
  }
}

class RadialAnimation extends StatelessWidget {
  final RadialButton cameraButton;
  final RadialButton galleryButton;
  final RadialButton filesButton;
  final RadialButton contactButton;

  final AnimationController animator;
  final Animation<double> rotation;
  final Animation<double> translation;
  final Animation<double> scale;

  RadialAnimation({
    this.animator,
    Key key,
    @required this.cameraButton,
    @required this.galleryButton,
    @required this.filesButton,
    @required this.contactButton,
  })  : translation = Tween<double>(
          begin: 0.0,
          end: 100.0,
        ).animate(
          CurvedAnimation(parent: animator, curve: Curves.elasticInOut),
        ),
        scale = Tween<double>(
          begin: 1.1,
          end: 0.0,
        ).animate(
          CurvedAnimation(parent: animator, curve: Curves.fastOutSlowIn),
        ),
        rotation = Tween<double>(
          begin: 0.0,
          end: 360.0,
        ).animate(
          CurvedAnimation(
            parent: animator,
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
    return AnimatedBuilder(
        animation: controller,
        builder: (context, widget) {
          return Transform.rotate(
              angle: vector.radians(rotation.value),
              child: Stack(alignment: Alignment.center, children: <Widget>[
                _buildButton(210, cameraButton),
                _buildButton(250, galleryButton),
                _buildButton(290, filesButton),
                _buildButton(330, contactButton),
                Transform.scale(
                  scale: scale.value - 1,
                  child: FloatingActionButton(child: Icon(SonrIcons.Close), onPressed: _open, backgroundColor: SonrColor.Critical),
                ),
                Transform.scale(
                  scale: scale.value,
                  child: FloatingActionButton(child: Icon(SonrIcons.Share), onPressed: _close, backgroundColor: SonrColor.Black),
                )
              ]));
        });
  }

  _open() {
    animator.forward();
  }

  _close() {
    animator.reverse();
  }

  _buildButton(double angle, RadialButton child) {
    final double rad = vector.radians(angle);
    return Transform(transform: Matrix4.identity()..translate((translation.value) * cos(rad), (translation.value) * sin(rad)), child: child);
  }
}

class RadialButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final Function onPressed;

  const RadialButton({Key key, this.color, this.icon, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: Neumorph.compact(shape: BoxShape.circle, color: color),
      child: GestureDetector(onTap: () => onPressed(), child: Center(child: icon.white)),
    );
  }
}
