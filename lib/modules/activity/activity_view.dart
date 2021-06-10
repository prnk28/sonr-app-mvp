import 'package:sonr_app/style.dart';
import 'activity_controller.dart';
import 'activity_item.dart';

/// @ Activity View
class ActivityPopup extends GetView<ActivityController> {
  /// Method Opens Activity Popup
  static void open() {
    Get.to(ActivityPopup(), transition: Transition.downToUp);
  }

  ActivityPopup({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SonrScaffold(
      appBar: DetailAppBar(
        isClose: true,
        title: "Activity",
        onPressed: () => Get.back(closeOverlays: true),
        action: ActionButton(
            iconData: SonrIcons.Clear,
            onPressed: () async {
              if (controller.activityLength > 0) {
                var decision = await SonrOverlay.question(
                    title: "Clear?", description: "Would you like to clear all activity?", acceptTitle: "Yes", declineTitle: "Cancel");
                if (decision) {
                  CardService.clearAllActivity();
                }
              }
            }),
      ),
      body: Container(
          child: Obx(() => CardService.activity.length > 0
              ? ListView.builder(
                  itemCount: controller.activityLength.value,
                  itemBuilder: (context, index) {
                    return ActivityListItem(item: controller.pastActivities[index]);
                  })
              : Center(
                  child: Container(
                    child: [Image.asset('assets/illustrations/EmptyNotif.png'), "All Caught Up!".subheading(color: Get.theme.hintColor, fontSize: 20)]
                        .column(),
                    padding: EdgeInsets.all(64),
                  ),
                ))),
    );
  }
}
