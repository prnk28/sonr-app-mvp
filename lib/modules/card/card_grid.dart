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
          padding: EdgeInsets.only(left: 4, right: 4, bottom: 20, top: 2),
          itemCount: cards.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 4),
          itemBuilder: (context, idx) {
            // Get Current Metadata
            CardModel card = cards[idx];

            // Generate File Cell
            if (card.type == CardType.File) {
              // Get Metadata
              return _buildMetadataCard(card.meta);
            }
            return Container();
          });
    });
  }

  // ^ Build a File Based Card ^ //
  Widget _buildMetadataCard(Metadata metadata) {
    return PlayAnimation<double>(
      tween: (0.0).tweenTo(75.0), // <-- specify tween (from 50.0 to 200.0)
      duration: 150.milliseconds,
      delay: 250.milliseconds, // <-- set a duration
      builder: (context, child, value) {
        // <-- use builder function
        return GestureDetector(
            onTap: () async {
              // TODO Utilize Hero Animation
              // cards.getFile(metadata);
            },
            child: Neumorphic(
                style: NeumorphicStyle(intensity: 0.85),
                margin: EdgeInsets.all(4),
                child: Container(
                  height: value,
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
      },
    );
  }
}
