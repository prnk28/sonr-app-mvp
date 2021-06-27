import 'package:sonr_app/style/style.dart';
import 'package:sonr_app/data/data.dart';
import '../activity.dart';

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
          trailing: ActionButton(onPressed: () => CardService.clearActivity(item), iconData: SonrIcons.Close),
        ),
      ),
    );
  }
}
