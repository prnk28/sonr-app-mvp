import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/theme/form/theme.dart';

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PlainButton(icon: SonrIcon.close, onPressed: controller.exitToViewing),
                  headerText.h2,
                  Padding(padding: EdgeInsets.all(16))
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
      child: Obx(() => Container(
          width: context.widthTransformer(reducedBy: 15),
          height: context.heightTransformer(reducedBy: 50),
          child: _buildChildFromStatus(controller.status.value))),
    );
  }

  // # Handles Controller Status
  Widget _buildChildFromStatus(ProfilePictureStatus status) {
    switch (status) {
      case ProfilePictureStatus.NeedsPermissions:
        return _buildPermissions();
        break;
      case ProfilePictureStatus.Captured:
        return _buildCaptured();
        break;
      default:
        return _buildCamera();
        break;
    }
  }

  // @ Build Circular Camera
  Widget _buildCamera() {
    return Neumorphic(
        padding: EdgeInsets.all(10),
        style: NeumorphicStyle(
          boxShape: NeumorphicBoxShape.circle(),
          depth: -10,
        ),
        child: GestureDetector(
          onTap: controller.capturePhoto,
          child: CameraAwesome(
            sensor: controller.sensor,
            photoSize: controller.photoSize,
            captureMode: controller.captureMode,
            fitted: true,
          ),
        ));
  }

  // @ Build Circular Camera
  Widget _buildCaptured() {
    return Column(children: [
      // @ Picture Preview
      Neumorphic(
          padding: EdgeInsets.all(10),
          style: NeumorphicStyle(
            boxShape: NeumorphicBoxShape.circle(),
            depth: -10,
          ),
          child: Container(
            width: 120,
            height: 120,
            child: CircleAvatar(
              backgroundImage: FileImage(controller.result.value.file),
            ),
          )),
      Padding(padding: EdgeWith.bottom(8)),

      // @ Confirm Button
      ConfirmButton.save(
        onConfirmed: controller.confirm,
        defaultText: "Confirm",
        confirmText: "Sure?",
      )
    ]);
  }

  // @ Build Permissions Request
  Widget _buildPermissions() {
    return Column(
      children: [
        "Need Camera Permissions".h3,
        ColorButton.primary(onPressed: controller.requestPermission, text: "Proceed"),
      ],
    );
  }
}

// ^ Profile Picture Controller Status ^ //
enum ProfilePictureStatus {
  NeedsPermissions,
  Ready,
  Captured,
}

extension ProfilePictureStatusUtils on ProfilePictureStatus {
  bool get hasPermissions => this != ProfilePictureStatus.NeedsPermissions;
  bool get hasCaptured => this == ProfilePictureStatus.Captured;

  static ProfilePictureStatus statusFromPermissions(bool val) {
    return val ? ProfilePictureStatus.Ready : ProfilePictureStatus.NeedsPermissions;
  }
}

// ^ Profile Picture Reactive Controller ^ //
class ProfilePictureController extends GetxController {
  // Notifiers
  ValueNotifier<CaptureModes> captureMode = ValueNotifier(CaptureModes.PHOTO);
  ValueNotifier<Size> photoSize = ValueNotifier(Size(256, 256));
  ValueNotifier<Sensors> sensor = ValueNotifier(Sensors.FRONT);

  // Properties
  final result = Rx<MediaFile>(null);
  final status = Rx<ProfilePictureStatus>(ProfilePictureStatusUtils.statusFromPermissions(UserService.permissions.value.hasCamera));

  // References
  PictureController _pictureController = PictureController();
  var _photoCapturePath = "";

  // @ Method to Capture Picture
  capturePhoto() async {
    // Set Path
    var temp = await getApplicationDocumentsDirectory();
    var photoDir = await Directory('${temp.path}/photos').create(recursive: true);
    _photoCapturePath = '${photoDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Capture Photo
    await _pictureController.takePicture(_photoCapturePath);
    result(MediaFile.capture(_photoCapturePath, false, 0));
    status(ProfilePictureStatus.Captured);
  }

  // @ Method to Confirm New Picture
  confirm() async {
    if (_photoCapturePath != "") {
      UserService.picture(await result.value.toUint8List());
      await UserService.saveChanges();
      Get.find<ProfileController>().exitToViewing();
      status(ProfilePictureStatus.Ready);
    }
  }

  // @ Method to Request Camera Permissions
  requestPermission() async {
    var granted = await Permission.camera.request().isGranted;
    UserService.permissions.value.update();
    status(ProfilePictureStatusUtils.statusFromPermissions(granted));
  }
}
