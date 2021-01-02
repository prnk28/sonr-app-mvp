import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:sonar_app/modules/home/home_controller.dart';
import 'package:sonar_app/theme/theme.dart';

class ShareButton extends GetView<HomeController> {
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
                      ? _buildExpandedChild()
                      : _buildDefaultChild(),
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

  // Build Child View
  Widget _buildDefaultChild() {
    return Center(
        child: SonrText.header(
      "Share",
      size: 32,
      gradient: FlutterGradientNames.glassWater,
    ));
  }

  // Build Expanded Child View
  Widget _buildExpandedChild() {
    return PlayAnimation<double>(
        tween: (0.0).tweenTo(1.0),
        duration: 100.milliseconds,
        delay: 100.milliseconds,
        builder: (context, child, value) {
          final controller = Get.find<HomeController>();
          return AnimatedOpacity(
              opacity: value,
              duration: 500.milliseconds,
              child: NeumorphicTheme(
                theme: NeumorphicThemeData(
                  baseColor: Color.fromRGBO(239, 238, 238, 1.0),
                  lightSource: LightSource.top,
                  depth: 8,
                  intensity: 0.6,
                ),
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    verticalDirection: VerticalDirection.up,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: _AnimatedButtonOption(
                          onPressed: () {
                            controller.openCamera();
                          },
                          type: "Camera",
                        ),
                      ),
                      Expanded(
                        child: _AnimatedButtonOption(
                          onPressed: () {
                            controller.openFilePicker();
                          },
                          type: "Gallery",
                        ),
                      ),
                      Expanded(
                        child: _AnimatedButtonOption(
                          onPressed: () {
                            controller.queueContact();
                          },
                          type: "Contact",
                        ),
                      )
                    ]),
              ));
        });
  }
}

class _AnimatedButtonOption extends StatefulWidget {
  // Properties
  final String type;
  final Function onPressed;

  const _AnimatedButtonOption({Key key, this.type, this.onPressed})
      : super(key: key);
  @override
  _AnimatedButtonOptionState createState() => _AnimatedButtonOptionState();
}

class _AnimatedButtonOptionState extends State<_AnimatedButtonOption> {
  Artboard _riveArtboard;
  @override
  void initState() {
    final artboard = Get.find<HomeController>().getArtboard(widget.type);
    setState(() => _riveArtboard = artboard);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      NeumorphicButton(
        style: NeumorphicStyle(
            color: HexColor.fromHex("EFEEEE"),
            boxShape: NeumorphicBoxShape.circle()),
        child: SizedBox(
          height: 55,
          width: 55,
          child: Center(
              child: _riveArtboard == null
                  ? const SizedBox(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blueAccent)))
                  : Rive(artboard: _riveArtboard)),
        ),
        onPressed: widget.onPressed,
      ),
      Padding(padding: EdgeInsets.only(top: 4)),
      SonrText.normal(widget.type.toString(), size: 14, color: Colors.white),
    ]);
  }
}
