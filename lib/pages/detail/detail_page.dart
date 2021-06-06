import 'package:sonr_app/style.dart';
import 'detail.dart';
import 'views/views.dart';

class Details {
  /// Return Details CardGrid Page
  static Widget cardsGrid(TransferItemsType itemsType) {
    return CardsView.display(DetailPageType.CardsGrid, itemsType);
  }

  /// Return Details CardList Page
  static Widget cardsList(TransferItemsType itemsType) {
    return CardsView.display(DetailPageType.CardsList, itemsType);
  }

  /// Return Details Item Detail Page
  static void toItemDetail(DetailPageType type) {
    Get.to(DetailView.display(type));
  }

  /// Return Details Error Page
  static void toError(DetailPageType type) {
    Get.to(ErrorView.display(type));
  }
}
