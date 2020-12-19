import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonar_app/data/card_model.dart';
import 'package:sonr_core/models/models.dart';
import 'package:sonar_app/theme/theme.dart';

import 'card_controller.dart';
import 'card_photo.dart';

class CardView extends GetView<CardController> {
  final CardModel card;
  final bool isPopup;
  CardView(this.card, {this.isPopup = false}) {
    // @ Check if Popup
    if (isPopup) {
      // Contact
      if (card.type == CardType.Contact) {
        controller.saveContact(card.contact);
      }
      // File
      else if (card.type == CardType.File) {}
    }
  }

  factory CardView.popupMeta(Metadata meta) {
    CardController controller = Get.find();
    return CardView(controller.saveFile(meta), isPopup: true);
  }

  factory CardView.popupContact(Contact contact) {
    CardController controller = Get.find();
    return CardView(controller.saveContact(contact), isPopup: true);
  }

  @override
  Widget build(BuildContext context) {
    // ** Constructer returns Card based on View Status ** //
    if (isPopup) {
      return buildPopup(context);
    } else {
      return buildItem(context);
    }
  }

  // ^ Build Popup View ^ //
  Widget buildPopup(BuildContext context) {
    // ** File Type ** //
    if (card.type == CardType.File) {
      if (card.meta.mime.type == MIME_Type.image) {
        // @ Image Type Type
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
                            child: Container(
                                child: Hero(
                                    tag: card.meta.name,
                                    child: GestureDetector(
                                        onTap: () {
                                          Get.dialog(
                                              CardPhotoView.fromCard(card),
                                              barrierDismissible: false,
                                              useSafeArea: false);
                                        },
                                        child: Image.file(
                                            File(card.meta.path))))))),
                  ],
                )));
      } else {
        // @ Non-Image Type
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
                            child: Container(
                                child: Image.file(File(card.meta.path))))),
                  ],
                )));
      }
    }
    // ** Contact Type ** //
    else {
      return Container();
    }
  }

  // ^ Build Item View ^ //
  Widget buildItem(BuildContext context) {
    // ** File Type ** //
    if (card.type == CardType.File) {
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
    // ** Contact Type ** //
    else {
      return Container();
    }
  }
}
