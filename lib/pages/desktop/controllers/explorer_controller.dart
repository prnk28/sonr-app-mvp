import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sonr_app/style/style.dart';

class ExplorerController extends GetxController {
  // @ Accessors
  Payload get currentPayload => inviteRequest.value.payload;

  // @ Properties
  final isNotEmpty = false.obs;
  final inviteRequest = InviteRequest().obs;
  final fileItem = Rx<SonrFile?>(null);
  final location = Rx<Location>(Location());

  // References
  late StreamSubscription<Lobby?> _lobbySizeStream;
  CarouselController carouselController = CarouselController();

  // ^ Controller Constructer ^
  void onInit() async {
    // Set Initial Value
    _handleLobbySizeUpdate(LobbyService.local.value);
    location(await (SonrService.locationInfo() as FutureOr<Location>));
    location.refresh();

    // Add Stream Handlers
    _lobbySizeStream = LobbyService.local.listen(_handleLobbySizeUpdate);
    super.onInit();
  }

  // ^ On Dispose ^ //
  @override
  void onClose() {
    _lobbySizeStream.cancel();
    super.onClose();
  }

  // # Handle Lobby Size Update ^ //
  _handleLobbySizeUpdate(Lobby? lobby) {
    isNotEmpty(lobby!.isNotEmpty);
  }
}
