import 'package:sonr_app/style/style.dart';

// ^ Activity View ^ //
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
                  child: [SonrAssetIllustration.NoAlerts.widget, "No Alerts".headFour(color: SonrColor.Grey.withOpacity(0.6))].column(),
                  padding: EdgeInsets.all(64),
                ),
              )));
  }
}

// ^ Activity List Item ^ //
class _ActivityListItem extends StatelessWidget {
  final TransferCardActivity item;

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
          decoration: Neumorphic.floating(),
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
        return [item.card!.payload.black, " You ".h6, item.activity.value.h6_Red, _description(item.card!).h6].row();
      case ActivityType.Shared:
        return [item.card!.payload.black, " You ".h6, item.activity.value.h6_Blue, _description(item.card!).h6].row();
      case ActivityType.Received:
        return [item.card!.payload.black, " You ".h6, item.activity.value.h6_Purple, _description(item.card!).h6].row();
      default:
        return [item.card!.payload.black, " You ".h6, item.activity.value.h6_Grey, _description(item.card!).h6]
            .row(textBaseline: TextBaseline.alphabetic, mainAxisAlignment: MainAxisAlignment.start);
    }
  }

  String _description(TransferCard card) {
    if (card.payload == Payload.MULTI_FILES) {
      return " some Files"; //+ " from ${card.owner.firstName}";
    } else if (card.payload == Payload.FILE || card.payload == Payload.MEDIA) {
      return " a " + card.file.single.mime.type.toString().capitalizeFirst!; //+ " from ${card.owner.firstName}";
    } else {
      if (card.payload == Payload.CONTACT) {
        return " a Contact"; // + " from ${card.owner.firstName}";
      }
      return " a Link"; // + " from ${card.owner.firstName}";
    }
  }
}
