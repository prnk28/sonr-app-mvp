import 'dart:async';
import 'dart:math';
import 'package:sonr_app/theme/theme.dart';

class TransferController extends GetxController {
  // @ Properties
  final title = "Nobody Here".obs;
  final isBirdsEye = false.obs;
  final isFacingPeer = false.obs;

  // @ Remote Properties
  final isRemoteActive = false.obs;
  final counter = 0.obs;
  final remote = Rx<RemoteInfo>();

  // @ Direction Properties
  final angle = 0.0.obs;
  final degrees = 0.0.obs;
  final direction = 0.0.obs;
  final isShiftingEnabled = true.obs;

  // @ View Properties
  final string = "".obs;
  final heading = "".obs;

  // References
  StreamSubscription<CompassEvent> compassStream;
  StreamSubscription<int> lobbySizeStream;
  Timer _timer;

  // ^ Controller Constructer ^
  void onInit() {
    // Set Initial Value
    _handleCompassUpdate(DeviceService.compass.value);
    _handleLobbySizeUpdate(LobbyService.localSize.value);

    // Add Stream Handlers
    compassStream = DeviceService.compass.listen(_handleCompassUpdate);
    lobbySizeStream = LobbyService.localSize.listen(_handleLobbySizeUpdate);
    super.onInit();
  }

  // ^ On Dispose ^ //
  @override
  void onClose() {
    compassStream.cancel();
    lobbySizeStream.cancel();
    super.onClose();
  }

  // ^ Toggle Remote Value ^ //
  void startRemote() async {
    // Start Remote
    remote(await SonrService.createRemote());
    isRemoteActive(true);

    // Set Title
    title(remote.value.display);
    title.refresh();

    // Create Timeout
    _timer = Timer.periodic(1.seconds, (_) {
      // Add to Counter
      counter(counter.value += 1);

      // Check if Timeout Reached
      if (counter.value == 300) {
        if (isRemoteActive.value) {
          _timer.cancel();
          _timer = null;
          HapticFeedback.mediumImpact();
          counter(0);
          isRemoteActive(false);
          _handleLobbySizeUpdate(LobbyService.localSize.value);
        }
      }
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

  void toggleShifting(){
    isShiftingEnabled(!isShiftingEnabled.value);

    if(isShiftingEnabled.value){

    }
  }

  // ^ Handle Compass Update ^ //
  _handleCompassUpdate(CompassEvent newDir) {
    // Update String Elements
    if (newDir != null && !isClosed) {
      string(newDir.headingForCameraMode.direction);
      heading(newDir.headingForCameraMode.heading);

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

  // ^ Handle Lobby Size Update ^ //
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
}
