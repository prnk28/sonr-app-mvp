import 'package:sonr_app/style/style.dart';

/// #### Class Builds Alert View Widget for Overlay ** //
class AlertOverlay extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final Function() onPressed;

  // Constructer
  AlertOverlay(this.title, this.description, this.buttonText, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return ObxValue<RxBool>(
        (hasDecided) => AnimatedBig(
              isDisplayed: !hasDecided.value,
              direction: BigDirection.Up,
              child: BoxContainer(
                padding: EdgeInsets.symmetric(vertical: 12),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 220),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  title.heading(),
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: description.paragraph(),
                  ),
                  Padding(padding: EdgeInsets.all(4)),
                  Divider(),
                  Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                    // Accept Button
                    ColorButton.primary(
                      onPressed: () {
                        hasDecided(true);
                        Future.delayed(250.milliseconds, () => Get.back());
                      },
                      icon: SimpleIcons.Check,
                      text: buttonText,
                    ),
                  ]),
                ]),
              ),
            ),
        false.obs);
  }
}

/// #### Class Builds Dropdown View Widget for Positioned Overlay ** //
class PositionedOverlay extends StatelessWidget {
  final GlobalKey parentKey;
  final Widget child;
  final RxBool hasDismissed;
  final Offset? offset;

  // Constructer
  PositionedOverlay({required this.parentKey, required this.child, required this.hasDismissed, this.offset});

  @override
  Widget build(BuildContext context) {
    RenderBox renderBox = parentKey.currentContext!.findRenderObject() as RenderBox;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    return Obx(() => Container(
          width: Get.width,
          height: Get.height,
          child: Stack(children: [
            Positioned(
              top: _calculateTop(offset),
              right: _calculateRight(offset),
              left: _calculateLeft(offset),
              bottom: _calculateBottom(offset),
              child: Container(
                  constraints: BoxConstraints(maxWidth: PositionedOverlay.MAX_WIDTH, maxHeight: PositionedOverlay.MAX_HEIGHT),
                  child: AnimatedBounce(
                      direction: BounceDirectionUtils.fromOffset(
                        top: _calculateTop(offset),
                        right: _calculateRight(offset),
                        left: _calculateLeft(offset),
                        bottom: _calculateBottom(offset),
                      ),
                      isDisplayed: !hasDismissed.value,
                      child: child)),
            )
          ]),
        ));
  }

  /// Calculates Top Position for Widget
  double? _calculateTop(Offset parentOffset) {
    if (parentOffset.dy + PositionedOverlay.MAX_HEIGHT < Height.full) {
      return offset != null ? parentOffset.dy + offset!.dy : parentOffset.dy + 24;
    } else {
      return null;
    }
  }

  /// Calculates Left Position for Widget
  double? _calculateLeft(Offset parentOffset) {
    if (parentOffset.dx + PositionedOverlay.MAX_WIDTH < Width.full) {
      return offset != null ? offset!.dx + parentOffset.dx : parentOffset.dx;
    } else {
      return null;
    }
  }

  /// Calculates Right Position for Widget
  double? _calculateRight(Offset parentOffset) {
    if (parentOffset.dx + PositionedOverlay.MAX_WIDTH > Width.full) {
      return offset != null ? offset!.dx + Width.full - parentOffset.dx : Width.full - parentOffset.dx;
    } else {
      return null;
    }
  }

  /// Calculates Bottom Position for Widget
  double? _calculateBottom(Offset parentOffset) {
    if (parentOffset.dy + PositionedOverlay.MAX_HEIGHT > Height.full) {
      return offset != null ? Height.full - parentOffset.dy - 24 + offset!.dy : Height.full - parentOffset.dy - 24;
    } else {
      return null;
    }
  }

  /// Returns Max Positioned Child Height
  static double get MAX_HEIGHT => Height.ratio(0.5);

  /// Returns Max Positioned Child Width
  static double get MAX_WIDTH => Width.reduced(0.3);
}

/// #### Class Builds Question View Widget for Overlay ** //
class QuestionOverlay extends StatelessWidget {
  final String title;
  final String description;
  final Function(bool) onDecision;
  final String acceptTitle;
  final String declineTitle;

  // Constructer
  QuestionOverlay(this.title, this.description, this.onDecision, this.acceptTitle, this.declineTitle);

  @override
  Widget build(BuildContext context) {
    return ObxValue<RxBool>(
        (hasDecided) => AnimatedBig(
              direction: BigDirection.Down,
              isDisplayed: !hasDecided.value,
              child: BoxContainer(
                padding: EdgeInsets.symmetric(vertical: 24),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 256),
                child: Container(
                  child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
                    title.heading(),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: description.paragraph(color: Get.theme.focusColor),
                    ),
                    Padding(padding: EdgeInsets.all(4)),
                    Divider(),
                    Padding(padding: EdgeInsets.all(4)),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      // Decline Button
                      ColorButton.neutral(
                        onPressed: () {
                          hasDecided(true);
                          Future.delayed(250.milliseconds, () => onDecision(false));
                        },
                        text: declineTitle,
                      ),
                      // Accept Button
                      ColorButton.primary(
                        onPressed: () {
                          hasDecided(true);
                          Future.delayed(250.milliseconds, () => onDecision(true));
                        },
                        icon: SimpleIcons.Check,
                        text: acceptTitle,
                      ),
                    ]),
                  ]),
                ),
              ),
            ),
        false.obs);
  }
}
