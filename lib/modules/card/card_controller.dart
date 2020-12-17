import 'dart:async';

import 'package:get/get.dart';
import 'package:sonar_app/data/card_model.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonar_app/service/sql_service.dart';
import 'package:sonr_core/models/models.dart';
import 'package:sonr_core/sonr_core.dart';

class CardController extends GetxController {
  // Properties
  RxList<CardModel> allCards = List<CardModel>().obs;

  // Services
  final SQLService _sql = Get.find();

  onInit() async {
    new Timer.periodic(Duration(seconds: 10), (t) => _fetch);
    _fetch();
    super.onInit();
  }

  _fetch() async {
    // Fetch File Data
    _sql.fetchFiles().then((data) =>
        data.forEach((m) => allCards.add(CardModel.fromSQLData(meta: m))));

    // Fetch Contact Data
    _sql.fetchContacts().then((data) =>
        data.forEach((c) => allCards.add(CardModel.fromSQLData(contact: c))));
    allCards.refresh();
  }

  CardModel fetchLastFileCard() {
    SonrService sonr = Get.find();
    addFile(sonr.file());
    return CardModel(meta: sonr.file());
  }

  CardModel addFile(Metadata metadata) {
    // Save Card
    _sql.saveFile(metadata);

    // Create Metadata Card
    var card = CardModel(id: metadata.id, meta: metadata);

    // Add to Cards Display Last Card
    allCards.add(card);
    allCards.refresh();
    return card;
  }

  CardModel addContact(Contact contact) {
    // Save Card
    _sql.saveContact(contact);

    // Create Contact Card
    var card = CardModel(contact: contact);

    // Add to Cards Display Last Card
    allCards.add(card);
    allCards.refresh();
    return card;
  }
}
