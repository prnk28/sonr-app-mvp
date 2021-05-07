import 'dart:async';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/service/device/mobile.dart';
import 'package:sonr_app/style/style.dart';

enum ThumbnailStatus { None, Loading, Complete }

class TransferController extends GetxController {
  // @ Accessors
  Payload get currentPayload => inviteRequest.value.payload;

  // @ Properties
  final title = "Sharing".obs;
  final subtitle = "Nobody Here".obs;
  final payload = Payload.NONE.obs;
  final isFacingPeer = false.obs;
  final isNotEmpty = false.obs;
  final inviteRequest = InviteRequest().obs;
  final sonrFile = SonrFile().obs;
  final thumbStatus = ThumbnailStatus.None.obs;

  // @ Remote Properties
  final counter = 0.obs;
  final remote = Rx<RemoteInfo?>(null);

  // @ Direction Properties
  final angle = 0.0.obs;
  final degrees = 0.0.obs;
  final direction = 0.0.obs;
  final isShiftingEnabled = true.obs;

  // @ View Properties
  final directionTitle = "".obs;
  final cardinalTitle = "".obs;

  // References
  late StreamSubscription<Lobby?> _lobbySizeStream;
  late StreamSubscription<Position> _positionStream;
  ScrollController scrollController = ScrollController();

  // ^ Controller Constructer ^
  void onInit() {
    // Set Initial Value
    _handlePositionUpdate(MobileService.position.value);
    _handleLobbyUpdate(LobbyService.local.value);

    // Add Stream Handlers
    _positionStream = MobileService.position.listen(_handlePositionUpdate);
    _lobbySizeStream = LobbyService.local.listen(_handleLobbyUpdate);
    super.onInit();
  }

  // ^ On Dispose ^ //
  @override
  void onClose() {
    _positionStream.cancel();
    _lobbySizeStream.cancel();
    super.onClose();
  }

  // ^ Send Invite with Peer ^ //
  void invitePeer(Peer peer) {
    setFacingPeer(false);
    isShiftingEnabled(false);

    // Update Request
    inviteRequest.setPeer(peer);

    // Send Invite
    SonrService.invite(inviteRequest.value);
  }

  // ^ Set Transfer Payload ^ //
  void setPayload(TransferArguments args) async {
    // Set Title
    _setTitle(args.payload);

    // Initialize Request
    inviteRequest.init(args);

    // Check for Media
    if (inviteRequest.isMedia) {
      // Set File Item
      sonrFile(args.file!);
      thumbStatus(ThumbnailStatus.Loading);
      await sonrFile.value.setThumbnail();

      // Check Result
      if (sonrFile.value.single.hasThumbnail()) {
        thumbStatus(ThumbnailStatus.Complete);
      } else {
        thumbStatus(ThumbnailStatus.None);
      }
    }
  }

  // ^ User is Facing or No longer Facing a Peer ^ //
  void setFacingPeer(bool value) {
    isFacingPeer(value);
    isFacingPeer.refresh();
  }

  // ^ Toggles Peer Shifting ^ //
  void toggleShifting() {
    isShiftingEnabled(!isShiftingEnabled.value);
  }

  // # Handle Compass Update ^ //
  _handlePositionUpdate(Position pos) {
    // Update String Elements
    if (!isClosed) {
      // Set Titles
      directionTitle(pos.facing.directionString);
      cardinalTitle(pos.facing.cardinalString);

      // Update Properties
      direction(pos.facing.direction);
      angle(pos.facing.angle);
      degrees(pos.facing.degrees);
    }
  }

  // # Handle Lobby Size Update ^ //
  _handleLobbyUpdate(Lobby? data) {
    if (data != null && !isClosed) {
      isNotEmpty(data.isNotEmpty);
      subtitle(data.countString);
    }
  }

  // # Updates Title Value by Payload
  void _setTitle(Payload payload) {
    // Set Payload
    this.payload(payload);

    // Update Title
    switch (payload) {
      case Payload.CONTACT:
        this.title("Sharing Contact Card");
        break;
      case Payload.URL:
        this.title("Sending Link");
        break;
      default:
        if (sonrFile.value.exists) {
          this.title("Sharing " + sonrFile.value.prettyType());
        }
    }
  }
}
