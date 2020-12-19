import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonar_app/data/card_model.dart';
import 'package:sonar_app/theme/theme.dart';

import 'card_controller.dart';

class CardView extends GetView<CardController> {
  final CardModel card;
  CardView(this.card);

  @override
  Widget build(BuildContext context) {
    // File
    if (card.type == CardType.File) {
      return _MediaItemView(card);
    }
    // Contact
    else {
      return _ContactItemView();
    }
  }
}

// ^ Media File Item View ^ //
class _MediaItemView extends StatelessWidget {
  final CardModel card;
  _MediaItemView(this.card);

  @override
  Widget build(BuildContext context) {
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
                        normalText(card.meta.name),
                        normalText(card.meta.mime.type.toString()),
                        normalText("Owner: " + card.meta.owner.firstName),
                      ]),
                )));
      },
    );
  }
}

// ^ Contact Item View ^ //
class _ContactItemView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container();
  }
}
