import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sonar_app/data/card_model.dart';
import 'package:sonar_app/modules/home/home_controller.dart';
import 'package:sonar_app/service/sonr_service.dart';
import 'package:sonar_app/service/sql_service.dart';
import 'package:sonr_core/models/models.dart';
import 'package:sonr_core/sonr_core.dart';

enum CardState { None, Invitation, InProgress, Viewing }

class CardController extends GetxController {
  // Properties
  final Rx<CardState> state = CardState.None.obs;
  final RxDouble progress = Get.find<SonrService>().progress;

  // References
  AuthInvite _invite;
  Payload_Type _payload;

  setInvited(AuthInvite invite) {
    _invite = invite;
    _payload = invite.payload.type;
  }

  // ^ Accept Invite Request ^ //
  acceptCard() {
    state(CardState.InProgress);
    Get.find<SonrService>().respond(true);
  }

  // ^ Decline Invite Request ^ //
  declineCard() {
    state(CardState.None);
    Get.find<SonrService>().respond(false);
    Get.back();
  }

  // ^ Save Metadata after Completed Transfer ^ //
  CardModel saveFile(Metadata metadata) {
    // Save Card
    Get.find<SQLService>().saveFile(metadata);

    // Create Metadata Card
    var card = CardModel(id: metadata.id, meta: metadata);

    // Add to Cards Display Last Card
    Get.find<HomeController>().addCard(card);
    return card;
  }

  // ^ Save Contact after Completed Transfer ^ //
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
