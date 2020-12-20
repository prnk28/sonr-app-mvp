import 'package:get/get.dart';
import 'package:sonar_app/data/card_model.dart';
import 'package:sonar_app/modules/home/home_controller.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonar_app/service/sql_service.dart';
import 'package:sonr_core/models/models.dart';
import 'package:sonr_core/sonr_core.dart';

enum CardState { None, Invitation, InProgress, Received, Viewing }

class CardController extends GetxController {
  // Properties
  final state = CardState.None.obs;
  CardState _prevState = CardState.None;

  // ^ Update State to be Invitation ^ //
  CardController() {
    Get.find<SonrService>().status.listen((s) {
      // User Invited
      if (s == SonrStatus.Pending) {
        _prevState = state.value;
        state(CardState.Invitation);
      }

      // User Completed Transfer
      else if (s == SonrStatus.Ready && _prevState == CardState.InProgress) {
        _prevState = state.value;
        state(CardState.Received);
      }
    });
  }

  // ^ Accept File Invite Request ^ //
  acceptFile() {
    state(CardState.InProgress);
    Get.find<SonrService>().respond(true);
  }

  // ^ Accept Contact Invite Request ^ //
  CardModel acceptContact(Contact c, bool sb) {
    // Save Card
    Get.find<SQLService>().saveContact(c);

    // Create Contact Card
    var card = CardModel.fromContact(c);

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
    Get.find<SonrService>().respond(false);
    Get.back();
    state(CardState.None);
  }

  // ^ Save Metadata after Completed Transfer ^ //
  CardModel saveFile(Metadata metadata) {
    // Save Card
    Get.find<SQLService>().saveFile(metadata);

    // Create Metadata Card
    var card = CardModel.fromMetadata(metadata);

    // Add to Cards Display Last Card
    Get.find<HomeController>().addCard(card);
    return card;
  }
}
