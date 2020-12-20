import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// ^ Find Icons color based on Theme - Light/Dark ^
Color findIconsColor() {
  final theme = NeumorphicTheme.of(Get.context);
  if (Get.isDarkMode) {
    return theme.current.accentColor;
  } else {
    return null;
  }
}

// ^ Find Text color based on Theme - Light/Dark ^
Color findTextColor() {
  if (Get.isDarkMode) {
    return Colors.white;
  } else {
    return Colors.black;
  }
}

// ^ Gradient Mask ^
extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

Gradient useAnimatedGradient(
  List<Gradient> gradients, {
  Duration duration = const Duration(seconds: 5),
  Curve curve = Curves.easeInOut,
}) {
  return use(_AnimatedGradientHook(
    duration: duration,
    gradients: gradients,
    curve: curve,
  ));
}

class GradientTween extends Tween<Gradient> {
  GradientTween({
    Gradient begin,
    Gradient end,
  }) : super(begin: begin, end: end);

  @override
  Gradient lerp(double t) => Gradient.lerp(begin, end, t);
}

class _AnimatedGradientHook extends Hook<Gradient> {
  final List<Gradient> gradients;
  final Duration duration;
  final Curve curve;

  _AnimatedGradientHook({this.duration, this.gradients, this.curve});

  @override
  HookState<Gradient, Hook<Gradient>> createState() =>
      _AnimatedGradientHookState();
}

class _AnimatedGradientHookState
    extends HookState<Gradient, _AnimatedGradientHook> {
  @override
  Gradient build(BuildContext context) {
    final controller = useAnimationController(duration: hook.duration);
    final index = useValueNotifier(0);

    useEffect(() {
      controller.repeat();
      final listener = () {
        final newIndex = (controller.value * hook.gradients.length).floor() %
            hook.gradients.length;
        if (newIndex != index.value) index.value = newIndex;
      };
      controller.addListener(listener);
      return () => controller.removeListener(listener);
    }, [hook.gradients, hook.duration, hook.curve]);

    return useAnimation(GradientTween(
            begin: hook.gradients[index.value],
            end: hook.gradients[(index.value + 1) % hook.gradients.length])
        .animate(CurvedAnimation(
            curve: Interval(
              index.value / hook.gradients.length,
              (index.value + 1) / hook.gradients.length,
              curve: hook.curve,
            ),
            parent: controller)));
  }
}
