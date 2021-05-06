import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_custom.dart';
import 'package:sonr_app/style/style.dart';

class ColorPickerKeyboard extends StatelessWidget with KeyboardCustomPanelMixin<Color> implements PreferredSizeWidget {
  final ValueNotifier<Color> notifier;
  static const double _kKeyboardHeight = 200;

  ColorPickerKeyboard({Key? key, required this.notifier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double rows = 3;
    final double screenWidth = MediaQuery.of(context).size.width;
    final int colorsCount = Colors.primaries.length;
    final int colorsPerRow = (colorsCount / rows).ceil();
    final double itemWidth = screenWidth / colorsPerRow;
    final double itemHeight = _kKeyboardHeight / rows;

    return Container(
      height: _kKeyboardHeight,
      child: Wrap(
        children: <Widget>[
          for (final color in Colors.primaries)
            GestureDetector(
              onTap: () {
                updateValue(color);
              },
              child: Container(
                color: color,
                width: itemWidth,
                height: itemHeight,
              ),
            )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_kKeyboardHeight);
}

class CardPickerKeyboard extends StatelessWidget with KeyboardCustomPanelMixin<int> implements PreferredSizeWidget {
  final ValueNotifier<int> notifier;
  static const double _kKeyboardHeight = 200;

  CardPickerKeyboard({Key? key, required this.notifier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double rows = 3;
    final double screenWidth = Width.full;
    final int cardsCount = 75;
    final int cardsPerRow = 2;
    final double itemWidth = screenWidth / cardsPerRow;
    final double itemHeight = _kKeyboardHeight / rows;

    return Container(
      height: _kKeyboardHeight,
      child: Wrap(
        children: List<Widget>.generate(
            cardsCount,
            (index) => GestureDetector(
                  onTap: () {
                    updateValue(index + 1);
                  },
                  child: Container(
                    width: itemWidth,
                    height: itemHeight,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage("assets/cards/0$index.png"),
                    )),
                  ),
                )),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(_kKeyboardHeight);
}
