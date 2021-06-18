import 'package:sonr_app/pages/transfer/transfer.dart';
import 'package:sonr_app/style.dart';

class EditPayloadPopup extends StatelessWidget {
  final SonrFile_Item item;
  final int index;

  const EditPayloadPopup({Key? key, required this.item, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Material(
      type: MaterialType.transparency,
      child: BoxContainer(
        width: Get.width,
        padding: EdgeInsets.only(left: 8, right: 8),
        height: 460,
        margin: EdgeInsets.only(left: 24, right: 24, top: 24),
        child: Column(
          children: [
            Container(
              child: DetailAppBar(onPressed: () => Get.back(), title: item.prettyType(), isClose: true),
              height: 64,
            ),
            PayloadItemInfo(item: item),
          ],
        ),
      ),
    ));
  }
}
