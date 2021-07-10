import 'package:sonr_app/style/style.dart';

extension TransferActivityUtils on TransferActivity {
  /// Builds Message Text for This Past Activity
  Widget messageText() {
    switch (this.activity) {
      case ActivityType.Deleted:
        return [
          this.payload.icon(size: 24, color: Get.theme.focusColor),
          " You ".paragraph(color: AppTheme.ItemColor),
          this.activity.value.paragraph(color: AppColor.Critical),
          _description().paragraph(color: AppTheme.ItemColor)
        ].row();
      case ActivityType.Shared:
        return [
          this.payload.icon(size: 24, color: Get.theme.focusColor),
          " You ".paragraph(color: AppTheme.ItemColor),
          this.activity.value.light(color: AppColor.Primary),
          _description().paragraph(color: AppTheme.ItemColor)
        ].row();
      case ActivityType.Received:
        return [
          this.payload.icon(size: 24, color: Get.theme.focusColor),
          " You ".paragraph(color: AppTheme.ItemColor),
          this.activity.value.paragraph(color: AppColor.Secondary),
          _description().paragraph(color: AppTheme.ItemColor)
        ].row();
      default:
        return [
          this.payload.icon(size: 24, color: Get.theme.focusColor),
          " You ".paragraph(color: AppTheme.ItemColor),
          this.activity.value.paragraph(color: AppColor.Grey),
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
