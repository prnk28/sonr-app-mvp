import 'package:sonr_app/style.dart';

class ShareConfirmSheet extends GetView<ShareController> {
  const ShareConfirmSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedBounce(
          direction: BounceDirection.Up,
          isDisplayed: controller.selectedItems.length > 0,
          child: Container(
            padding: EdgeInsets.all(8),
            width: Get.width,
            height: 160,
            decoration: BoxDecoration(
                boxShadow: AppTheme.boxShadow,
                color: AppTheme.foregroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(37),
                  topRight: Radius.circular(37),
                )),
            child: Row(
              children: [
                ColorButton.primary(
                  onPressed: () {},
                  icon: SonrIcons.Share,
                  text: "Share",
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
            ),
          ),
        ));
  }
}
