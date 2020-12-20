import 'package:get/get.dart';
import 'package:sonar_app/data/card_model.dart';
import 'package:sonar_app/modules/home/home_controller.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonr_core/models/models.dart';
import 'package:sonr_core/sonr_core.dart';

enum CardState { None, Invitation, InProgress, Received, Viewing }

class CardController extends GetxController {
  // Properties
  final state = CardState.None.obs;
  bool accepted = false;
  Metadata receivedFile;

  // ^ Update State to be Invitation ^ //
  CardController() {
    Get.find<SonrService>().status.listen((s) {
      // User Invited
      if (s == SonrStatus.Pending) {
        state(CardState.Invitation);
      }
    });
  }

  // ^ Set File after Transfer^ //
  setFile(Metadata meta) {
    state(CardState.Received);
    receivedFile = meta;
  }

  // ^ Accept File Invite Request ^ //
  acceptFile() {
    state(CardState.InProgress);
    Get.find<SonrService>().respond(true);
    accepted = true;
  }

  // ^ Accept Contact Invite Request ^ //
  CardModel acceptContact(Contact c, bool sb) {
    // Create Contact Card
    var card = CardModel.fromContact(c);
    accepted = true;

    // Add to Cards Display Last Card
    Get.find<HomeController>().addCard(card);

    // Check if Send Back
    if (sb) {
      Get.find<SonrService>().respond(true);
    }

    // Return Card Model
    state(CardState.Viewing);
    return card;
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

  // ^ Save Metadata after Completed Transfer ^ //
  CardModel saveFile(Metadata metadata) {
    // Create Metadata Card
    var card = CardModel.fromMetadata(metadata);

    // Add to Cards Display Last Card
    Get.find<HomeController>().addCard(card);
    return card;
  }
}
