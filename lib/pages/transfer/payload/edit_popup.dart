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
        margin: EdgeInsets.only(left: 10, right: 10, top: 24),
        child: Column(
          children: [
            Container(
              child: DetailAppBar(onPressed: () => SonrOverlay.closeAll(), title: item.prettyType(), isClose: true),
              height: 64,
            ),
            _EditPayloadPopupInfo(item: item),
          ],
        ),
      ),
    ));
  }
}

class _EditPayloadPopupInfo extends StatelessWidget {
  final SonrFile_Item item;

  const _EditPayloadPopupInfo({Key? key, required this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TransferService.file.value.prettyName().subheading(color: SonrTheme.itemColor),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: TransferService.file.value.prettySize().light(color: SonrTheme.itemColor),
          )
        ],
      ),
    );
  }
}
