import 'package:sonr_app/pages/detail/detail.dart';
import 'package:sonr_app/style/style.dart';

class CardsView {
  static Widget display(DetailPageType type) {
    if (type == DetailPageType.CardsGrid) {
      return CardsGridView();
    } else {
      return CardsListView();
    }
  }
}

class CardsListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CardsGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
