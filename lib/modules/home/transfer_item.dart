import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';
import 'home_controller.dart';
import 'package:flutter/material.dart';
import 'package:sonr_core/sonr_core.dart';

// ** Home Screen Item ** //
class TransferItem extends GetView<HomeController> {
  final TransferCard card;
  TransferItem(this.card);

  @override
  Widget build(BuildContext context) {
    // @ Return View
    return GestureDetector(
      onTap: () async {
        controller.toggleShareExpand(options: ToggleForced(false));
      },
      child: Neumorphic(
        style: NeumorphicStyle(intensity: 0.85, boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20))),
        margin: EdgeInsets.all(4),
        child: Container(
          height: 75,
          child: buildCard(card),
          decoration: BoxDecoration(
              image: DecorationImage(
            fit: BoxFit.cover,
            image: MemoryImage(card.metadata.thumbnail),
          )),
        ),
      ),
    );
  }

  // ^ Method Creates Card Widget ^ //
  Widget buildCard(TransferCard card) {
    switch (card.payload) {
      case Payload.MEDIA:
        return _buildMediaItem(card.metadata, card);
        break;
      case Payload.CONTACT:
        return _buildContactItem(card.contact);
        break;
    }
    return Container();
  }

  // @ Method Builds Media Content from Metadata ^ //
  Widget _buildMediaItem(Metadata metadata, TransferCard card) {
    return new Stack(
      children: <Widget>[
        Hero(
          tag: metadata.id,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SonrText.normal(metadata.mime.type.toString()),
            SonrText.normal("Owner: " + card.firstName),
          ]),
        ),
      ],
    );
  }

// @ Method Builds Contact Content ^ //
  Widget _buildContactItem(Contact contact) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SonrText.normal(contact.firstName),
      SonrText.normal(contact.lastName),
    ]);
  }
}

// ** Expanded Hero Home Screen Item ** //
class MediaItemExpanded extends StatelessWidget {
  final Metadata metadata;

  const MediaItemExpanded({Key key, this.metadata}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Hero(
        tag: metadata.id,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: Get.back,
            child: Image.memory(
              metadata.thumbnail,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
