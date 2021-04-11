import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:sonr_app/theme/theme.dart';
import 'share.dart';

const String _tilePath = 'assets/rive/tile_preview.riv';

// ^ Camera Share Button ^ //
class ShareCameraButtonItem extends GetView<ShareController> {
  const ShareCameraButtonItem();
  @override
  Widget build(BuildContext context) {
    // Load Artboard
    final galleryArtboard = Rx<Artboard>(null);
    _loadArtboard(galleryArtboard);

    return GestureDetector(
      onTap: controller.onCameraShare,
      child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
        ObxValue<Rx<Artboard>>(
            (rive) => SizedBox(
                height: 55,
                width: 55,
                child: Center(
                    child: rive.value == null
                        ? Container()
                        : Rive(
                            artboard: rive.value,
                          ))),
            galleryArtboard),
        Padding(padding: EdgeInsets.only(top: 4)),
        SonrText('Camera', weight: FontWeight.w500, size: 14, key: key, color: SonrColor.White),
      ]),
    );
  }

  // @ Loads Artboard into ObxValue
  _loadArtboard(Rx<Artboard> rxArtboard) async {
    rootBundle.load(_tilePath).then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);
        // Retreive Artboard
        final artboard = file.mainArtboard;

        // Retreive Camera
        artboard.addController(SimpleAnimation('Camera'));
        rxArtboard(artboard);
      },
    );
  }
}

// ^ Gallery Share Button ^ //
class ShareGalleryButtonItem extends GetView<ShareController> {
  const ShareGalleryButtonItem();
  @override
  Widget build(BuildContext context) {
    // Load Artboard
    final galleryArtboard = Rx<Artboard>(null);
    _loadArtboard(galleryArtboard);

    // Return View
    return GestureDetector(
      onTap: () {
        controller.status(ShareStatus.PickMedia);
        controller.status.refresh();
      },
      child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
        ObxValue<Rx<Artboard>>(
            (rive) => SizedBox(
                height: 55,
                width: 55,
                child: Center(
                    child: rive.value == null
                        ? Container()
                        : Rive(
                            artboard: rive.value,
                          ))),
            galleryArtboard),
        Padding(padding: EdgeInsets.only(top: 4)),
        SonrText('Gallery', weight: FontWeight.w500, size: 14, key: key, color: SonrColor.White),
      ]),
    );
  }

// @ Loads Artboard into ObxValue
  _loadArtboard(Rx<Artboard> rxArtboard) async {
    rootBundle.load(_tilePath).then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);
        // Retreive Artboard
        final artboard = file.mainArtboard;

        // Retreive Camera
        artboard.addController(SimpleAnimation('Showcase'));
        rxArtboard(artboard);
      },
    );
  }
}

// ^ Contact Share Button ^ //
class ShareContactButtonItem extends GetView<ShareController> {
  const ShareContactButtonItem();
  @override
  Widget build(BuildContext context) {
    // Load Artboard
    final galleryArtboard = Rx<Artboard>(null);
    _loadArtboard(galleryArtboard);

    return GestureDetector(
      onTap: () {
        SonrService.queueContact();

        // Go to Transfer
        Get.toNamed("/transfer");
        controller.shrink(delay: 150.milliseconds);
      },
      child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
        ObxValue<Rx<Artboard>>(
            (rive) => SizedBox(
                height: 55,
                width: 55,
                child: Center(
                    child: rive.value == null
                        ? Container()
                        : Rive(
                            artboard: rive.value,
                          ))),
            galleryArtboard),
        Padding(padding: EdgeInsets.only(top: 4)),
        SonrText('Contact', weight: FontWeight.w500, size: 14, key: key, color: SonrColor.White),
      ]),
    );
  }

// @ Loads Artboard into ObxValue
  _loadArtboard(Rx<Artboard> rxArtboard) async {
    rootBundle.load(_tilePath).then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);
        // Retreive Artboard
        final artboard = file.mainArtboard;

        // Retreive Camera
        artboard.addController(SimpleAnimation('Icon'));
        rxArtboard(artboard);
      },
    );
  }
}
