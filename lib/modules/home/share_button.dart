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
                : Get.width / 2 + 60,
            height: controller.isShareExpanded.value ? 130 : 80,
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
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: AnimatedOpacity(
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
                        verticalDirection: VerticalDirection.up,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _AnimatedButtonOption(
                            onPressed: () {
                              controller.openCamera();
                            },
                            type: "Camera",
                          ),
                          _AnimatedButtonOption(
                            onPressed: () {
                              controller.openFilePicker();
                            },
                            type: "Gallery",
                          ),
                          _AnimatedButtonOption(
                            onPressed: () {
                              controller.queueContact();
                            },
                            type: "Contact",
                          )
                        ]),
                  )),
            ),
          );
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
    // Load the RiveFile from the binary data.
    rootBundle.load('assets/animations/tile_preview.riv').then(
      (data) async {
        // Await Loading
        final file = RiveFile();
        if (file.import(data)) {
          // Retreive Artboard
          final artboard = file.mainArtboard;

          // Determine Animation by Tile Type
          artboard.addController(_riveControllerByType(widget.type));
          setState(() => _riveArtboard = artboard);
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      NeumorphicButton(
        style: NeumorphicStyle(
            color: K_BASE_COLOR, boxShape: NeumorphicBoxShape.circle()),
        child: SizedBox(
          height: 50,
          width: 50,
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

  // ^ Get Animation Controller By Type ^ //
  SimpleAnimation _riveControllerByType(String type) {
    // Retreive Feed Loop
    if (type == "Camera") {
      return SimpleAnimation('Feed');
    }
    // Retreive Showcase Loop
    else if (type == "Gallery") {
      return SimpleAnimation('Showcase');
    }
    // Retreive Icon Loop
    else {
      return SimpleAnimation('Icon');
    }
  }
}
