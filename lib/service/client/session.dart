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
  final _hasActiveSession = false.obs;

  /// Returns Current Session
  static Session get session => to._session;
  static Rx<bool> get hasActiveSession => to._hasActiveSession;

  Future<SessionService> init() async {
    return this;
  }

  // * ------------------- Methods ----------------------------
  /// Accept Invite for Current Session
  static void setInviteDecision(bool decision, {bool sendBackContact = false, bool closeOverlay = false}) {
    if (isRegistered) {
      // Set Active
      to._hasActiveSession(true);

      // Handle Payload
      if (to._session.payload == Payload.CONTACT) {
        to._handleAcceptContact(sendBackContact);
      } else {
        decision ? to._handleAcceptTransfer() : to._handleDeclineTransfer();
      }
    }
  }

  /// Set Session to Prepare for Outgoing Transfer
  static void setOutgoing(InviteRequest invite) {
    to._session.outgoing(invite);
  }

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
    if (data.isFlat && data.payload == Payload.CONTACT) {
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
    if (data.type == InviteResponse_Type.FlatContact) {
      await HapticFeedback.heavyImpact();
      FlatMode.response(data.data.contact);
    } else if (data.type == InviteResponse_Type.Contact) {
      await HapticFeedback.vibrate();
      Authorize.reply(data);
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
      _addFileCard(data, file);
    } else {
      _addCard(data);
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

  // @ Helper Methods:
  // Add Contact/URL card to Database
  void _addCard(Transfer data) async {
    // Update Database
    if (DeviceService.isMobile) {
      await CardService.addCard(data);
      await CardService.addActivityReceived(
        owner: data.owner,
        payload: data.payload,
        file: data.file,
      );
    }
  }

  // Add File card to Database
  void _addFileCard(Transfer data, SonrFile file) async {
    // Update Database
    if (DeviceService.isMobile) {
      await CardService.addFileCard(data, file);
      await CardService.addActivityReceived(
        owner: data.owner,
        payload: data.payload,
        file: data.file,
      );
    }
  }

  // @ Handle Accept Transfer Response
  _handleAcceptTransfer() {
    // Check for Remote
    SonrService.respond(to._session.buildReply(decision: true));

    // Switch View
    SonrOverlay.back();
    SonrOverlay.show(
      ProgressView(to._session, to._session.totalSize > 5000000),
      barrierDismissible: false,
      disableAnimation: true,
    );

    // if (invite.file.single.size > 5000000) {
    // Handle Card Received
    SessionService.session.status.listen((s) {
      if (s.isCompleted) {
        SonrOverlay.back();
      }
    });
    // } else {
    // Handle Animation Completed
    Future.delayed(1600.milliseconds, () {
      SonrOverlay.back();
    });
    // }
  }

// @ Handle Decline Transfer Response
  _handleDeclineTransfer() {
    SonrService.respond(to._session.buildReply(decision: false));
    SonrOverlay.back();
  }

// @ Handle Accept Contact Response
  _handleAcceptContact(bool sendBackContact) {
    // Save Card
    CardService.addCard(to._session.transfer.value);

    // Check if Send Back
    if (sendBackContact) {
      SonrService.respond(to._session.buildReply(decision: true));
    }

    // Return to HomeScreen
    Get.back();

    // Present Home Controller
    if (Get.currentRoute != "/transfer") {
      Get.offNamed('/home');
    }
  }
}
