import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonar_app/data/card_model.dart';
import 'package:sonr_core/models/models.dart';
import 'package:sonar_app/theme/theme.dart';
import 'card_controller.dart';

class CardView extends GetView<CardController> {
  // Properties
  final bool fromTransfer;
  final CardModel data;

  // ** Constructer ** //
  CardView(this.fromTransfer, this.data);

  factory CardView.fromTransferMetadata(Metadata m) {
    return CardView(true, CardModel.fromMetadata(m));
  }

  // ** Metadata Popup ** //
  factory CardView.fromTransferContact(Contact c) {
    return CardView(true, CardModel.fromContact(c));
  }

  // ** Contact Popup ** //
  factory CardView.fromItem(CardModel card) {
    return CardView(false, card);
  }

  @override
  Widget build(BuildContext context) {
    // Initialize
    Widget popupView = Container();

    // @ Check Card Type - Contact
    if (data.type == CardType.Contact) {
      popupView = _ContactPopupView(data.contact);
    }
    // @ Check Card Type - MediaFile
    else if (data.type == CardType.File) {
      if (data.metadata != null) {
        popupView = _MediaPopupView(data.metadata);
      }
    }

    // @ Check Card Type - ImageFile
    else {
      popupView = Container();
    }

    return NeumorphicBackground(
      child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 45, bottom: 105),
          child: Neumorphic(
              child: Column(children: [
            // @ Top Right Close/Cancel Button
            closeButton(() {
              // Pop Window
              Get.back();
            }, padTop: 8, padRight: 8),

            // @ Invite View
            Padding(padding: EdgeInsets.all(8)),
            popupView
          ]))),
    );
  }
}

// ^ Contact Popup View ^ //
class _ContactPopupView extends GetView<CardController> {
  final Contact contact;
  _ContactPopupView(this.contact);
  @override
  Widget build(BuildContext context) {
    // Display Info
    return Column(children: [
      // @ Basic Contact Info - Make Expandable
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(padding: EdgeInsets.all(8)),
        Column(
          children: [
            SonrText.bold(contact.firstName),
            SonrText.bold(contact.lastName),
          ],
        )
      ]),

      // @ Save Button
      rectangleButton("Keep", () {
        controller.acceptContact(contact, false);
        Get.back();
      }),
    ]);
  }
}

// ^ Media Popup View ^ //
class _MediaPopupView extends StatelessWidget {
  final Metadata meta;

  const _MediaPopupView(this.meta, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // @ Non-Image Type
    return NeumorphicBackground(
      child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 45, bottom: 65),
          child: Neumorphic(
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
                      child: Container(child: Image.file(File(meta.path))))),
            ],
          ))),
    );
  }
}
