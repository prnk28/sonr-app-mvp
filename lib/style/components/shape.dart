import 'package:sonr_app/style.dart';

/// ### BoxContainer
/// Builds **Rounded Square** Neumorphic Shape Container.
class BoxContainer extends StatelessWidget {
  final Widget? child;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Decoration? foregroundDecoration;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip clipBehavior;
  final double radius;
  final double? width;
  final double? height;

  const BoxContainer({
    required this.child,
    Key? key,
    this.alignment,
    this.padding,
    this.foregroundDecoration,
    this.constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
    this.clipBehavior = Clip.none,
    this.radius = 24,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      width: width,
      height: height,
      alignment: alignment,
      padding: padding,
      foregroundDecoration: foregroundDecoration,
      constraints: constraints,
      margin: margin,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
      child: child,
      decoration: BoxDecoration(
        border: Border.all(color: SonrTheme.backgroundColor, width: 1),
        color: SonrTheme.foregroundColor,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: SonrTheme.boxShadow,
      ),
    );
  }
}

/// ### CircleContainer
/// Builds **Circle** Neumorphic Shape Container.
class CircleContainer extends StatelessWidget {
  final Widget? child;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Decoration? foregroundDecoration;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip clipBehavior;
  final double? width;
  final double? height;

  const CircleContainer({
    required this.child,
    this.clipBehavior = Clip.none,
    Key? key,
    this.alignment,
    this.padding,
    this.foregroundDecoration,
    this.constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
    this.width,
    this.height,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      alignment: alignment,
      width: width,
      height: height,
      padding: padding,
      foregroundDecoration: foregroundDecoration,
      constraints: constraints,
      margin: margin,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
      child: child,
      decoration: BoxDecoration(
        border: Border.all(color: SonrTheme.foregroundColor, width: 1),
        color: UserService.isDarkMode ? SonrColor.Black : SonrColor.White,
        shape: BoxShape.circle,
        boxShadow: SonrTheme.circleBoxShadow,
      ),
    );
  }
}

/// ### PolyContainer
/// Builds **Polygon** Neumorphic Shape Container.
///
/// Paramaters:
/// `sides`
/// `rotate`
/// `radius`
/// `gradient` (Defaults to Primary Gradient)
class PolyContainer extends StatelessWidget {
  final Widget? child;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Decoration? foregroundDecoration;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Clip clipBehavior;
  final int sides;
  final double rotate;
  final double radius;
  final Gradient? gradient;
  final double? width;
  final double? height;

  const PolyContainer({
    required this.child,
    Key? key,
    this.alignment,
    this.padding,
    this.foregroundDecoration,
    this.constraints,
    this.margin,
    this.transform,
    this.transformAlignment,
    this.clipBehavior = Clip.none,
    this.sides = 6,
    this.rotate = 30,
    this.radius = 24,
    this.gradient,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPolygon(
      borderRadius: radius,
      rotate: rotate,
      boxShadows: SonrTheme.polyBoxShadow,
      sides: sides,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient ?? SonrGradient.Theme(),
          boxShadow: SonrTheme.boxShadow,
          border: Border.all(color: SonrTheme.foregroundColor, width: 1),
        ),
        key: key,
        width: width,
        height: height,
        alignment: alignment ?? Alignment.center,
        padding: padding,
        foregroundDecoration: foregroundDecoration,
        constraints: constraints,
        margin: margin,
        transform: transform,
        transformAlignment: transformAlignment,
        clipBehavior: clipBehavior,
        child: child,
      ),
    );
  }
}
