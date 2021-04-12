import '../theme.dart';

class ButtonUtility {
  static const K_BUTTON_DURATION = Duration(milliseconds: 100);
  static const double K_BORDER_RADIUS = 8;
  static const K_BUTTON_PADDING = EdgeInsets.symmetric(horizontal: 24, vertical: 8);

  // @ Helper Method to Build Icon View //
  static Widget buildChild(WidgetPosition iconPosition, SonrIcon icon, String text, Widget child) {
    if (child != null) {
      return child;
    } else if (icon != null && text == null) {
      return Container(padding: EdgeInsets.all(8), child: icon);
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
          return icon;
        default:
          return Container();
      }
    } else {
      return Container();
    }
  }

  static Widget buildIcon(SonrIcon icon) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 2.0,
          child: Icon(icon.data, color: SonrColor.Black.withOpacity(0.5), size: 20),
        ),
        Icon(icon.data, color: Colors.white, size: 20),
      ],
    );
  }

  static Widget buildText(String text) {
    return Text(text,
        overflow: TextOverflow.fade,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: Colors.white,
            shadows: [Shadow(blurRadius: 4, color: SonrColor.Black.withOpacity(0.5))]));
  }
}
