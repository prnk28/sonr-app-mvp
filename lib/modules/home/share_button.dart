import 'package:get/get.dart';
import 'package:sonar_app/modules/home/home_controller.dart';
import 'package:sonar_app/theme/theme.dart';

import 'media_picker.dart';

class ShareButton extends GetView<HomeController> {
  final expandedView = _ExpandedView();
  final defaultView = _DefaultView();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Align(
        alignment: Alignment.bottomCenter,
        child: AnimatedContainer(
            padding: EdgeInsetsDirectional.only(start: 30),
            width: controller.isExpanded.value
                ? Get.width / 2 + 165
                : Get.width / 2 + 30,
            height: controller.isExpanded.value ? 130 : 70,
            duration: 200.milliseconds,
            child: Center(
              child: NeumorphicButton(
                  child:
                      controller.isExpanded.value ? expandedView : defaultView,
                  onPressed: controller.toggleShareExpand,
                  style: NeumorphicStyle(
                    color: Colors.black87,
                    surfaceIntensity: 0.6,
                    intensity: 0.75,
                    depth: 8,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(40)),
                  )),
            )),
      );
    });
  }
}

class _DefaultView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SonrIcon.send,
          SonrText.header(
            "Share",
            size: 32,
            gradient: FlutterGradientNames.glassWater,
          )
        ]);
  }
}

class _ExpandedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double spacing = 12;
    return PlayAnimation<double>(
        tween: (0.0).tweenTo(1.0),
        duration: 100.milliseconds,
        delay: 100.milliseconds,
        builder: (context, child, value) {
          final controller = Get.find<HomeController>();
          return Container(
            width: Get.width / 2 + 165,
            height: 130,
            child: AnimatedOpacity(
                opacity: value,
                duration: 150.milliseconds,
                child: NeumorphicTheme(
                  theme: NeumorphicThemeData(
                    baseColor: Color.fromRGBO(239, 238, 238, 1.0),
                    lightSource: LightSource.top,
                    depth: 8,
                    intensity: 0.4,
                  ),
                  child: Row(
                      mainAxisSize: MainAxisSize.max,
                      verticalDirection: VerticalDirection.up,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Container(
                            height: Get.height,
                            child: _AnimatedButtonOption(
                              onPressed: () {
                                controller.openCamera();
                              },
                              type: ArtboardType.Camera,
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(spacing)),
                        Expanded(
                          child: Container(
                            height: Get.height,
                            child: _AnimatedButtonOption(
                              onPressed: () {
                                controller.openMediaPicker();
                              },
                              type: ArtboardType.Gallery,
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(spacing)),
                        Expanded(
                          child: Container(
                            height: Get.height,
                            child: _AnimatedButtonOption(
                              onPressed: () {
                                controller.queueContact();
                              },
                              type: ArtboardType.Contact,
                            ),
                          ),
                        )
                      ]),
                )),
          );
        });
  }
}

class _AnimatedButtonOption extends StatelessWidget {
  // Properties
  final ArtboardType type;
  final Function onPressed;

  // Method to Return Type
  String get _typeText => type.toString().split('.').last;

  const _AnimatedButtonOption({Key key, this.type, this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Expanded(
        child: NeumorphicButton(
          style: NeumorphicStyle(
              surfaceIntensity: 0.3,
              shape: NeumorphicShape.convex,
              shadowDarkColor: HexColor.fromHex("333333"),
              depth: 12,
              color: HexColor.fromHex("EFEEEE"),
              boxShape: NeumorphicBoxShape.circle()),
          child: RiveActor.fromType(
            type: type,
            width: Get.width,
            height: Get.height,
          ),
          onPressed: onPressed,
        ),
      ),
      Padding(padding: EdgeInsets.only(top: 4)),
      SonrText.normal(_typeText, size: 14, color: Colors.white),
    ]);
  }
}
