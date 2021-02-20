import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sonr_app/modules/card/progress_view.dart';
import 'package:sonr_app/service/sonr_service.dart';
import 'package:sonr_app/service/sql_service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_app/widgets/overlay.dart';
import 'package:sonr_core/sonr_core.dart';

export 'contact_view.dart';
export 'file_view.dart';
export 'media_view.dart';
export 'url_view.dart';
export 'progress_view.dart';

enum CardType { None, Invite, Reply, GridItem, Info }

class TransferCardController extends GetxController {
  // Properties
  final animationCompleted = false.obs;

  // ^ Handle Transfer Progress ^
  TransferCardController() {
    // @ Listen for Animation Complete
    animationCompleted.listen((result) {
      // Present Home Controller
      Get.back();
      Get.offNamed('/home');
    });
  }

  // ^ Accept Contact Invite Request ^ //
  acceptContact(TransferCard card, {bool sendBackContact = false, bool closeOverlay = false}) {
    // Save Card
    Get.find<SQLService>().storeCard(card);

    // Check if Send Back
    if (sendBackContact) {
      SonrService.respond(true);
    }

    // Return to HomeScreen
    Get.back();

    // Present Home Controller
    if (Get.currentRoute != "/transfer") {
      Get.offNamed('/home');
    }
  }

  // ^ Accept Transfer Invite Request ^ //
  promptSendBack(TransferCard card) async {
    var result = await SonrOverlay.question(title: "Send Back", description: "Would you like to send your contact back?");
    acceptContact(card, sendBackContact: result, closeOverlay: true);
  }

  // ^ Accept Transfer Invite Request ^ //
  acceptTransfer(TransferCard card) {
    SonrService.respond(true);
    SonrOverlay.back();

    Get.dialog(ProgressView(this, card, card.properties.size > 5000000), barrierDismissible: false);
  }

  // ^ Decline Invite Request ^ //
  declineInvite() {
    // Check if accepted
    SonrService.respond(false);
    SonrOverlay.back();
  }

  // ^ Method to Present Card Overlay Info
  showCardInfo(Widget infoWidget) {
    SonrOverlay.show(infoWidget);
  }
}
