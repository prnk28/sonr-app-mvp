import 'package:sonr_app/data/database/service.dart';
import 'package:sonr_app/modules/activity/activity_controller.dart';
import 'package:sonr_app/modules/authorize/auth_sheet.dart';
import 'package:sonr_app/service/device/device.dart';
import 'package:sonr_app/style.dart';

class SessionService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<SessionService>();
  static SessionService get to => Get.find<SessionService>();

  // @ Properties
  final Session _session = Session();
  final _hasActiveSession = false.obs;

  /// Returns Current Session
  static Session get session => to._session;
  static Rx<bool> get hasActiveSession => to._hasActiveSession;

  Future<SessionService> init() async {
    return this;
  }

  // * ------------------- Methods ----------------------------
  /// Decision for Invite on Current Session
  static void decisionForInvite(bool decision, {bool sendBackContact = false, bool closeOverlay = false}) {
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
        if (decision) {
          // Check for Remote
          SonrService.respond(to._session.buildReply(decision: true));
          AppRoute.closeSheet();
          AppPage.Activity.to(init: ActivityController.initSession);
        }
        // Send Declined
        else {
          SonrService.respond(to._session.buildReply(decision: false));
        }
      }
    }
  }

  /// Set Session to Prepare for Outgoing Transfer
  static void setOutgoing(InviteRequest invite) {
    to._session.outgoing(invite);
  }

  /// Resets the current Session
  static void reset() {
    to._session.reset();
  }

  // * ------------------- Callbacks ----------------------------
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

  /// Peer has Responded
  void handleReply(InviteResponse data) async {
    // Logging
    Logger.info("Node(Callback) Responded: " + data.toString());

    // Handle Contact Response
    if (data.type == InviteResponse_Type.Contact) {
      await HapticFeedback.heavyImpact();

      // Check if Flat Mode
      data.flatMode ? FlatMode.response(data.transfer.contact) : Authorize.reply(data);
    }

    // For Cancel
    else if (data.type == InviteResponse_Type.Cancel) {
      await HapticFeedback.vibrate();
    } else {
      _session.onReply(data);
    }
  }

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

  /// User has shared file succesfully
  void handleTransmitted(Transfer data) async {
    // Check for Callback
    _session.onComplete(data);
    TransferService.resetPayload();

    // Feedback
    DeviceService.playSound(type: UISoundType.Transmitted);
    await HapticFeedback.heavyImpact();

    // Logging Activity
    CardService.addActivity(
      payload: data.payload,
      file: data.file,
      type: ActivityType.Shared,
    );

    // Logging
    Logger.info("Node(Callback) Transmitted: " + data.toString());
    _session.reset();
  }
}
