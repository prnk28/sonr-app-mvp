import 'dart:io';

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
      return ListView.builder(
        itemCount: cards.length,
        itemBuilder: (context, idx) {
          // Get Current Metadata
          CardModel card = cards[idx];

          if (card.type == CardType.File) {
            Metadata metadata = card.meta;
            // Generate Cell
            return GestureDetector(
                onTap: () async {
                  // TODO Utilize Hero Animation
                  // cards.getFile(metadata);
                },
                child: Container(
                  height: 75,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(File(metadata.path)),
                          fit: BoxFit.cover)),
                  child:
                      // Image Info
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        normalText(metadata.name),
                        normalText(metadata.mime.type.toString()),
                        normalText("Owner: " + metadata.owner.firstName),
                      ]),
                ));
          }
          return Container();
        },
      );
    });
  }
}
