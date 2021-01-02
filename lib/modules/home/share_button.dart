import 'package:get/get.dart';
import 'package:sonar_app/modules/home/home_controller.dart';
import 'package:sonar_app/theme/theme.dart';

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
            width: controller.isShareExpanded.value
                ? Get.width / 2 + 165
                : Get.width / 2 + 20,
            height: controller.isShareExpanded.value ? 130 : 70,
            duration: 200.milliseconds,
            child: Center(
              child: NeumorphicButton(
                  child: controller.isShareExpanded.value
                      ? expandedView
                      : defaultView,
                  onPressed: controller.toggleExpand,
                  style: NeumorphicStyle(
                    color: Colors.black87,
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
    return PlayAnimation<double>(
        tween: (0.0).tweenTo(1.0),
        duration: 100.milliseconds,
        delay: 100.milliseconds,
        builder: (context, child, value) {
          final controller = Get.find<HomeController>();
          return AnimatedOpacity(
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
                      Expanded(
                        child: Container(
                          height: Get.height,
                          child: _AnimatedButtonOption(
                            onPressed: () {
                              controller.openFilePicker();
                            },
                            type: ArtboardType.Gallery,
                          ),
                        ),
                      ),
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
              ));
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
      NeumorphicButton(
        style: NeumorphicStyle(
            surfaceIntensity: 0.7,
            depth: 8,
            shape: NeumorphicShape.convex,
            color: HexColor.fromHex("EFEEEE"),
            boxShape: NeumorphicBoxShape.circle()),
        child: RiveActor.fromType(type: type),
        onPressed: onPressed,
      ),
      Padding(padding: EdgeInsets.only(top: 4)),
      SonrText.normal(_typeText, size: 14, color: Colors.white),
    ]);
  }
}
