import 'package:get/get.dart';
import 'package:sonar_app/data/card_model.dart';
import 'package:sonar_app/service/sql_service.dart';
import 'package:sonr_core/models/models.dart';
import 'package:sonr_core/sonr_core.dart';

class HomeController extends GetxController {
  // Properties
  RxList<CardModel> allCards = List<CardModel>().obs;

  void fetch() async {
    // Fetch File Data
    Get.find<SQLService>().fetchFiles().then((data) =>
        data.forEach((m) => allCards.add(CardModel.fromSQLData(meta: m))));

    // Fetch Contact Data
    Get.find<SQLService>().fetchContacts().then((data) =>
        data.forEach((c) => allCards.add(CardModel.fromSQLData(contact: c))));
    allCards.refresh();
  }

  void addCard(CardModel card) {
    allCards.add(card);
    allCards.refresh();
  }
}
