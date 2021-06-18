import 'package:sonr_app/pages/transfer/transfer.dart';
import 'package:sonr_app/style.dart';

class SonrFileListHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final file = TransferController.invite.file;
    return Container(
      width: Get.width,
      height: Height.ratio(0.125),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: file.prettyName().subheading(color: SonrTheme.itemColor),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: file.prettySize().light(color: SonrTheme.itemColor),
          )
        ],
      ),
    );
  }
}
