import 'dart:async';
import 'dart:math';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/modules/common/peer/bubble_view.dart';
import 'package:sonr_app/theme/theme.dart';

class TransferController extends GetxController {
  // @ Accessors
  Payload get currentPayload => inviteRequest.value.payload;

  // @ Properties
  final title = "Nobody Here".obs;
  final isBirdsEye = false.obs;
  final isFacingPeer = false.obs;
  final inviteRequest = InviteRequest().obs;

  // @ Remote Properties
  final isRemoteActive = false.obs;
  final counter = 0.obs;
  final remote = Rx<RemoteInfo>(null);

  // @ Direction Properties
  final angle = 0.0.obs;
  final degrees = 0.0.obs;
  final direction = 0.0.obs;
  final isShiftingEnabled = true.obs;

  // @ View Properties
  final directionTitle = "".obs;
  final cardinalTitle = "".obs;

  // References
  StreamSubscription<CompassEvent> compassStream;
  StreamSubscription<int> lobbySizeStream;
  BubbleController currentPeerController;

  // ^ Controller Constructer ^
  void onInit() {
    // Set Initial Value
    _handleCompassUpdate(DeviceService.compass.value);
    _handleLobbySizeUpdate(LobbyService.localSize.value);

    // Add Stream Handlers
    compassStream = DeviceService.compass.listen(_handleCompassUpdate);
    lobbySizeStream = LobbyService.localSize.listen(_handleLobbySizeUpdate);
    Get.find<SonrService>().registerTransferUpdates(_handleTransferStatus);
    super.onInit();
  }

  // ^ On Dispose ^ //
  @override
  void onClose() {
    compassStream.cancel();
    lobbySizeStream.cancel();
    super.onClose();
  }

  // ^ Send Invite to Peer ^ //
  void invite({Peer peer, BubbleController bubbleController}) {
    // Set Controller
    if (bubbleController != null) {
      currentPeerController = bubbleController;
    }

    // Update Request
    inviteRequest.update((val) {
      val.to = bubbleController != null ? bubbleController.peer.value : peer;
    });

    // Send Invite
    SonrService.invite(inviteRequest.value);
    setFacingPeer(false);
  }

  // ^ Set Transfer Payload ^ //
  void setPayload(dynamic args) {
    // Validate Args
    if (args is TransferArguments) {
      // Contact
      if (args.payload == Payload.CONTACT) {
        inviteRequest.update((val) {
          val.payload = args.payload;
          val.contact = args.contact;
          val.type = InviteRequest_TransferType.Contact;
        });
      }
      // URL
      else if (args.payload == Payload.URL) {
        inviteRequest.update((val) {
          val.payload = args.payload;
          val.url = args.url;
          val.type = InviteRequest_TransferType.URL;
        });
      }
      // File
      else {
        inviteRequest.update((val) {
          val.payload = args.payload;
          val.files.add(args.metadata);
          val.type = InviteRequest_TransferType.File;
        });
      }
    } else {
      print("Invalid Arguments Provided for Transfer");
    }
  }

  // ^ Start Remote Session ^ //
  void startRemote() async {
    // Start Remote
    remote(await SonrService.createRemote());
    isRemoteActive(true);

    // Update Invite Request
    inviteRequest.update((val) {
      val.remote = remote.value;
      val.isRemote = true;
    });
  }

  // ^ Stop Remote Session ^ //
  void stopRemote() async {
    // Start Remote
    SonrService.leaveRemote(remote.value);
    remote(RemoteInfo());
    isRemoteActive(false);

    // Clear Remote from Invite Request
    inviteRequest.update((val) {
      val.remote.clear();
      val.isRemote = false;
    });
  }

  // ^ User is Facing or No longer Facing a Peer ^ //
  void setFacingPeer(bool value) {
    isFacingPeer(value);
    isFacingPeer.refresh();
  }

  // ^ Switch Transfer Views ^ //
  void toggleBirdsEye() {
    if (!isRemoteActive.value) {
      isBirdsEye(!isBirdsEye.value);
      print("isBirdsEye ${isBirdsEye.value}");
      isBirdsEye.refresh();
    }
  }

  // ^ Toggles Peer Shifting ^ //
  void toggleShifting() {
    isShiftingEnabled(!isShiftingEnabled.value);
  }

  // # Handle Compass Update ^ //
  _handleCompassUpdate(CompassEvent newDir) {
    // Update String Elements
    if (newDir != null && !isClosed) {
      directionTitle(_stringForDirection(newDir.headingForCameraMode));
      cardinalTitle(_cardinalStringForDirection(newDir.headingForCameraMode));

      // Reference
      direction(newDir.headingForCameraMode);
      angle(((newDir.headingForCameraMode ?? 0) * (pi / 180) * -1));

      // Calculate Degrees
      if (newDir.headingForCameraMode + 90 > 360) {
        degrees(newDir.headingForCameraMode - 270);
      } else {
        degrees(newDir.headingForCameraMode + 90);
      }
    }
  }

  // # Handle Lobby Size Update ^ //
  _handleLobbySizeUpdate(int size) {
    if (!isRemoteActive.value) {
      if (size == 0) {
        title("Nobody Here");
      } else if (size == 1) {
        title("1 Person");
      } else {
        title("$size People");
      }
    }
  }

  // # Handle Peer Response ^ //
  _handleTransferStatus(TransferStatus data) {
    if (currentPeerController != null) {
      // Check Decision
      if (data == TransferStatus.Accepted) {
        currentPeerController.updateStatus(BubbleStatus.Accepted);
      } else if (data == TransferStatus.Denied) {
        currentPeerController.updateStatus(BubbleStatus.Declined);
      } else {
        currentPeerController.updateStatus(BubbleStatus.Complete);
        inviteRequest.value.clear();
      }
    }
  }

  // # Return String Value for Direction ^ //
  _stringForDirection(double dir) {
    // Calculated
    var adjustedDegrees = dir.round();
    final unit = "°";

    // @ Convert To String
    if (adjustedDegrees >= 0 && adjustedDegrees <= 9) {
      return "0" + "0" + adjustedDegrees.toString() + unit;
    } else if (adjustedDegrees > 9 && adjustedDegrees <= 99) {
      return "0" + adjustedDegrees.toString() + unit;
    } else {
      return adjustedDegrees.toString() + unit;
    }
  }

  // # Return Cardinal Value for Direction ^ //
  _cardinalStringForDirection(double dir) {
    var adjustedDesignation = ((dir.round() / 11.25) + 0.25).toInt();
    var compassEnum = Position_Designation.values[(adjustedDesignation % 32)];
    return compassEnum.toString().substring(compassEnum.toString().indexOf('.') + 1);
  }
}
