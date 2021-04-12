import 'package:sonr_app/service/sonr.dart';

class HomeArguments {
  final bool isFirstLoad;
  final bool hasNewCard;
  final bool firstNewCard;
  final TransferCard newCard;

  HomeArguments({this.isFirstLoad = false, this.hasNewCard = false, this.firstNewCard = false, this.newCard});
}
