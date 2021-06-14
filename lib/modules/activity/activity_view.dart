import 'package:sonr_app/style.dart';
import 'activity_controller.dart';
import 'past_item.dart';

/// @ Activity View
class ActivityPopup extends GetView<ActivityController> {
  ActivityPopup({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SonrScaffold(
      appBar: DetailAppBar(
        isClose: true,
        title: "Activity",
        onPressed: () => AppRoute.close(),
        action: ActionButton(
          iconData: SonrIcons.Clear,
          onPressed: controller.clearAllActivity,
        ),
      ),
      body: Column(
        children: [
          _ActivityHeader(),
          Expanded(
            child: _PastActivityView(),
          )
        ],
      ),
    );
  }
}

class _ActivityHeader extends GetView<ActivityController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.hasActiveSession.value ? GradientTabs(tabs: ["Active", "Past"], onTabChanged: controller.setView) : Container());
  }
}

class _PastActivityView extends GetView<ActivityController> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Obx(
      () => CardService.activity.length > 0
          ? ListView.builder(
              itemCount: controller.activityLength.value,
              itemBuilder: (context, index) {
                return PastActivityItem(item: controller.pastActivities[index]);
              })
          : Center(
              child: Container(
                child: [
                  Image.asset(
                    'assets/illustrations/EmptyNotif.png',
                    height: Height.ratio(0.4),
                    fit: BoxFit.fitHeight,
                  ),
                  "All Caught Up!".subheading(color: Get.theme.hintColor, fontSize: 20)
                ].column(),
                padding: DeviceService.isDesktop ? EdgeInsets.all(64) : EdgeInsets.zero,
              ),
            ),
    ));
  }
}
