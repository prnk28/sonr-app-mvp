import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonar_app/data/model_card.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'home_controller.dart';

class HomeCardItem extends GetView<HomeController> {
  final CardModel card;
  HomeCardItem(this.card);

  @override
  Widget build(BuildContext context) {
    // File
    if (card.type == CardType.File || card.type == CardType.Image) {
      return _MediaItemView(card.metadata);
    }
    // Contact
    else {
      return _ContactItemView(card.contact);
    }
  }
}

// ^ Media File Item View ^ //
class _MediaItemView extends StatelessWidget {
  final Metadata metadata;
  _MediaItemView(this.metadata);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {},
        child: Neumorphic(
            style: NeumorphicStyle(intensity: 0.85),
            margin: EdgeInsets.all(4),
            child: Container(
              height: 75,
              child:
                  // Image Info
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                     SonrText.normal(metadata.name),
                     SonrText.normal(metadata.mime.type.toString()),
                     SonrText.normal("Owner: " + metadata.owner.firstName),
                  ]),
            )));
  }
}

// ^ Contact Item View ^ //
class _ContactItemView extends StatelessWidget {
  final Contact contact;
  _ContactItemView(this.contact);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {},
        child: Neumorphic(
            style: NeumorphicStyle(intensity: 0.85),
            margin: EdgeInsets.all(4),
            child: Container(
              height: 75,
              child:
                  // Image Info
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                     SonrText.normal(contact.firstName),
                     SonrText.normal(contact.lastName),
                  ]),
            )));
  }
}
