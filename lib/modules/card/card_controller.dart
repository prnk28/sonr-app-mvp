import 'package:get/get.dart';
import 'package:sonar_app/data/model_card.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonr_core/models/models.dart';
import 'package:sonr_core/sonr_core.dart';

enum CardState { None, Invitation, InProgress, Received, Viewing }

class CardController extends GetxController {
  // Properties
  final state = CardState.None.obs;
  bool accepted = false;
  Metadata receivedFile;
  RxList<CardModel> allCards = List<CardModel>().obs;

  // ^ Update State to be Invitation ^ //
  setInvited() {
    state(CardState.Invitation);
  }

  // ^ Accept File Invite Request ^ //
  acceptFile() {
    state(CardState.InProgress);
    Get.find<SonrService>().respond(true);
    accepted = true;
  }

  // ^ Accept Contact Invite Request ^ //
  acceptContact(Contact c, bool sb) {
    // Check if Send Back
    if (sb) {
      Get.find<SonrService>().respond(true);
    }

    // Save Contact
    Get.find<SonrService>().saveContact(c);

    // Create Contact Card
    var card = CardModel.fromContact(c);
    accepted = true;

    // Add to Cards Display Last Card
    allCards.add(card);
    allCards.refresh();
  }

  // ^ Decline Invite Request ^ //
  declineInvite() {
    // Check if accepted
    if (!accepted) {
      Get.find<SonrService>().respond(false);
    }

    Get.back();
    state(CardState.None);
  }

  // ^ Set File after Transfer^ //
  received(Metadata meta) {
    state(CardState.Received);
    receivedFile = meta;

    // Create Metadata Card
    var card = CardModel.fromMetadata(meta);

    // Add to Cards Display Last Card
    allCards.add(card);
    allCards.refresh();
  }
}
