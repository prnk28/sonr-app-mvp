import 'package:sonr_app/style.dart';
import 'activity_controller.dart';
import 'past_item.dart';

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
          child: Obx(
        () => CardService.activity.length > 0 ? _ActivityListView() : _ActivityEmptyView(),
      )),
    );
  }
}

// @ Helper: View for Past/Current Activity
class _ActivityListView extends GetView<ActivityController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView.builder(
        itemCount: controller.activityLength.value,
        itemBuilder: (context, index) {
          return PastActivityItem(item: controller.pastActivities[index]);
        }));
  }
}

// @ Helper: View for Empty Activity
class _ActivityEmptyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: [
          Image.asset(
            'assets/illustrations/EmptyNotif.png',
            height: Height.ratio(0.6),
            fit: BoxFit.fitHeight,
          ),
          "All Caught Up!".subheading(color: Get.theme.hintColor, fontSize: 20)
        ].column(),
        padding: DeviceService.isDesktop ? EdgeInsets.all(64) : EdgeInsets.zero,
      ),
    );
  }
}
