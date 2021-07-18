import 'package:sonr_app/modules/activity/activity.dart';
import 'package:sonr_app/style/style.dart';

class PastActivityItem extends GetView<ActivityController> {
  final TransferActivity item;

  const PastActivityItem({Key? key, required this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      padding: EdgeInsets.only(bottom: 24),
      child: BoxContainer(
        child: ListTile(
          title: item.messageText(),
          trailing: ActionButton(onPressed: () => CardService.clearActivity(item), iconData: SimpleIcons.Close),
        ),
      ),
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
          description().paragraph(color: AppTheme.ItemColor)
        ].row();
      case ActivityType.Shared:
        return [
          this.payload.icon(size: 24, color: Get.theme.focusColor),
          " You ".paragraph(color: AppTheme.ItemColor),
          this.activity.value.light(color: AppColor.Blue),
          description().paragraph(color: AppTheme.ItemColor)
        ].row();
      case ActivityType.Received:
        return [
          this.payload.icon(size: 24, color: Get.theme.focusColor),
          " You ".paragraph(color: AppTheme.ItemColor),
          this.activity.value.paragraph(color: AppColor.Purple),
          description().paragraph(color: AppTheme.ItemColor)
        ].row();
      default:
        return [
          this.payload.icon(size: 24, color: Get.theme.focusColor),
          " You ".paragraph(color: AppTheme.ItemColor),
          this.activity.value.paragraph(color: AppColor.DarkGrey),
          description().paragraph(color: AppTheme.ItemColor)
        ].row(textBaseline: TextBaseline.alphabetic, mainAxisAlignment: MainAxisAlignment.start);
    }
  }

  /// Generates Description from this Activity
  String description() {
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
