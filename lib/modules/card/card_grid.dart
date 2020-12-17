import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonar_app/data/card_model.dart';
import 'package:sonr_core/models/models.dart';
import 'package:sonar_app/theme/theme.dart';

import 'card_controller.dart';

class CardGrid extends GetView<CardController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      List<CardModel> cards = controller.allCards();
      return GridView.builder(
          itemCount: cards.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 5, crossAxisSpacing: 2),
          itemBuilder: (context, idx) {
            // Get Current Metadata
            CardModel card = cards[idx];

            // Generate File Cell
            if (card.type == CardType.File) {
              // Get Metadata
              Metadata metadata = card.meta;
              return GestureDetector(
                  onTap: () async {
                    // TODO Utilize Hero Animation
                    // cards.getFile(metadata);
                  },
                  child: Neumorphic(
                      margin: EdgeInsets.all(2),
                      child: Container(
                        height: 75,
                        child:
                            // Image Info
                            Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              normalText(metadata.name),
                              normalText(metadata.mime.type.toString()),
                              normalText("Owner: " + metadata.owner.firstName),
                            ]),
                      )));
            }
            return Container();
          });
    });
  }
}
