import 'package:get/get.dart';
import 'package:sonr_app/modules/home/home_controller.dart';
import 'package:sonr_app/theme/theme.dart';

const double K_ITEM_SPACING = 12;

class ShareButton extends GetView<HomeController> {
  final expandedView = _ExpandedView();
  final defaultView = _DefaultView();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Align(
        alignment: Alignment.bottomCenter,
        child: AnimatedContainer(
            curve: Curves.easeInBack,
            padding: EdgeInsetsDirectional.only(start: 30),
            width: controller.isExpanded.value ? Get.width / 2 + 165 : Get.width / 2 + 30,
            height: controller.isExpanded.value ? 130 : 70,
            duration: 200.milliseconds,
            child: Center(
              child: NeumorphicButton(
                  child: controller.isExpanded.value ? expandedView : defaultView,
                  onPressed: controller.toggleShareExpand,
                  style: NeumorphicStyle(
                    color: Colors.black87,
                    surfaceIntensity: 0.6,
                    intensity: 0.75,
                    depth: 8,
                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(40)),
                  )),
            )),
      );
    });
  }
}

class _DefaultView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
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
        duration: 150.milliseconds,
        delay: 150.milliseconds,
        builder: (context, child, value) {
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
                    child: _ShareButtonRow())),
          );
        });
  }
}

class _ShareButtonRow extends GetView<HomeController> {
  const _ShareButtonRow();
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.max,
        verticalDirection: VerticalDirection.up,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Container(
              height: Get.height,
              child: _ShareButtonItem(
                onPressed: () {
                  controller.openCamera();
                },
                type: ArtboardType.Camera,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(K_ITEM_SPACING)),
          Expanded(
            child: Container(
              height: Get.height,
              child: _ShareButtonItem(
                onPressed: () {
                  controller.openMediaPicker();
                },
                type: ArtboardType.Gallery,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.all(K_ITEM_SPACING)),
          Expanded(
            child: Container(
              height: Get.height,
              child: _ShareButtonItem(
                onPressed: () {
                  controller.queueContact();
                },
                type: ArtboardType.Contact,
              ),
            ),
          )
        ]);
  }
}

class _ShareButtonItem extends StatelessWidget {
  // Properties
  final ArtboardType type;
  final Function onPressed;

  // Method to Return Type
  String get _typeText => type.toString().split('.').last;

  const _ShareButtonItem({Key key, this.type, this.onPressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Expanded(
        child: NeumorphicButton(
          style: NeumorphicStyle(
              surfaceIntensity: 0.3,
              shape: NeumorphicShape.convex,
              shadowDarkColor: SonrColor.fromHex("333333"),
              depth: 12,
              color: SonrColor.fromHex("EFEEEE"),
              boxShape: NeumorphicBoxShape.circle()),
          child: SonrRiveWidget.fromType(
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
