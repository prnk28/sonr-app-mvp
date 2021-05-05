import '../theme.dart';

extension Neumorphic on BoxDecoration {
  /// @ Floating Contact Neumorphic Box
  static BoxDecoration contact({@required Image image}) {
    return BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: image.image,
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Color(0xfff0f6fa), BlendMode.difference),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(
              0xb9b0c3d2,
            ),
            offset: Offset(
              8,
              8,
            ),
            spreadRadius: 4,
            blurRadius: 20,
          ),
          BoxShadow(
            color: Color(
              0x61f6fbff,
            ),
            offset: Offset(
              -8,
              -8,
            ),
            blurRadius: 20,
          ),
          BoxShadow(
            color: Color(
              0x45ffffff,
            ),
            offset: Offset(
              -11,
              -11,
            ),
            blurRadius: 20,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.15),
            offset: Offset(-6.0, -6.0),
            blurRadius: 16.0,
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.65), width: 1));
  }

  /// @ Compact Neumorphic Box Flat for Overlays
  static BoxDecoration compact({Color color, double radius = 12, BoxShape shape = BoxShape.rectangle, Border border}) {
    return BoxDecoration(
      shape: shape,
      border: border != null ? border : Border.all(color: Colors.white.withOpacity(0.65), width: 1),
      borderRadius: shape != BoxShape.circle ? BorderRadius.circular(radius) : null,
      color: color != null ? color : Color(0xfff0f6fa).withOpacity(0.85),
      boxShadow: [
        BoxShadow(
          blurRadius: 14,
          color: Color(0xff363636).withOpacity(0.45),
          offset: Offset(
            5,
            5,
          ),
        ),
        BoxShadow(
          blurRadius: 14,
          color: Color(0xff484848).withOpacity(0.35),
          offset: Offset(
            -5,
            -5,
          ),
        ),
      ],
    );
  }

  /// @ Floating Default Neumorphic Box
  static BoxDecoration floating({Color color, double radius = 12, BoxShape shape = BoxShape.rectangle, Border border}) {
    return BoxDecoration(
      shape: shape,
      border: border != null ? border : Border.all(color: Colors.white.withOpacity(0.65), width: 1),
      borderRadius: shape != BoxShape.circle ? BorderRadius.circular(radius) : null,
      color: color != null ? color : Color(0xfff0f6fa).withOpacity(0.85),
      boxShadow: [
        BoxShadow(
          color: Color(
            0xb9b0c3d2,
          ),
          offset: Offset(
            8,
            8,
          ),
          spreadRadius: 4,
          blurRadius: 20,
        ),
        BoxShadow(
          color: Color(
            0x61f6fbff,
          ),
          offset: Offset(
            -8,
            -8,
          ),
          blurRadius: 20,
        ),
        BoxShadow(
          color: Color(
            0x45ffffff,
          ),
          offset: Offset(
            -11,
            -11,
          ),
          blurRadius: 20,
        ),
        BoxShadow(
          color: Colors.white.withOpacity(0.15),
          offset: Offset(-6.0, -6.0),
          blurRadius: 16.0,
        ),
      ],
    );
  }

  /// @ Orange Red Hue Neumorphic Box
  static BoxDecoration rainbow({double radius = 20, BoxShape shape = BoxShape.rectangle}) {
    return BoxDecoration(
      shape: shape,
      borderRadius: shape != BoxShape.circle ? BorderRadius.circular(radius) : null,
      boxShadow: [
        BoxShadow(
          color: Color(
            0x99f7925a,
          ),
          offset: Offset(
            40,
            2,
          ),
          blurRadius: 70,
        ),
        BoxShadow(
          color: Color(
            0x99f470b1,
          ),
          offset: Offset(
            -40,
            2,
          ),
          blurRadius: 70,
        ),
      ],
      gradient: LinearGradient(
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
        colors: [
          Color(
            0xfff7964f,
          ),
          Color(
            0xfff364ce,
          ),
        ],
      ),
    );
  }

  /// @ Slightly Indented Neumorphic Box
  static BoxDecoration indented({double radius = 20, BoxShape shape = BoxShape.rectangle}) {
    return BoxDecoration(
      shape: shape,
      borderRadius: shape != BoxShape.circle ? BorderRadius.circular(radius) : null,
      color: Color(0xfff0f6fa).withOpacity(0.8),
      boxShadow: [
        BoxShadow(
          color: Color(
            0x61f6fbff,
          ),
          offset: Offset(
            -8,
            -8,
          ),
          blurRadius: 10,
        ),
        BoxShadow(
          color: Color(
            0x45ffffff,
          ),
          offset: Offset(
            -11,
            -11,
          ),
          blurRadius: 10,
        ),
      ],
    );
  }
}

// ^ Edge Insets Helper Extensions ^ //
extension EdgeWith on EdgeInsets {
  // Top Only Insets
  static EdgeInsets top(double value) {
    return EdgeInsets.only(top: value);
  }

  // Bottom Only Insets
  static EdgeInsets bottom(double value) {
    return EdgeInsets.only(bottom: value);
  }

  // Left Only Insets
  static EdgeInsets left(double value) {
    return EdgeInsets.only(left: value);
  }

  // Right Only Insets
  static EdgeInsets right(double value) {
    return EdgeInsets.only(right: value);
  }

  // Vertical Symmetric Only Insets
  static EdgeInsets vertical(double value) {
    return EdgeInsets.symmetric(vertical: value);
  }

  // Horizontal Symmetric Only Insets
  static EdgeInsets horizontal(double value) {
    return EdgeInsets.symmetric(horizontal: value);
  }
}

// ^ Padding Helper Extensions ^ //
extension PadWith on Padding {
  // Top Only Insets
  static Padding top(double value) {
    return Padding(padding: EdgeInsets.only(top: value));
  }

  // Bottom Only Insets
  static Padding bottom(double value) {
    return Padding(padding: EdgeInsets.only(bottom: value));
  }

  // Left Only Insets
  static Padding left(double value) {
    return Padding(padding: EdgeInsets.only(left: value));
  }

  // Right Only Insets
  static Padding right(double value) {
    return Padding(padding: EdgeInsets.only(right: value));
  }

  // Vertical Symmetric Only Insets
  static Padding vertical(double value) {
    return Padding(padding: EdgeInsets.symmetric(vertical: value));
  }

  // Horizontal Symmetric Only Insets
  static Padding horizontal(double value) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: value));
  }
}
