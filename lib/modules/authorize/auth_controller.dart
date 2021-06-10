import 'package:sonr_app/service/client/session.dart';
import 'package:sonr_app/style.dart';

class AuthorizeController extends GetxController {
  // @ Invite Management
  /// Accept a provided Contact Invite
  /// Parameters: `withShare` will send back own Contact
  void acceptContactInvite(AuthInvite invite, {bool withShare = false}) {
    // Save Card
    CardService.addCard(invite.data);

    // Check if Send Back
    if (withShare) {
      SonrService.respond(invite.newAcceptReply());
    }

    // Return to HomeScreen
    Get.back();

    // Present Home Controller
    if (Get.currentRoute != "/transfer") {
      Get.offNamed('/home/received');
    }
  }

  /// Accept a provided Transfer Invite
  void acceptTransferInvite(AuthInvite invite) {
    // Check for Remote
    SonrService.respond(invite.newAcceptReply());

    // Switch View
    Get.back(closeOverlays: true);

    SonrOverlay.show(
      ProgressView(invite.file, invite.file.single.size > 5000000),
      barrierDismissible: false,
      disableAnimation: true,
    );

    if (invite.file.single.size > 5000000) {
      // Handle Card Received
      SessionService.session.status.listen((s) {
        if (s.isCompleted) {
          SonrOverlay.back();
        }
      });
    } else {
      // Handle Animation Completed
      Future.delayed(1600.milliseconds, () {
        SonrOverlay.back();
      });
    }
  }

  /// Decline a provided Contact Invite
  void declineContactInvite(AuthInvite invite) {
    SonrService.respond(invite.newDeclineReply());
    Get.back(closeOverlays: true);
  }

  /// Decline a provided Transfer Invite
  void declineTransferInvite(AuthInvite invite) {
    SonrService.respond(invite.newDeclineReply());
    Get.back(closeOverlays: true);
  }

  // @ Reply Management
  /// Accept a Provided Contact Reply
  void acceptContactReply(AuthReply reply) {}

  /// Decline a Provided Contact Reply
  void declineContactReply(AuthReply reply) {}
}
