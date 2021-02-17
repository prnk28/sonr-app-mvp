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
  final state = CardType.None.obs;
  final transferCompleted = false.obs;
  final animationCompleted = false.obs;
  final displayProgress = false.obs;

  // References
  int index;
  TransferCard card;

  // ^ Handle Transfer Progress ^
  TransferCardController() {
    // @ Listen for Transfer Complete
    Get.find<SonrService>().received.listen((result) {
      transferCompleted(result);
      if (animationCompleted.value && !result) {
        displayProgress(true);
      } else if (animationCompleted.value && result) {
        Get.find<SonrService>().completed();
        Get.back(closeOverlays: true);
      }
    });

    // @ Listen for Animation Complete
    animationCompleted.listen((result) {
      if (Get.find<SonrService>().received.value && !result) {
        displayProgress(true);
      } else if (Get.find<SonrService>().received.value && result) {
        Get.find<SonrService>().completed();
        Get.back(closeOverlays: true);
      }
    });
  }

  // ^ Sets TransferCard Data for this Widget ^
  initialize(TransferCard card, int index) {
    this.card = card;
    this.index = index;
  }

  // ^ Sets Card for Invited Data for this Widget ^
  invited() {
    state(CardType.Invite);
  }

  // ^ Accept Contact Invite Request ^ //
  acceptTransfer(TransferCard card, {bool sendBackContact = false}) {
    // @ Contact Card Accepted
    if (card.payload == Payload.CONTACT) {
      // Check if Send Back
      if (sendBackContact) {
        Get.find<SonrService>().respond(true);
      }

      // Save Card
      Get.find<SQLService>().storeCard(card);

      // Return to HomeScreen
      Get.offAndToNamed('/home/completed').then((value) {
        Get.find<HomeController>().addCard(card);
      });
    }
    // @ File Transfer Accepted
    else {
      Get.find<SonrService>().respond(true);
      Get.back();
      Get.dialog(ProgressView(this, card), barrierDismissible: false);
    }
  }

  // ^ Decline Invite Request ^ //
  declineInvite() {
    // Check if accepted
    Get.find<SonrService>().respond(false);
    Get.back();
    state(CardType.None);
  }

  // ^ Method to Present Card Overlay Info
  showCardInfo(BuildContext context, Widget infoWidget) {
    SonrOverlay(overlayWidget: infoWidget, context: context);
  }
}
