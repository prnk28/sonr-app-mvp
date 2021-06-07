import 'package:sonr_app/style.dart';
import 'detail.dart';
import 'views/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonr_app/modules/card/card.dart';

class Details {
  /// Shifts to Details CardGrid Page
  static void toCardsGrid(TransferItemsType itemsType) {
    _present(CardsView.display(DetailPageType.CardsGrid, itemsType), DetailPageType.CardsList, itemsType.name());
  }

  /// Shifts to Details CardList Page
  static void toCardsList(TransferItemsType itemsType) {
    _present(CardsView.display(DetailPageType.CardsList, itemsType), DetailPageType.CardsList, itemsType.name());
  }

  /// Shifts to Details Item Detail Page
  static void toItemDetail(DetailPageType type) {
    _present(DetailView.display(type), type);
  }

  /// Shifts to Details Error Page
  static void toError(DetailPageType type) {
    _present(ErrorView(type: type), type);
  }

  // @ Helper: To Shift Page
  static void _present(Widget body, DetailPageType type, [String title = ""]) {
    Get.to(DetailsScreen(body: body, type: type, title: title));
  }
}

/// @ QuickAccessScreen from Home
class DetailsScreen extends StatelessWidget {
  final Widget body;
  final DetailPageType type;
  final String? title;
  const DetailsScreen({Key? key, required this.type, required this.body, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (type.hasAppBar) {
      return SonrScaffold(
          appBar: DetailAppBar(
            onPressed: () => Get.back(closeOverlays: true),
            title: title ?? "Detail",
          ),
          body: body);
    } else {
      return body;
    }
  }
}
