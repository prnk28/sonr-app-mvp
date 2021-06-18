import 'package:sonr_app/style.dart';
import 'package:sonr_app/data/database/service.dart';

extension TransferActivityUtils on TransferActivity {
  /// Builds Message Text for This Past Activity
  Widget messageText() {
    switch (this.activity) {
      case ActivityType.Deleted:
        return [
          this.payload.icon(size: 24, color: Get.theme.focusColor),
          " You ".paragraph(),
          this.activity.value.paragraph(color: SonrColor.Critical),
          _description().paragraph()
        ].row();
      case ActivityType.Shared:
        return [
          this.payload.icon(size: 24, color: Get.theme.focusColor),
          " You ".paragraph(),
          this.activity.value.light(color: SonrColor.Primary),
          _description().paragraph()
        ].row();
      case ActivityType.Received:
        return [
          this.payload.icon(size: 24, color: Get.theme.focusColor),
          " You ".paragraph(),
          this.activity.value.paragraph(color: SonrColor.Secondary),
          _description().paragraph()
        ].row();
      default:
        return [
          this.payload.icon(size: 24, color: Get.theme.focusColor),
          " You ".paragraph(),
          this.activity.value.paragraph(color: SonrColor.Grey),
          _description().paragraph()
        ].row(textBaseline: TextBaseline.alphabetic, mainAxisAlignment: MainAxisAlignment.start);
    }
  }

  /// Generates Description from this Activity
  String _description() {
    if (this.payload == Payload.FILES) {
      return " some Files"; //+ " from ${card.owner.firstName}";
    } else if (this.payload == Payload.FILE || this.payload == Payload.MEDIA) {
      return " a " + this.mime.toString().capitalizeFirst!; //+ " from ${card.owner.firstName}";
    } else {
      if (this.payload == Payload.CONTACT) {
        return " a Contact"; // + " from ${card.owner.firstName}";
      }
      return " a Link"; // + " from ${card.owner.firstName}";
    }
  }
}
