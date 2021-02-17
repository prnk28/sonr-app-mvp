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
  final Rx<TransferCard> receivedCard = Get.find<SonrService>().received;
  final animationCompleted = false.obs;
  final displayProgress = false.obs;

  // ^ Handle Transfer Progress ^
  TransferCardController() {
    // @ Listen for Animation Complete
    animationCompleted.listen((result) {
      // Transfer NOT Completed, Animation Completed
      if (receivedCard.value == null && result) {
        displayProgress(true);
      } else if (receivedCard.value != null && result) {
        Get.find<SonrService>().completed(receivedCard.value);
        Get.back();
      }
    });

    // @ Listen for Animation Complete
    receivedCard.listen((result) {
      // Transfer Completed, Animation Completed
      if (animationCompleted.value && result != null) {
        Get.find<SonrService>().completed(result);
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
  promptSendBack(TransferCard card) async {
    var result = await SonrOverlay.question(title: "Send Back", description: "Would you like to send your contact back?");
    acceptContact(card, sendBackContact: result, closeOverlay: true);
  }

  // ^ Accept Transfer Invite Request ^ //
  acceptTransfer(TransferCard card) {
    Get.find<SonrService>().respond(true);
    SonrOverlay.back();

    // Get Estimated Duration - Size in Bytes / 5mb in Bytes
    var averageBytes = card.properties.size / 5000000;
    Duration duration;

    // Set Duration for Animation
    if (averageBytes < 1) {
      duration = Duration(milliseconds: 1400);
    } else {
      var time = averageBytes * 1000 + 400;
      duration = Duration(milliseconds: time.round());
    }

    Get.dialog(ProgressView(this, card, duration: duration), barrierDismissible: false);
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
