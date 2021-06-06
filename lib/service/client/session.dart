import 'package:sonr_app/modules/authorize/auth_sheet.dart';
import 'package:sonr_app/service/device/device.dart';
import 'package:sonr_app/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart' as sonr;
import '../user/cards.dart';

class SessionService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<SessionService>();
  static SessionService get to => Get.find<SessionService>();

  // @ Properties
  final Session _session = Session();

  /// Returns Current Session
  static Session get session => to._session;

  Future<SessionService> init() async {
    return this;
  }

  // * ------------------- Methods ----------------------------
  /// Accept Invite for Current Session
  static void acceptInvite(bool decision, {bool sendBackContact = false, bool closeOverlay = false}) {}

  /// Set Session to Prepare for Outgoing Transfer
  static void setOutgoing(AuthInvite invite) {
    to._session.outgoing(invite);
  }

  // * ------------------- Callbacks ----------------------------
  /// Peer has Invited User
  void handleInvite(AuthInvite data) {
    // Create Incoming Session
    to._session.incoming(data);

    // Handle Feedback
    DeviceService.playSound(type: UISoundType.Swipe);
    DeviceService.feedback();

    // Check for Flat
    if (data.isFlat && data.payload == Payload.CONTACT) {
      FlatMode.invite(data.contact);
    } else {
      Authorize.invite(data);
    }
  }

  /// Peer has Responded
  void handleReply(AuthReply data) async {
    // Logging
    Logger.info("Node(Callback) Responded: " + data.toString());

    // Handle Contact Response
    if (data.type == AuthReply_Type.FlatContact) {
      await HapticFeedback.heavyImpact();
      FlatMode.response(data.data.contact);
    } else if (data.type == AuthReply_Type.Contact) {
      await HapticFeedback.vibrate();
      Authorize.reply(data);
    }

    // For Cancel
    else if (data.type == AuthReply_Type.Cancel) {
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
      await DeviceService.saveTransfer(data.file);
    }

    // Update Database
    if (DeviceService.isMobile) {
      await CardService.addCard(data);
      await CardService.addActivityReceived(
        owner: data.owner,
        payload: data.payload,
        file: data.file,
      );
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
    CardService.addActivityShared(payload: data.payload, file: data.file);

    // Logging
    Logger.info("Node(Callback) Transmitted: " + data.toString());
    _session.reset();
  }
}
