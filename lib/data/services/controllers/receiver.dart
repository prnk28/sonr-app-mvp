import 'package:sonr_app/modules/authorize/authorize.dart';
import 'package:sonr_app/pages/transfer/transfer.dart';
import 'package:sonr_app/data/services/services.dart';
import 'package:sonr_app/style.dart';

class ReceiverService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<ReceiverService>();
  static ReceiverService get to => Get.find<ReceiverService>();

  // @ Properties
  final Session _session = Session();
  final _hasActiveSession = false.obs;

  /// Global Reactive Accessors
  static Session get session => to._session;
  static Rx<bool> get hasSession => to._hasActiveSession;

  // ^ Constructer ^ //
  Future<ReceiverService> init() async {
    return this;
  }

  /// Peer has Invited User
  void handleInvite(InviteRequest data) {
    // Create Incoming Session
    to._session.incoming(data);

    // Handle Feedback
    DeviceService.playSound(type: UISoundType.Swipe);
    DeviceService.feedback();

    // Check for Flat
    if (data.flatMode && data.payload == Payload.CONTACT) {
      FlatMode.invite(data.contact);
    } else {
      Authorize.invite(data);
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
            SonrService.respond(to._session.buildReply(decision: true));
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
          SonrService.respond(to._session.buildReply(decision: true));
          AppRoute.closeSheet();
          AppPage.Activity.to();
        }
        // Send Declined
        else {
          SonrService.respond(to._session.buildReply(decision: false));
        }
      }
    }
  }

  // * ------------------- Callbacks ----------------------------
  /// Session Has Updated Progress
  void handleProgress(double data) {
    _session.onProgress(data);

    // Logging
    Logger.info("Node(Callback) Progress: " + data.toString());
  }

  /// User has received file succesfully
  void handleReceived(Transfer data) async {
    // Check for Callback
    _session.onComplete(data);

    // Save Card to Gallery
    if (data.payload.isTransfer) {
      // Save File to Disk
      SonrFile file = data.file;
      var result = await DeviceService.saveTransfer(file);
      file = result.copyAssetIds(file);
      await CardService.addFileCard(data, file, ActivityType.Received);
    } else {
      await CardService.addCard(data, ActivityType.Received);
    }

    // Present Feedback
    await HapticFeedback.heavyImpact();
    DeviceService.playSound(type: UISoundType.Received);

    // Logging
    Logger.info("Node(Callback) Received: " + data.toString());
    _session.reset();
  }
}
