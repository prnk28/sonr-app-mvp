import '../style.dart';

class ButtonUtility {
  static const K_BUTTON_DURATION = Duration(milliseconds: 150);
  static const K_CONFIRM_DURATION = Duration(milliseconds: 325);
  static const double K_BORDER_RADIUS = 22;
  static const K_BUTTON_PADDING = EdgeInsets.symmetric(horizontal: 24, vertical: 8);

  // @ Helper to Build Complete View
  static Widget buildCompleteChild(IconData icon, String text) {
    return Container(
        padding: EdgeInsets.all(8),
        child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [buildIcon(icon), Padding(padding: EdgeInsets.all(4)), buildPrimaryText(text)]));
  }

  // @ Helper Method to Build Icon View //
  static Widget buildChild(WidgetPosition iconPosition, IconData? icon, String? text, Widget? child) {
    if (child != null) {
      return child;
    } else if (icon != null && text == null) {
      return Container(padding: EdgeInsets.all(8), child: buildIcon(icon));
    } else if (text != null && icon == null) {
      return Container(padding: EdgeInsets.all(8), child: buildPrimaryText(text));
    } else if (text != null && icon != null) {
      switch (iconPosition) {
        case WidgetPosition.Left:
          return Container(
              padding: EdgeInsets.all(8),
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [buildIcon(icon), Padding(padding: EdgeInsets.all(4)), buildPrimaryText(text)]));
        case WidgetPosition.Right:
          return Container(
              padding: EdgeInsets.all(8),
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [buildPrimaryText(text), Padding(padding: EdgeInsets.all(4)), buildIcon(icon)]));
        case WidgetPosition.Top:
          return Container(
              padding: EdgeInsets.all(8),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [buildIcon(icon), Padding(padding: EdgeInsets.all(4)), buildPrimaryText(text)]));
        case WidgetPosition.Bottom:
          return Container(
              padding: EdgeInsets.all(8),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [buildPrimaryText(text), Padding(padding: EdgeInsets.all(4)), buildIcon(icon)]));
        case WidgetPosition.Center:
          return icon.black;
        default:
          return Container();
      }
    } else {
      return Container();
    }
  }

  static Widget buildUiIcon(UIIcons ico) {
    return ico.line(width: 24, height: 24, color: AppTheme.ItemColorInversed);
  }

  static Widget buildIcon(IconData data) {
    return Icon(data, color: Colors.white, size: 24);
  }

  static Widget buildPrimaryText(String text) {
    return Container(child: text.heading(color: AppColor.White, fontSize: 22));
  }

  static Widget buildNeutralText(String text, Color? textColor) {
    return Container(child: text.heading(color: textColor ?? AppTheme.ItemColor, fontSize: 22));
  }
}
