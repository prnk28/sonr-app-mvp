import '../style.dart';

class ButtonUtility {
  static const K_BUTTON_DURATION = Duration(milliseconds: 150);
  static const K_CONFIRM_DURATION = Duration(milliseconds: 325);
  static const double K_BORDER_RADIUS = 40;
  static const K_BUTTON_PADDING = EdgeInsets.symmetric(horizontal: 24, vertical: 8);

  // @ Helper to Build Complete View
  static Widget buildCompleteChild(IconData icon, String text) {
    return Container(
        padding: EdgeInsets.all(8),
        child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [buildIcon(icon), Padding(padding: EdgeInsets.all(4)), buildText(text)]));
  }

  // @ Helper Method to Build Icon View //
  static Widget buildChild(WidgetPosition iconPosition, IconData? icon, String? text, Widget? child) {
    if (child != null) {
      return child;
    } else if (icon != null && text == null) {
      return Container(padding: EdgeInsets.all(8), child: buildIcon(icon));
    } else if (text != null && icon == null) {
      return Container(padding: EdgeInsets.all(8), child: buildText(text));
    } else if (text != null && icon != null) {
      switch (iconPosition) {
        case WidgetPosition.Left:
          return Container(
              padding: EdgeInsets.all(8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [buildIcon(icon), Padding(padding: EdgeInsets.all(4)), buildText(text)]));
        case WidgetPosition.Right:
          return Container(
              padding: EdgeInsets.all(8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [buildText(text), Padding(padding: EdgeInsets.all(4)), buildIcon(icon)]));
        case WidgetPosition.Top:
          return Container(
              padding: EdgeInsets.all(8),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [buildIcon(icon), Padding(padding: EdgeInsets.all(4)), buildText(text)]));
        case WidgetPosition.Bottom:
          return Container(
              padding: EdgeInsets.all(8),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [buildText(text), Padding(padding: EdgeInsets.all(4)), buildIcon(icon)]));
        case WidgetPosition.Center:
          return icon.black;
        default:
          return Container();
      }
    } else {
      return Container();
    }
  }

  static Widget buildIcon(IconData data) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 2.0,
          child: Icon(data, color: SonrColor.Black.withOpacity(0.5), size: 20),
        ),
        Icon(data, color: Colors.white, size: 20),
      ],
    );
  }

  static Widget buildText(String text) {
    return Container(child: text.subheading(color: SonrColor.White));
  }
}
