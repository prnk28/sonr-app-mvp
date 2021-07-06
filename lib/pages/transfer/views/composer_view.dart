import 'package:sonr_app/pages/transfer/transfer.dart';
import 'package:sonr_app/style/style.dart';

/// @ Invite Composer for Remote Transfer
class InviteComposer extends GetView<ComposeController> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        height: Get.height,
        margin: EdgeInsets.only(top: 24, bottom: 135, left: 24, right: 24),
        child: BoxContainer(
            footer: ColorButton.primary(
              text: "Share File",
              onPressed: () => controller.shareRemote(),
            ),
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "Remote Invite".heading(
                  fontSize: 32,
                  color: AppTheme.itemColor,
                  align: TextAlign.start,
                ),
                "Type the SName of the User you want to Share with.".light(
                  fontSize: 20,
                  color: AppTheme.greyColor,
                ),
                Container(
                  padding: EdgeInsets.only(top: 16, left: 8, right: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleContainer(
                          padding: EdgeInsets.all(4),
                          child: SonrIcons.ATSign.icon(
                            color: AppTheme.itemColor,
                            size: 24,
                          )),
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              width: 200,
                              padding: EdgeInsets.only(right: 24),
                              child: SNameTextField(
                                onEditingComplete: (value) {
                                  controller.checkName(value, withShare: true);
                                },
                                onChanged: (value) {
                                  controller.checkName(value);
                                },
                              ),
                            ),
                          ),
                          AnimatedStatus()
                        ],
                      )
                    ],
                  ),
                ),
              ],
            )));
  }
}

class AnimatedStatus extends GetView<ComposeController> {
  const AnimatedStatus();

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.shouldUpdate.value
        ? FadeInLeftBig(
            animate: controller.shouldUpdate.value,
            child: Container(
              child: _buildStatusIcon(controller.composeStatus.value),
            ))
        : FadeOutRight(
            animate: !controller.shouldUpdate.value,
            child: Container(
              child: _buildStatusIcon(controller.composeStatus.value),
            )));
  }

  Widget _buildStatusIcon(ComposeStatus status) {
    switch (status) {
      case ComposeStatus.Initial:
        return Container();
      case ComposeStatus.Checking:
        return HourglassIndicator();
      case ComposeStatus.NonExisting:
        return SonrIcons.Close.icon(color: SonrColor.Critical, size: 36);
      case ComposeStatus.Existing:
        return SonrIcons.Check.icon(color: SonrColor.Critical, size: 36);
    }
  }
}
