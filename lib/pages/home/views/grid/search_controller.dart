import 'package:sonr_app/style/style.dart';
import 'package:sonr_app/data/data.dart';

class SearchController extends GetxController {
  // Properties
  final results = RxList<TransferCard>();

  /// ### SearchName:
  /// Enables Searching Local TransferCard DB with a given name.
  Future<void> searchName(String query) async {
    results(CardService.all.where((e) => e.matches(query)).toList());
  }
}
