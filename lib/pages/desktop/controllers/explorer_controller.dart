import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/theme/theme.dart';

class ExplorerController extends GetxController {
  // @ Accessors
  Payload get currentPayload => inviteRequest.value.payload;

  // @ Properties
  final isNotEmpty = false.obs;
  final inviteRequest = InviteRequest().obs;
  final fileItem = Rx<FileItem>(null);
  final location = Rx<Location>(Location());

  // References
  StreamSubscription<int> _lobbySizeStream;
  CarouselController carouselController = CarouselController();

  // ^ Controller Constructer ^
  void onInit() async {
    // Set Initial Value
    _handleLobbySizeUpdate(LobbyService.localSize.value);
    location(await SonrService.locationInfo());
    location.refresh();

    // Add Stream Handlers
    _lobbySizeStream = LobbyService.localSize.listen(_handleLobbySizeUpdate);
    super.onInit();
  }

  // ^ On Dispose ^ //
  @override
  void onClose() {
    _lobbySizeStream.cancel();
    super.onClose();
  }

  // # Handle Lobby Size Update ^ //
  _handleLobbySizeUpdate(int size) {
    if (size == 0) {
      isNotEmpty(false);
    } else if (size == 1) {
      isNotEmpty(true);
    } else {
      isNotEmpty(true);
    }
  }
}
