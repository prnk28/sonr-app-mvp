import 'package:sonr_app/style.dart';

/// @ TransferCard as List item View
class FileItemView extends StatelessWidget {
  final TransferCard item;

  const FileItemView({Key? key, required this.item}) : super(key: key);
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
            ProfileOwnerRow(profile: item.owner),

            // File Content
            Container(
                padding: EdgeInsets.only(left: 8, right: 8, top: 8),
                child: FileContent(
                  file: item.file!,
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
                  FilePayloadText(payload: item.payload, file: item.file),
                  DateText(date: item.received),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
