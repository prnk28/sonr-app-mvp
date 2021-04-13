import 'package:get/get.dart';
import 'package:rive/rive.dart';
import 'package:sonr_app/theme/theme.dart';
import 'share.dart';

const String _tilePath = 'assets/rive/tile_preview.riv';
const String _documentsPath = 'assets/rive/documents.riv';

// ^ Camera Share Button ^ //
class ShareCameraButtonItem extends GetView<ShareController> {
  const ShareCameraButtonItem();
  @override
  Widget build(BuildContext context) {
    // Load Artboard
    final galleryArtboard = Rx<Artboard>(null);
    _loadArtboard(galleryArtboard);

    return GestureDetector(
      onTap: () async {
        // Check for Permissions
        if (controller.cameraPermitted.value) {
          controller.presentCameraView();
        }

        // Request Permissions
        else {
          var result = await Get.find<UserService>().requestCamera();
          result ? controller.presentCameraView() : SonrSnack.error("Sonr cannot open Camera without Permissions");
        }
      },
      child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
        ObxValue<Rx<Artboard>>(
            (rive) => SizedBox(
                height: 55,
                width: 55,
                child: Center(
                    child: rive.value == null
                        ? SonrIcon.gradient(Icons.camera_alt_outlined, FlutterGradientNames.supremeSky, size: 55)
                        : Rive(
                            artboard: rive.value,
                          ))),
            galleryArtboard),
        Padding(padding: EdgeInsets.only(top: 4)),
        'Camera'.p_White,
      ]),
    );
  }

  // @ Loads Artboard into ObxValue
  _loadArtboard(Rx<Artboard> rxArtboard) async {
    await rootBundle.load(_tilePath).then(
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
      onTap: controller.selectMedia,
      child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
        ObxValue<Rx<Artboard>>(
            (rive) => SizedBox(
                height: 55,
                width: 55,
                child: Center(
                    child: rive.value == null
                        ? SonrIcon.gradient(Icons.photo, FlutterGradientNames.smartIndigo, size: 55)
                        : Rive(
                            artboard: rive.value,
                          ))),
            galleryArtboard),
        Padding(padding: EdgeInsets.only(top: 4)),
        'Gallery'.p_White,
      ]),
    );
  }

// @ Loads Artboard into ObxValue
  _loadArtboard(Rx<Artboard> rxArtboard) async {
    await rootBundle.load(_tilePath).then(
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

// ^ File Share Button ^ //
class ShareFileButtonItem extends GetView<ShareController> {
  const ShareFileButtonItem();
  @override
  Widget build(BuildContext context) {
    // Load Artboard
    final galleryArtboard = Rx<Artboard>(null);
    _loadArtboard(galleryArtboard);

    return GestureDetector(
      onTap: controller.selectFile,
      child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
        ObxValue<Rx<Artboard>>(
            (rive) => SizedBox(
                height: 55,
                width: 55,
                child: Center(
                    child: rive.value == null
                        ? SonrIcon.gradient(Icons.person, FlutterGradientNames.phoenixStart, size: 55)
                        : Rive(
                            artboard: rive.value,
                          ))),
            galleryArtboard),
        Padding(padding: EdgeInsets.only(top: 4)),
        'File'.p_White,
      ]),
    );
  }

// @ Loads Artboard into ObxValue
  _loadArtboard(Rx<Artboard> rxArtboard) async {
    await rootBundle.load(_documentsPath).then(
      (data) async {
        // Load the RiveFile from the binary data.
        final file = RiveFile.import(data);
        // Retreive Artboard
        final artboard = file.mainArtboard;

        // Retreive Camera
        artboard.addController(SimpleAnimation('Default'));
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
      onTap: controller.selectContact,
      child: Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.center, children: [
        ObxValue<Rx<Artboard>>(
            (rive) => SizedBox(
                height: 55,
                width: 55,
                child: Center(
                    child: rive.value == null
                        ? SonrIcon.gradient(Icons.person, FlutterGradientNames.phoenixStart, size: 55)
                        : Rive(
                            artboard: rive.value,
                          ))),
            galleryArtboard),
        Padding(padding: EdgeInsets.only(top: 4)),
        'Contact'.p_White,
      ]),
    );
  }

// @ Loads Artboard into ObxValue
  _loadArtboard(Rx<Artboard> rxArtboard) async {
    await rootBundle.load(_tilePath).then(
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
