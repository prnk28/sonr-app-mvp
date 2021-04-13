import 'package:sonr_app/service/sonr.dart';

class HomeArguments {
  final bool isFirstLoad;
  final bool hasNewCard;
  final bool firstNewCard;
  final TransferCard newCard;

  HomeArguments({this.isFirstLoad = false, this.hasNewCard = false, this.firstNewCard = false, this.newCard});
}

class TransferArguments {
  final Payload payload;
  final Metadata metadata;
  final Contact contact;
  final String url;
  TransferArguments(this.payload, {this.metadata, this.contact, this.url});
}
