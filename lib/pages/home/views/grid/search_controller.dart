import 'package:sonr_app/style/style.dart';
import 'package:sonr_app/data/data.dart';

class SearchController extends GetxController {
  // Properties
  final results = RxList<TransferCard>();

  /// ### SearchName:
  /// Enables Searching Local TransferCard DB with a given name.
  Future<void> search(String query) async {
    // Fetch Results
    var dateResults = CardService.all.where((e) => e.matchesDate(query)).toList();
    var nameResults = CardService.all.where((e) => e.matchesName(query)).toList();
    var payloadResults = CardService.all.where((e) => e.matchesPayload(query)).toList();

    // Update Results
    results.addAll(dateResults);
    results.addAll(nameResults);
    results.addAll(payloadResults);
    results.toSet();
    results.refresh();
  }
}
