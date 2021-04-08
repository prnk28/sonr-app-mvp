import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/theme/theme.dart';

import 'profile_controller.dart';

// ^ Edit Profile Picture View ^ //
class EditPictureView extends GetView<ProfileController> {
  final String headerText;
  EditPictureView({this.headerText = "Edit Picture", Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: CustomScrollView(slivers: [
        // @ Top Banner
        SliverToBoxAdapter(
          child: Container(
            height: kToolbarHeight + 24,
            child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PlainButton(icon: SonrIcon.close, onPressed: controller.exitToViewing),
                  Expanded(child: Center(child: SonrText.header(headerText, size: 34))),
                  PlainButton(icon: SonrIcon.accept, onPressed: controller.saveEditedDetails)
                ]),
          ),
        ),
        // @ Window Content
        _ProfilePictureCameraView()
      ]),
    );
  }
}

// ^ Circular Camera View ^ //
class _ProfilePictureCameraView extends GetView<ProfilePictureController> {
  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Container(
          width: context.widthTransformer(reducedBy: 15),
          height: context.heightTransformer(reducedBy: 15),
          child: Obx(() => controller.hasPermissions.value ? _buildCamera() : _buildPermissions())),
    );
  }

  // @ Build Circular Camera
  Widget _buildCamera() {
    return Neumorphic(
        padding: EdgeInsets.all(10),
        style: NeumorphicStyle(
          boxShape: NeumorphicBoxShape.circle(),
          depth: -10,
        ),
        child: CameraAwesome(
          sensor: controller.sensor,
          photoSize: controller.photoSize,
          captureMode: controller.captureMode,
          fitted: true,
        ));
  }

  // @ Build Permissions Request
  Widget _buildPermissions() {
    return Column(
      children: [
        SonrText.subtitle("Need Camera Permissions"),
        ColorButton.primary(onPressed: controller.requestPermission, text: "Proceed"),
      ],
    );
  }
}

// ^ Profile Picture Reactive Controller ^ //
class ProfilePictureController extends GetxController {
  // Notifiers
  ValueNotifier<CaptureModes> captureMode = ValueNotifier(CaptureModes.PHOTO);
  ValueNotifier<Size> photoSize = ValueNotifier(Size(256, 256));
  ValueNotifier<Sensors> sensor = ValueNotifier(Sensors.FRONT);

  final hasCaptured = false.obs;
  final hasPermissions = UserService.permissions.value.hasCamera.obs;

  // Controllers
  PictureController pictureController = new PictureController();
  var _photoCapturePath = "";

  capturePhoto() async {
    // Set Path
    var temp = await getApplicationDocumentsDirectory();
    var photoDir = await Directory('${temp.path}/photos').create(recursive: true);
    _photoCapturePath = '${photoDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Capture Photo
    await pictureController.takePicture(_photoCapturePath);
    hasCaptured(true);
  }

  confirm() async {
    if (_photoCapturePath != "") {
      var file = MediaFile.capture(_photoCapturePath, false, 0);
      UserService.picture(await file.toUint8List());
      UserService.saveChanges();
      Get.find<ProfileController>().exitToViewing();
    }
  }

  requestPermission() async {
    var granted = await Permission.camera.request().isGranted;
    UserService.permissions.value.update();
    hasPermissions(granted);
  }
}
