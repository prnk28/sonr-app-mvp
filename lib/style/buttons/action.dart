import 'package:sonr_app/style/style.dart';

import 'utility.dart';

class ActionButton extends StatefulWidget {
  /// Function called on Tap Up
  final Function onPressed;

  /// Widget for Action Icon: Max Size 32
  final IconData iconData;

  /// String for Text Below Button
  final String? label;

  /// Integer for Banner Label
  final ActionBanner? banner;

  /// Pulse the Action Button
  final bool pulse;

  const ActionButton({Key? key, required this.onPressed, required this.iconData, this.label, this.banner, this.pulse = false}) : super(key: key);

  @override
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool oldIsPulsing = false;

  @override
  void didUpdateWidget(ActionButton oldWidget) {
    if (oldWidget.pulse != widget.pulse) {
      oldIsPulsing = oldWidget.pulse;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.label != null) {
      return SizedBox(
        width: 40,
        height: 65,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Pulse(
              infinite: true,
              animate: widget.pulse,
              child: _ActionIconButton(widget.onPressed, widget.iconData),
            ),
            widget.label!.light(color: Get.theme.hintColor, fontSize: 16),
          ],
        ),
      );
    }

    if (widget.banner != null) {
      return Pulse(
        infinite: true,
        animate: widget.pulse,
        child: Container(
          constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              _ActionIconButton(widget.onPressed, widget.iconData),
              Positioned.directional(
                start: widget.banner!.start,
                top: widget.banner!.top,
                textDirection: widget.banner!.textDirection,
                child: Container(
                  width: widget.banner!.width,
                  height: widget.banner!.height,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(bottom: 28),
                  decoration: widget.banner!.decoration(),
                  child: widget.banner!.text(),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Pulse(
      infinite: true,
      animate: widget.pulse,
      child: _ActionIconButton(widget.onPressed, widget.iconData),
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  /// Function called on Tap Up
  final Function onPressed;

  /// Widget for Action Icon: Max Size 32
  final IconData iconData;
  const _ActionIconButton(this.onPressed, this.iconData, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ObxValue<RxBool>(
          (isPressed) => GestureDetector(
                onTapDown: (details) => isPressed(true),
                onTapCancel: () => isPressed(false),
                onTapUp: (details) async {
                  isPressed(false);
                  await HapticFeedback.mediumImpact();
                  Future.delayed(ButtonUtility.K_BUTTON_DURATION, () {
                    onPressed();
                  });
                },
                child: AnimatedScale(
                  scale: isPressed.value ? 1.2 : 1.0,
                  child: Container(
                    constraints: BoxConstraints.tight(Size(40, 40)),
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Preferences.isDarkMode ? AppTheme.foregroundColor : Color(0xffEAEAEA),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      iconData,
                      color: AppTheme.itemColor,
                      size: 24,
                    ),
                  ),
                ),
              ),
          false.obs),
    );
  }
}

/// Class Manages ActionBanner for ActionButton
class ActionBanner {
  /// Count for Banner
  final int count;
  ActionBanner(this.count);

  /// Return Banner Width
  double get width => count != -1 ? 18 : 8;

  /// Return Banner Height
  double get height => count != -1 ? 18 : 8;

  /// Return Banner Position Top
  double get top => count != -1 ? 28 : 4;

  /// Return Banner Position Start
  double get start => count != -1 ? 28 : 4;

  /// Return Banner Position TextDirection
  TextDirection get textDirection => count != -1 ? TextDirection.rtl : TextDirection.ltr;

  /// Build Alert Style Banner
  factory ActionBanner.alert() {
    return ActionBanner(-1);
  }

  /// Build Selected Items Banner
  factory ActionBanner.selected(int count) {
    return ActionBanner(count);
  }

  /// Helper: Builds BoxDecoration from Banner Data
  BoxDecoration decoration() {
    return BoxDecoration(shape: BoxShape.circle, color: Color(0xffFF0057));
  }

  /// Helper: Builds Text from Banner Data
  Widget text() {
    return count.toString().subheading(fontSize: 14, color: Colors.white, align: TextAlign.center);
  }
}
