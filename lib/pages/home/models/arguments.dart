import 'package:sonr_app/style.dart';

// ** ─── HomePage Arguments ────────────────────────────────────────────────────────

/// Class to Provide Arguments for HomePage
class HomePageArgs {
  final bool isFirstLoad;
  final bool hasNewCard;
  final bool firstNewCard;
  final Transfer? newCard;

  HomePageArgs({this.isFirstLoad = false, this.hasNewCard = false, this.firstNewCard = false, this.newCard});
}
