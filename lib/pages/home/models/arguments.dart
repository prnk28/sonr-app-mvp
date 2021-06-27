import 'package:sonr_app/style/style.dart';

// ** ─── HomePage Arguments ────────────────────────────────────────────────────────

/// Class to Provide Arguments for HomePage
class HomeArguments {
  final bool isFirstLoad;
  final bool hasNewCard;
  final bool firstNewCard;
  final Transfer? newCard;

  HomeArguments({this.isFirstLoad = false, this.hasNewCard = false, this.firstNewCard = false, this.newCard});

  static HomeArguments get FirstLoad => HomeArguments(isFirstLoad: true);
}
