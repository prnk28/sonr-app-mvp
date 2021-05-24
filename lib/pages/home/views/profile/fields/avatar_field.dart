import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:sonr_app/style/style.dart';
import '../profile_controller.dart';

class ProfileAvatarField extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (UserService.contact.value.hasPicture()) {
        return GestureDetector(
          onLongPress: () async {
            controller.setAddPicture();
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: Neumorphic.indented(theme: Get.theme, shape: BoxShape.circle),
              child: Obx(() => Container(
                    width: 120,
                    height: 120,
                    child: UserService.contact.value.hasPicture()
                        ? CircleAvatar(
                            backgroundImage: MemoryImage(Uint8List.fromList(UserService.contact.value.picture)),
                          )
                        : SonrIcons.Avatar.greyWith(size: 120),
                  )),
            ),
          ),
        );
      } else {
        return GestureDetector(
          onTap: () async {
            controller.setAddPicture();
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Container(
                padding: EdgeInsets.all(10),
                decoration: Neumorphic.indented(theme: Get.theme, shape: BoxShape.circle),
                child: Container(
                    width: 120,
                    height: 120,
                    child: CircleAvatar(
                      child: SonrIcons.Avatar.greyWith(size: 120),
                      backgroundColor: Color(0xfff0f6fa).withOpacity(0.8),
                    ))),
          ),
        );
      }
    });
  }
}

/// @ Edit Profile Picture View
class EditPictureView extends GetView<ProfileController> {
  final String headerText;
  EditPictureView({this.headerText = "Edit Picture", Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => Get.find<ProfileController>().status.value == ProfileViewStatus.NeedCameraPermissions
        ? _CameraPermissionsView()
        : Container(
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
                        PlainButton(icon: SonrIcons.Close, onPressed: controller.exitToViewing),
                        headerText.h2,
                        Padding(padding: EdgeInsets.all(16))
                      ]),
                ),
              ),
              // @ Window Content
              _ProfilePictureCameraView()
            ]),
          ));
  }
}

/// @ Circular Camera View
class _ProfilePictureCameraView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Obx(() => Container(
            width: context.widthTransformer(reducedBy: 15),
            height: context.heightTransformer(reducedBy: 50),
            child: Column(children: [
              // @ Picture Preview
              Container(
                  padding: EdgeInsets.all(10),
                  decoration: Neumorphic.floating(theme: Get.theme, shape: BoxShape.circle),
                  child: AnimatedContainer(
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    width: 140,
                    height: 140,
                    duration: 250.milliseconds,
                    child: controller.status.value.hasCaptured
                        ? CircleAvatar(backgroundImage: FileImage(controller.result.value!))
                        : GestureDetector(
                            onTap: controller.captureAvatar,
                            child: ClipOval(
                              child: CameraAwesome(
                                testMode: false,
                                sensor: controller.sensor,
                                photoSize: controller.photoSize,
                                captureMode: controller.captureMode,
                                fitted: true,
                              ),
                            ),
                          ),
                  )),
              Padding(padding: EdgeWith.bottom(8)),

              // @ Confirm Button
              controller.status.value.hasCaptured
                  ? ConfirmButton.save(
                      onConfirmed: controller.confirmAvatar,
                      defaultText: "Confirm",
                      confirmText: "Sure?",
                    )
                  : Spacer()
            ]),
          )),
    );
  }
}

class _CameraPermissionsView extends GetView<ProfileController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/illustrations/Camera.png'), fit: BoxFit.fitWidth),
          borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.only(bottom: 24),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ColorButton.primary(onPressed: controller.requestCamera, text: "Proceed"),
      ),
    );
  }
}
