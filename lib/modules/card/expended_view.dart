import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

// ** Expanded Hero Home Screen Item ** //
class ExpandedView extends StatelessWidget {
  final TransferCard card;

  const ExpandedView({Key key, @required this.card}) : super(key: key);
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
            tag: card.id,
            child: Material(color: Colors.transparent, child: _buildExpandedChild()),
          ),
        ),
      ),
    );
  }

  // ^ Builds Expanded View by Card Type
  Widget _buildExpandedChild() {
    // @ Media Card =>
    if (card.payload == Payload.MEDIA) {
      // Photo File
      if (card.metadata.mime.type == MIME_Type.image) {
        return PhotoView(imageProvider: MemoryImage(card.metadata.thumbnail));
      }
      // TODO: Video File
      else if (card.metadata.mime.type == MIME_Type.video) {
        return Container();
      }
      // Other
      else {
        return Container();
      }
    }

    // TODO: Contact Card =>
    else if (card.payload == Payload.CONTACT) {
      return Container(color: Colors.blue);
    }
    // TODO: Other Card =>
    else {
      return Container();
    }
  }
}
