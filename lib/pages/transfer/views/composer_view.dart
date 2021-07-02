import 'package:sonr_app/pages/transfer/transfer.dart';
import 'package:sonr_app/style/style.dart';

/// @ Invite Composer for Remote Transfer
class InviteComposer extends GetView<ComposeController> {
  @override
  Widget build(BuildContext context) {
    return BoxContainer(
      footer: ColorButton.primary(
        text: "Share File",
        onPressed: () => controller.shareRemote(),
      ),
      padding: EdgeInsets.all(8),
      margin: _calculateMargin(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          "Remote Invite".heading(
            fontSize: 32,
            color: AppTheme.itemColor,
          ),
          "Type the SName of the User you want to Share with.".light(
            fontSize: 24,
            color: AppTheme.itemColor,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleContainer(
                  padding: EdgeInsets.all(8),
                  child: SonrIcons.ATSign.icon(
                    color: AppTheme.itemColorInversed,
                    size: 36,
                  )),
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SNameTextField(
                      onEditingComplete: (value) {
                        controller.checkName(value, withShare: true);
                      },
                      onChanged: (value) {
                        controller.checkName(value);
                      },
                    ),
                  ),
                  DashedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Obx(() => AnimatedStatus(
                          status: controller.composeStatus.value.toAnimatedStatus(),
                        )),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  EdgeInsets _calculateMargin() {
    // Fetch Height
    final topPad = 145.0;
    final bottomPad = Get.height - 135;
    return EdgeInsets.only(top: topPad, bottom: bottomPad, left: 24, right: 24);
  }
}
