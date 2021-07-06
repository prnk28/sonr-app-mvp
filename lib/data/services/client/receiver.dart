import 'package:sonr_app/data/services/services.dart';
import 'package:sonr_app/modules/activity/views/completed_view.dart';
import 'package:sonr_app/style/style.dart';

class ReceiverService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<ReceiverService>() && DeviceService.hasInternet;
  static ReceiverService get to => Get.find<ReceiverService>();
  static Session get session => to._session;
  static Rx<bool> get hasSession => to._hasActiveSession;

  // Properties
  final _session = Session();
  final _hasActiveSession = false.obs;

  // ^ Constructer ^ //
  Future<ReceiverService> init() async {
    return this;
  }

  /// Peer has Invited User
  void handleInvite(InviteRequest data) {
    // Create Incoming Session
    to._session.incoming(data);

    // Handle Feedback
    Sound.Swipe.play();
    HapticFeedback.heavyImpact();

    // Check for Flat
    if (data.type == InviteRequest_Type.Flat && data.payload == Payload.CONTACT) {
      AppPage.Flat.invite(data.contact);
    } else {
      data.show();
    }
  }

  // * ------------------- Methods ----------------------------
  static void decide(bool decision, {bool sendBackContact = false, bool closeOverlay = false}) {
    if (isRegistered) {
      // Set Active
      to._hasActiveSession(true);

      // # Contact Transfer
      if (to._session.payload.isContact) {
        // Save Contact Card
        if (decision) {
          // Save Card
          CardService.addCard(to._session.transfer.value, ActivityType.Received);

          // Check if Send Back
          if (sendBackContact) {
            if (NodeService.isReady) {
              NodeService.instance.respond(to._session.buildReply(decision: true));
            }
          }

          // Present Home Controller
          AppPage.Home.off(condition: AppRoute.isNotCurrent(AppPage.Transfer), closeCurrent: true);
        }
      }
      // # File Transfer
      else if (to._session.payload.isTransfer) {
        // Prepare for Transfer
        to._hasActiveSession(decision);

        // Check Decision
        if (decision) {
          // Check for Remote
          if (NodeService.isReady) {
            NodeService.instance.respond(to._session.buildReply(decision: true));
          }
          AppRoute.closeSheet();
          AppPage.Activity.to();
        }
        // Send Declined
        else {
          if (NodeService.isReady) {
            NodeService.instance.respond(to._session.buildReply(decision: false));
          }
        }
      }
    }
  }

  // * ------------------- Callbacks ----------------------------
  /// Session Has Updated Progress
  void handleProgress(ProgressEvent data) {
    _session.onProgress(data);

    // Logging
    Logger.info("Node(Callback) Progress: " + data.toString());
  }

  /// User has received file succesfully
  void handleReceived(Transfer data) async {
    // Check for Callback
    _session.onComplete(data);
    Get.back();

    // Save Card to Gallery
    if (data.payload.isTransfer) {
      await data.save();
    }
    await data.addCard();

    // Present Feedback
    await HapticFeedback.heavyImpact();
    await Sound.Received.play();

    // Display Released Card
    Future.delayed(2.seconds, () {
      AppRoute.popup(CompletedPopup(transfer: data));
    });

    // Logging
    Logger.info("Node(Callback) Received: " + data.toString());
    _session.reset();
    _hasActiveSession(false);

    // Update Has Had Transfer
    if (!Logger.to.hasHadTransfer.val) {
      Future.delayed(3.seconds, () {
        Logger.to.hasHadTransfer.val = true;
      });
    }
  }
}
