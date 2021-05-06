import 'dart:async';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/service/device/mobile.dart';
import 'package:sonr_app/style/style.dart';

enum ThumbnailStatus { None, Loading, Complete }

class TransferController extends GetxController {
  // @ Accessors
  Payload get currentPayload => inviteRequest.value.payload;

  // @ Properties
  final title = "Nobody Here".obs;
  final isFacingPeer = false.obs;
  final isNotEmpty = false.obs;
  final inviteRequest = InviteRequest().obs;
  final sonrFile = Rx<SonrFile?>(null);
  final thumbStatus = Rx<ThumbnailStatus>(ThumbnailStatus.None);

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
  CarouselController carouselController = CarouselController();

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
  void invitePeer(Peer? peer) {
    setFacingPeer(false);
    isShiftingEnabled(false);

    // Update Request
    inviteRequest.update((val) {
      val!.to = peer!;
    });

    // Send Invite
    SonrService.invite(inviteRequest.value);
  }

  // ^ Set Transfer Payload ^ //
  void setPayload(TransferArguments args) {
    // Contact
    if (args.payload == Payload.CONTACT) {
      inviteRequest.update((val) {
        val!.payload = args.payload;
        val.contact = args.contact!;
        val.payload = Payload.CONTACT;
      });
    }
    // URL
    else if (args.payload == Payload.URL) {
      inviteRequest.update((val) {
        val!.payload = args.payload;
        val.url = args.url!;
        val.payload = Payload.URL;
      });
    }
    // Media
    else if (args.payload == Payload.MEDIA) {
      _setMediaPayload(args.file);
    }
    // File
    else {
      // Set File Item
      sonrFile(args.file);
      inviteRequest.update((val) {
        val!.file = args.file!;
        val.payload = args.payload;
      });
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
      title(data.countString);
    }
  }

  // # Loads SonrFile for Media Payload
  _setMediaPayload(SonrFile? file) async {
    // Update Request
    inviteRequest.update((val) {
      val!.file = file!;
      val.payload = Payload.MEDIA;
    });

    // Set File Item
    sonrFile(file);
    thumbStatus(ThumbnailStatus.Loading);
    await sonrFile.value!.setThumbnail();

    // Check Result
    if (sonrFile.value!.single.hasThumbnail()) {
      thumbStatus(ThumbnailStatus.Complete);
    } else {
      thumbStatus(ThumbnailStatus.None);
    }
  }
}
