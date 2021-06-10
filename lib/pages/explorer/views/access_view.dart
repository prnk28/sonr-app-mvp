import 'package:flutter/material.dart';
import 'package:sonr_app/pages/detail/detail_page.dart';
import 'package:sonr_app/style.dart';
import '../explorer_controller.dart';

class AccessView extends GetView<ExplorerController> {
  AccessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: SonrTheme.cardDecoration,
      width: 800,
      height: 700,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: "Quick Access".subheading(align: TextAlign.start, color: Get.theme.focusColor),
        ),
        Padding(padding: EdgeInsets.only(top: 4)),
        Center(
          child: Container(
              height: 650,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ImageButton(
                          path: TransferItemsType.Media.imagePath(),
                          label: TransferItemsType.Media.name(),
                          imageFit: BoxFit.fitWidth,
                          imageWidth: 130,
                          onPressed: () {
                            if (TransferItemsType.Media.count() > 0) {
                              Details.toPostsList(TransferItemsType.Media);
                            } else {
                              Details.toError(DetailPageType.ErrorEmptyMedia);
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ImageButton(
                          path: TransferItemsType.Files.imagePath(),
                          label: TransferItemsType.Files.name(),
                          onPressed: () {
                            if (TransferItemsType.Files.count() > 0) {
                              Details.toPostsList(TransferItemsType.Files);
                            } else {
                              Details.toError(DetailPageType.ErrorEmptyFiles);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ImageButton(
                          path: TransferItemsType.Contacts.imagePath(),
                          label: TransferItemsType.Contacts.name(),
                          onPressed: () {
                            if (TransferItemsType.Contacts.count() > 0) {
                              Details.toPostsList(TransferItemsType.Contacts);
                            } else {
                              Details.toError(DetailPageType.ErrorEmptyContacts);
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ImageButton(
                          path: TransferItemsType.Links.imagePath(),
                          imageWidth: 90,
                          imageHeight: 90,
                          label: TransferItemsType.Links.name(),
                          onPressed: () {
                            if (TransferItemsType.Links.count() > 0) {
                              Details.toPostsList(TransferItemsType.Links);
                            } else {
                              Details.toError(DetailPageType.ErrorEmptyLinks);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ]),
    );
  }
}
