import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sonr_app/modules/card/progress_view.dart';
import 'package:sonr_app/modules/home/home_controller.dart';
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
  final transferCompleted = false.obs;
  final animationCompleted = false.obs;
  final displayProgress = false.obs;

  // ^ Handle Transfer Progress ^
  TransferCardController() {
    // @ Listen for Transfer Complete
    Get.find<SonrService>().received.listen((result) {
      transferCompleted(result);
      if (animationCompleted.value && !result) {
        displayProgress(true);
      } else if (animationCompleted.value && result) {
        Get.find<SonrService>().completed();
        Get.back();
      }
    });

    // @ Listen for Animation Complete
    animationCompleted.listen((result) {
      if (Get.find<SonrService>().received.value && !result) {
        displayProgress(true);
      } else if (Get.find<SonrService>().received.value && result) {
        Get.find<SonrService>().completed();
        Get.back();
      }
    });
  }

  // ^ Accept Contact Invite Request ^ //
  acceptContact(TransferCard card, {bool sendBackContact = false, bool closeOverlay = false}) {
    // Save Card
    Get.find<SQLService>().storeCard(card);

    // Check if Send Back
    if (sendBackContact) {
      Get.find<SonrService>().respond(true);
    }

    // Return to HomeScreen
    Get.back();
    Get.offAllNamed('/home/completed').then((value) {
      Get.find<HomeController>().addCard(card);
    });
  }

  // ^ Accept Transfer Invite Request ^ //
  promptSendBack(TransferCard card) {
    SonrOverlay.question(
        title: "Send Back",
        description: "Would you like to send your contact back?",
        onDecision: (result) {
          acceptContact(card, sendBackContact: result, closeOverlay: true);
        });
  }

  // ^ Accept Transfer Invite Request ^ //
  acceptTransfer(TransferCard card) {
    Get.find<SonrService>().respond(true);
    SonrOverlay.back();
    Get.dialog(ProgressView(this, card), barrierDismissible: false);
  }

  // ^ Decline Invite Request ^ //
  declineInvite() {
    // Check if accepted
    Get.find<SonrService>().respond(false);
    SonrOverlay.back();
  }

  // ^ Method to Present Card Overlay Info
  showCardInfo(Widget infoWidget) {
    SonrOverlay.open(infoWidget);
  }
}
