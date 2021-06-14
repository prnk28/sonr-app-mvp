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
        boxShadow: _BoxShadowUtil.boxShadow(),
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
      decoration: BoxDecoration(color: SonrColor.White, shape: BoxShape.circle, boxShadow: [
        BoxShadow(offset: Offset(2, 2), blurRadius: 8, color: SonrColor.Black.withOpacity(0.2)),
      ]),
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
      boxShadows: _BoxShadowUtil.polyShadow(),
      sides: sides,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient ?? SonrGradient.Theme,
          boxShadow: _BoxShadowUtil.boxShadow(),
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

/// @ Helper Class Builds Box Shadow By Container Type
class _BoxShadowUtil {
  static List<PolygonBoxShadow> polyShadow() {
    return UserService.isDarkMode
        ? [
            PolygonBoxShadow(
              color: Colors.black.withOpacity(0.4),
              elevation: 10,
            )
          ]
        : [
            PolygonBoxShadow(
              color: Color(0xffD4D7E0).withOpacity(0.4),
              elevation: 10,
            )
          ];
  }

  static List<BoxShadow> boxShadow() {
    return UserService.isDarkMode
        ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              offset: Offset(0, 20),
              blurRadius: 30,
            )
          ]
        : [
            BoxShadow(
              color: Color(0xffD4D7E0).withOpacity(0.75),
              offset: Offset(0, 20),
              blurRadius: 30,
            )
          ];
  }
}