import 'package:sonr_app/theme/theme.dart';

class KeyboardController extends GetxController {
  final _selectedColor = Colors.blue.obs;
  final _selectedCard = 0.obs;

  void selectCard(int value) {
    _selectedCard(value);
  }

  void selectColor(Color color) {
    _selectedColor(color);
  }
}
