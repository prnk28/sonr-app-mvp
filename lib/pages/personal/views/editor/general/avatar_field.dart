import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:sonr_app/pages/personal/personal.dart';
import 'package:sonr_app/style/style.dart';

class ProfileAvatarField extends GetView<PersonalController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (ContactService.contact.value.hasPicture()) {
        return GestureDetector(
          onLongPress: () async {
            controller.setAddPicture();
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppTheme.ForegroundColor, shape: BoxShape.circle, boxShadow: AppTheme.RectBoxShadow),
                child: Container(
                  width: 100,
                  height: 100,
                  child: ContactService.contact.value.hasPicture()
                      ? CircleAvatar(
                          backgroundColor: AppTheme.ForegroundColor,
                          foregroundImage: MemoryImage(Uint8List.fromList(ContactService.contact.value.picture)),
                        )
                      : SimpleIcons.Avatar.greyWith(size: 100),
                )),
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
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppTheme.ForegroundColor, shape: BoxShape.circle, boxShadow: AppTheme.RectBoxShadow),
                child: Container(
                    width: 100,
                    height: 100,
                    child: CircleAvatar(
                      child: SimpleIcons.Avatar.greyWith(size: 80),
                      backgroundColor: AppTheme.ForegroundColor,
                    ))),
          ),
        );
      }
    });
  }
}

/// #### Edit Profile Picture View
class EditPictureView extends GetView<PersonalController> {
  final String headerText;
  EditPictureView({this.headerText = "Edit Picture", Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() => Get.find<PersonalController>().status.value == PersonalViewStatus.NeedCameraPermissions
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
                        ActionButton(iconData: SimpleIcons.Close, onPressed: controller.exitToViewing),
                        headerText.subheading(),
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

/// #### Circular Camera View
class _ProfilePictureCameraView extends GetView<PersonalController> {
  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Obx(() => Container(
            width: context.widthTransformer(reducedBy: 15),
            height: context.heightTransformer(reducedBy: 50),
            child: Column(children: [
              // @ Picture Preview
              CircleContainer(
                  padding: EdgeInsets.all(10),
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

class _CameraPermissionsView extends GetView<PersonalController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/illustrations/Camera.png'), fit: BoxFit.fitWidth),
          borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.only(bottom: 24),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ColorButton.primary(onPressed: controller.requestCamera, text: "Proceed"),
      ),
    );
  }
}
