import 'dart:io';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sonr_app/data/data.dart';
import 'package:sonr_app/data/database/cards_db.dart';
import 'package:sonr_app/service/user/cards.dart';
import 'package:sonr_app/theme/theme.dart';

// ^ Widget for Details Media View
class MediaDetailsView extends StatelessWidget {
  final Metadata card;
  final File mediaFile;
  const MediaDetailsView(this.card, this.mediaFile);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: Get.back,
      child: SizedBox(
        width: Get.width,
        child: GestureDetector(
          onTap: () {
            Get.back(closeOverlays: true);
          },
          child: Hero(
            tag: card.path,
            child: Material(
              color: Colors.transparent,
              child: PhotoView(imageProvider: FileImage(mediaFile)),
            ),
          ),
        ),
      ),
    );
  }
}
