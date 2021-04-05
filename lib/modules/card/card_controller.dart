import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_app/modules/card/progress_view.dart';
import 'package:sonr_core/sonr_core.dart';

export 'contact_view.dart';
export 'file_view.dart';
export 'media_view.dart';
export 'url_view.dart';
export 'progress_view.dart';

enum CardType { None, Invite, InviteFlat, Reply, GridItem, Info }

class TransferCardController extends GetxController {
  // Properties
  final animationCompleted = false.obs;

  // ^ Accept Contact Invite Request ^ //
  acceptContact(AuthInvite invite, TransferCard card, {bool sendBackContact = false, bool closeOverlay = false}) {
    // Save Card
    Get.find<SQLService>().storeCard(card);

    // Check if Send Back
    if (sendBackContact) {
      // Check for Remote
      if (invite.hasRemote()) {
        SonrService.respond(true, info: invite.remote);
      } else {
        SonrService.respond(true);
      }
    }

    // Return to HomeScreen
    Get.back();

    // Present Home Controller
    if (Get.currentRoute != "/transfer") {
      Get.offNamed('/home/received');
    }
  }

  // ^ Accept Transfer Invite Request ^ //
  acceptTransfer(AuthInvite invite, TransferCard card) {
    // Check for Remote
    if (invite.hasRemote()) {
      SonrService.respond(true, info: invite.remote);
    } else {
      SonrService.respond(true);
    }

    // Switch View
    SonrOverlay.back();
    SonrOverlay.show(
      ProgressView(card, card.properties.size > 5000000),
      barrierDismissible: false,
      disableAnimation: true,
    );

    if (card.properties.size > 5000000) {
      // Handle Card Received
      SonrService.completed().then((value) {
        SonrOverlay.back();
        Get.offNamed('/home/received');
      });
    } else {
      // Handle Animation Completed
      Future.delayed(1600.milliseconds, () {
        SonrOverlay.back();
        Get.offNamed('/home/received');
      });
    }
  }

  // ^ Decline Invite Request ^ //
  declineInvite(AuthInvite invite) {
    // Check if accepted
    if (invite.hasRemote()) {
      SonrService.respond(true, info: invite.remote);
    } else {
      SonrService.respond(true);
    }
    SonrService.respond(false);
    SonrOverlay.back();
  }

  // ^ Accept Transfer Invite Request ^ //
  promptSendBack(AuthInvite invite, TransferCard card) async {
    var result = await SonrOverlay.question(title: "Send Back", description: "Would you like to send your contact back?");
    acceptContact(invite, card, sendBackContact: result, closeOverlay: true);
  }

  // ^ Method to Present Card Overlay Info
  showCardInfo(Widget infoWidget) {
    SonrOverlay.show(infoWidget, disableAnimation: true, barrierDismissible: true);
  }
}
