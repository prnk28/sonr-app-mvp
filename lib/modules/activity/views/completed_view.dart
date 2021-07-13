import 'package:sonr_app/style/style.dart';
import '../activity.dart';
import 'package:sonr_app/modules/peer/peer.dart';

/// #### Completed Transfer Popup View
class CompletedPopup extends GetView<ActivityController> {
  final Transfer transfer;
  CompletedPopup({Key? key, required this.transfer}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      // Lotte Animation
      !Logger.hasTransferred.val
          ? IgnorePointer(child: LottieFile.Celebrate.lottie(width: Get.width, height: Get.height, repeat: false, fit: BoxFit.fitHeight))
          : Container(),

      // Scaffold Box
      _PostTransferItem(transfer: transfer),
      Container(
        margin: EdgeInsets.only(top: 356),
        child: ColorButton.primary(
          onPressed: () => controller.exportTransfer(transfer),
          text: "Export",
          icon: SimpleIcons.ShareOutside,
        ),
      ),
    ]);
  }
}

/// #### TransferCard as List item View
class _PostTransferItem extends StatelessWidget {
  final Transfer transfer;

  const _PostTransferItem({Key? key, required this.transfer}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 48.0, top: 16.0),
      child: BoxContainer(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(horizontal: 12),
        height: 400,
        child: Column(
          children: [
            // Owner Info
            ProfileOwnerRow(profile: transfer.owner),

            // File Content
            Container(
                padding: EdgeInsets.only(left: 8, right: 8, top: 8),
                child: FileContent(
                  file: transfer.file,
                ),
                height: 237),
            Padding(padding: EdgeInsets.only(top: 8)),
            // Info of Transfer
            Container(
              padding: EdgeInsets.only(left: 8, right: 8, top: 8),
              width: Get.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FilePayloadText(payload: transfer.payload, file: transfer.file),
                  DateText.fromMilliseconds(transfer.received * 1000),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
