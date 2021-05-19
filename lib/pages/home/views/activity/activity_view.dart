import 'package:sonr_app/style/style.dart';

/// @ Activity View
class ActivityView extends StatelessWidget {
  ActivityView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: Width.reduced(0.1),
        height: Height.ratio(0.7),
        child: Obx(() => CardService.activity.length > 0
            ? ListView.builder(
                itemCount: CardService.activity.length,
                itemBuilder: (context, index) {
                  return _ActivityListItem(item: CardService.activity[index]);
                })
            : Center(
                child: Container(
                  child: [SonrAssetIllustration.NoAlerts.widget, "No Alerts".headFour(color: Get.theme.hintColor)].column(),
                  padding: EdgeInsets.all(64),
                ),
              )));
  }
}

/// @ Activity List Item
class _ActivityListItem extends StatelessWidget {
  final TransferActivity item;

  const _ActivityListItem({Key? key, required this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      padding: EdgeInsets.only(bottom: 24),
      child: Dismissible(
        key: ValueKey(item),
        onDismissed: (direction) => CardService.clearActivity(item),
        direction: DismissDirection.endToStart,
        background: Container(
          color: SonrColor.Critical,
          child: Align(
            alignment: Alignment.centerRight,
            child: SonrIcons.Cancel.whiteWith(size: 28),
          ),
        ),
        child: Container(
          decoration: Neumorphic.floating(
            theme: Get.theme,
          ),
          child: ListTile(
            title: _buildMessage(),
          ),
        ),
      ),
    );
  }

  Widget _buildMessage() {
    switch (item.activity) {
      case ActivityType.Deleted:
        return [item.payload.icon(size: 24, color: Get.theme.focusColor), " You ".h6, item.activity.value.h6_Red, _description(item).h6].row();
      case ActivityType.Shared:
        return [item.payload.icon(size: 24, color: Get.theme.focusColor), " You ".h6, item.activity.value.h6_Blue, _description(item).h6].row();
      case ActivityType.Received:
        return [item.payload.icon(size: 24, color: Get.theme.focusColor), " You ".h6, item.activity.value.h6_Purple, _description(item).h6].row();
      default:
        return [item.payload.icon(size: 24, color: Get.theme.focusColor), " You ".h6, item.activity.value.h6_Grey, _description(item).h6]
            .row(textBaseline: TextBaseline.alphabetic, mainAxisAlignment: MainAxisAlignment.start);
    }
  }

  String _description(TransferActivity activity) {
    if (activity.payload == Payload.FILES) {
      return " some Files"; //+ " from ${card.owner.firstName}";
    } else if (activity.payload == Payload.FILE || activity.payload == Payload.MEDIA) {
      return " a " + activity.mime.toString().capitalizeFirst!; //+ " from ${card.owner.firstName}";
    } else {
      if (activity.payload == Payload.CONTACT) {
        return " a Contact"; // + " from ${card.owner.firstName}";
      }
      return " a Link"; // + " from ${card.owner.firstName}";
    }
  }
}
