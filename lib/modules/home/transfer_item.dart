import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';
import 'home_controller.dart';
import 'package:flutter/material.dart';
import 'package:sonr_app/data/model_card.dart';
import 'package:sonr_core/sonr_core.dart';

// ** Home Screen Item ** //
class TransferItem extends GetView<HomeController> {
  final CardModel card;
  TransferItem(this.card);

  @override
  Widget build(BuildContext context) {
    // @ Return View
    return GestureDetector(
        onTap: () async {
          controller.toggleShareExpand(options: ToggleForced(false));
        },
        child: Neumorphic(
            style: NeumorphicStyle(intensity: 0.85),
            margin: EdgeInsets.all(4),
            child: Container(
              height: 75,
              child: buildCard(card),
            )));
  }

  // ^ Method Creates Card Widget ^ //
  Widget buildCard(CardModel card) {
    switch (card.type) {
      case CardType.File:
        return _buildMediaItem(card.metadata);
        break;
      case CardType.Contact:
        return _buildContactItem(card.contact);
        break;
      case CardType.Image:
        return _buildMediaItem(card.metadata);
        break;
    }
    return Container();
  }

  // @ Method Builds Media Content from Metadata ^ //
  Widget _buildMediaItem(Metadata metadata) {
    return Hero(
      tag: metadata.id,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SonrText.normal(metadata.mime.type.toString()),
        SonrText.normal("Owner: " + metadata.owner.firstName),
        Image.memory(metadata.thumbnail)
      ]),
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
