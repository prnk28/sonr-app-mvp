import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonar_app/data/card_model.dart';
import 'package:sonar_app/modules/card/card_controller.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:flutter/widgets.dart';
import 'package:sonr_core/models/models.dart';

import 'card_hero.dart';

class CardPopup extends StatelessWidget {
  final CardModel card;
  CardPopup(this.card, {Key key}) : super(key: key);

  factory CardPopup.metadata(Metadata meta) {
    CardController controller = Get.find();
    return CardPopup(controller.addFile(meta));
  }

  factory CardPopup.contact(Contact contact) {
    CardController controller = Get.find();
    return CardPopup(controller.addContact(contact));
  }

  @override
  Widget build(BuildContext context) {
    // ^ Build Neumorphic View ^ //
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 45, bottom: 65),
        child: Neumorphic(
            style: SonrBorderStyle(),
            child: Column(
              children: [
                // Some Space
                Padding(padding: EdgeInsets.all(25)),

                // Top Right Close/Cancel Button
                closeButton(() => Get.back()),
                Padding(padding: EdgeInsets.only(top: 10)),

                // Image
                FittedBox(
                    alignment: Alignment.center,
                    child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: 1,
                          minHeight: 1,
                        ),
                        child: Container(child: _buildMedia(card.meta)))),
              ],
            )));
  }

  // ^ Build Media View ^ //
  _buildMedia(Metadata m) {
    switch (m.mime.type) {
      // @ Image Redirects to Hero View
      case MIME_Type.image:
        return Hero(
            tag: m.name,
            child: GestureDetector(
                onTap: () {
                  Get.off(CardHeroView.fromCard(card));
                },
                child: Image.file(File(card.meta.path))));
        break;
      case MIME_Type.video:
        break;
    }
  }
}
