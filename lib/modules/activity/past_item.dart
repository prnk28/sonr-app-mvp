import 'package:sonr_app/style.dart';
import 'package:sonr_app/data/data.dart';
import 'activity_controller.dart';

class PastActivityItem extends GetView<ActivityController> {
  final TransferActivity item;

  const PastActivityItem({Key? key, required this.item}) : super(key: key);
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
          decoration: SonrTheme.cardDecoration,
          child: ListTile(title: item.messageText()),
        ),
      ),
    );
  }
}
