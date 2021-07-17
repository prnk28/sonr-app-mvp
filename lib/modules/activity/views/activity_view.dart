import 'package:sonr_app/style/style.dart';
import '../activity.dart';

/// #### Activity View
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
          key: controller.clearButtonKey,
          iconData: SimpleIcons.Clear,
          onPressed: controller.clearAllActivity,
        ),
      ),
      body: Column(children: [
        _ActivityHeader(),
        Expanded(
          child: Obx(
            () => _buildExpandedChild(
              ReceiverService.hasSession.value,
              controller.currentPageIndex.value,
            ),
          ),
        )
      ]),
    );
  }

  // @ Helper: Builds Expanded Child by Status
  Widget _buildExpandedChild(bool hasSession, int currentPageIndex) {
    if (hasSession) {
      return controller.currentPageIndex.value == 0 ? _CurrentActivityView() : _PastActivityView();
    } else {
      return _PastActivityView();
    }
  }
}

class _ActivityHeader extends GetView<ActivityController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => ReceiverService.hasSession.value
        ? GradientTabs(
            tabs: ["Active", "Past"],
            onTabChanged: (index) => controller.setView(index),
          )
        : Container());
  }
}

class _PastActivityView extends GetView<ActivityController> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(5.seconds, () async {
      if (await Permissions.Notifications.isNotGranted) {
        AppPage.Error.to(args: ErrorPageArgs.permNotifications());
      }
    });
    return Container(
        padding: EdgeInsets.only(top: 24),
        child: Obx(
          () => CardService.activity.length > 0
              ? ListView.builder(
                  itemCount: CardService.activity.length,
                  itemBuilder: (context, index) {
                    return PastActivityItem(item: controller.pastActivities[index]);
                  })
              : Center(
                  child: Container(
                    child: [
                      Padding(padding: EdgeInsets.all(24)),
                      Image.asset(
                        'assets/images/illustrations/EmptyNotif.png',
                        height: Height.ratio(0.4),
                        fit: BoxFit.fitHeight,
                      ),
                      Padding(padding: EdgeInsets.all(8)),
                      "All Caught Up!".subheading(color: Get.theme.hintColor, fontSize: 20)
                    ].column(),
                    padding: DeviceService.isDesktop ? EdgeInsets.all(64) : EdgeInsets.zero,
                  ),
                ),
        ));
  }
}

class _CurrentActivityView extends GetView<ActivityController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 24),
      child: CurrentReceiveItem(session: ReceiverService.session),
    );
  }
}

extension TransferActivityUtils on TransferActivity {
  /// Builds Message Text for This Past Activity
  Widget messageText() {
    switch (this.activity) {
      case ActivityType.Deleted:
        return [
          this.payload.icon(size: 24, color: Get.theme.focusColor),
          " You ".paragraph(color: AppTheme.ItemColor),
          this.activity.value.paragraph(color: AppColor.Red),
          _description().paragraph(color: AppTheme.ItemColor)
        ].row();
      case ActivityType.Shared:
        return [
          this.payload.icon(size: 24, color: Get.theme.focusColor),
          " You ".paragraph(color: AppTheme.ItemColor),
          this.activity.value.light(color: AppColor.Blue),
          _description().paragraph(color: AppTheme.ItemColor)
        ].row();
      case ActivityType.Received:
        return [
          this.payload.icon(size: 24, color: Get.theme.focusColor),
          " You ".paragraph(color: AppTheme.ItemColor),
          this.activity.value.paragraph(color: AppColor.Purple),
          _description().paragraph(color: AppTheme.ItemColor)
        ].row();
      default:
        return [
          this.payload.icon(size: 24, color: Get.theme.focusColor),
          " You ".paragraph(color: AppTheme.ItemColor),
          this.activity.value.paragraph(color: AppColor.DarkGrey),
          _description().paragraph(color: AppTheme.ItemColor)
        ].row(textBaseline: TextBaseline.alphabetic, mainAxisAlignment: MainAxisAlignment.start);
    }
  }

  /// Generates Description from this Activity
  String _description() {
    if (this.payload == Payload.FILES) {
      return " some Files"; //+ " from ${card.owner.firstName}";
    } else if (this.payload == Payload.FILE || this.payload == Payload.MEDIA) {
      return " a " + this.payload.toString().capitalizeFirst!; //+ " from ${card.owner.firstName}";
    } else {
      if (this.payload == Payload.CONTACT) {
        return " a Contact"; // + " from ${card.owner.firstName}";
      }
      return " a Link"; // + " from ${card.owner.firstName}";
    }
  }
}
