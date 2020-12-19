import 'package:get/get.dart';
import 'package:sonar_app/data/card_model.dart';
import 'package:sonar_app/modules/home/home_controller.dart';
import 'package:sonar_app/service/sql_service.dart';
import 'package:sonr_core/models/models.dart';
import 'package:sonr_core/sonr_core.dart';

class CardController extends GetxController {
  CardModel saveFile(Metadata metadata) {
    // Save Card
    Get.find<SQLService>().saveFile(metadata);

    // Create Metadata Card
    var card = CardModel(id: metadata.id, meta: metadata);

    // Add to Cards Display Last Card
    Get.find<HomeController>().addCard(card);
    return card;
  }

  CardModel saveContact(Contact contact) {
    // Save Card
    Get.find<SQLService>().saveContact(contact);

    // Create Contact Card
    var card = CardModel(contact: contact);

    // Add to Cards Display Last Card
    Get.find<HomeController>().addCard(card);
    return card;
  }
}
