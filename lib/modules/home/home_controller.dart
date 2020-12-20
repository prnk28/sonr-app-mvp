import 'package:get/get.dart';
import 'package:sonar_app/data/card_model.dart';
import 'package:sonar_app/modules/card/card_controller.dart';
import 'package:sonar_app/service/sql_service.dart';

class HomeController extends GetxController {
  // Properties
  RxList<CardModel> allCards = Get.find<CardController>().allCards;

  void fetch() async {
    // Fetch File Data
    Get.find<SQLService>().fetchFiles().then(
        (data) => data.forEach((m) => allCards.add(CardModel.fromMetaSQL(m))));

    // Fetch Contact Data
    Get.find<SQLService>().fetchContacts().then((data) =>
        data.forEach((c) => allCards.add(CardModel.fromContactSQL(c))));
    allCards.refresh();
  }

  void openCard(CardModel card) {}
}
