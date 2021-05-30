import 'package:sonr_app/style/style.dart';

/// @ Activity View
class ActivityPopup extends StatelessWidget {
  ActivityPopup({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SonrScaffold(
      appBar: DesignAppBar(
        centerTitle: true,
        title: "Activity".headFour(
          color: Get.theme.focusColor,
          weight: FontWeight.w800,
          align: TextAlign.start,
        ),
        leading: ActionButton(icon: SonrIcons.Close.gradient(value: SonrGradients.PhoenixStart), onPressed: () => Get.back(closeOverlays: true)),
        action: ActionButton(
            icon: SonrIcons.Clear.gradient(),
            onPressed: () async {
              if (CardService.activity.length > 0) {
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
                  itemCount: CardService.activity.length,
                  itemBuilder: (context, index) {
                    return _ActivityListItem(item: CardService.activity[index]);
                  })
              : Center(
                  child: Container(
                    child: [Image.asset('assets/illustrations/NoAlerts.png'), "No Alerts".headFive(color: Get.theme.hintColor)].column(),
                    padding: EdgeInsets.all(64),
                  ),
                ))),
    );
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
