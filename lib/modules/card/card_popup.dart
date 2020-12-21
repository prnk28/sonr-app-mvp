import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sonar_app/data/card_model.dart';
import 'package:sonr_core/models/models.dart';
import 'package:sonar_app/theme/theme.dart';
import 'card_controller.dart';

class CardPopup extends GetView<CardController> {
  // Properties
  final bool fromTransfer;
  final CardModel data;

  // ** Constructer ** //
  CardPopup(this.fromTransfer, this.data);

  factory CardPopup.fromTransferMetadata(Metadata m) {
    return CardPopup(true, CardModel.fromMetadata(m));
  }

  // ** Metadata Popup ** //
  factory CardPopup.fromTransferContact(Contact c) {
    return CardPopup(true, CardModel.fromContact(c));
  }

  // ** Contact Popup ** //
  factory CardPopup.fromItem(CardModel card) {
    return CardPopup(false, card);
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
      if (data.metadata != null) {
        popupView = _ImagePopupView(data.metadata);
      }
    }

    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 45, bottom: 105),
        child: Neumorphic(
            style: SonrBorderStyle(),
            child: Column(children: [
              // @ Top Right Close/Cancel Button
              closeButton(() {
                // Pop Window
                Get.back();
              }, padTop: 8, padRight: 8),

              // @ Invite View
              Padding(padding: EdgeInsets.all(8)),
              popupView
            ])));
  }
}

// ^ Contact Popup View ^ //
class _ContactPopupView extends GetView<CardController> {
  final Contact contact;
  _ContactPopupView(this.contact);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // Display Info
    return Column(children: [
      // @ Basic Contact Info - Make Expandable
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Padding(padding: EdgeInsets.all(8)),
        Column(
          children: [
            boldText(contact.firstName),
            boldText(contact.lastName),
          ],
        )
      ]),

      // @ Save Button
      rectangleButton("Save", () {
        controller.acceptContact(contact, false);
        Get.back();
      }),
    ]);
  }
}

// ^ Image Popup View ^ //
class _ImagePopupView extends StatelessWidget {
  final Metadata meta;

  const _ImagePopupView(this.meta, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
                                tag: meta.name,
                                child: GestureDetector(
                                    onTap: () {
                                      Get.dialog(CardPhotoView.fromMeta(meta),
                                          barrierDismissible: false,
                                          useSafeArea: false);
                                    },
                                    child: Image.file(File(meta.path))))))),
              ],
            )));
  }
}

// ^ Media Popup View ^ //
class _MediaPopupView extends StatelessWidget {
  final Metadata meta;

  const _MediaPopupView(this.meta, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
                        child: Container(child: Image.file(File(meta.path))))),
              ],
            )));
  }
}

// ^ Card Hero Image View ^ //
class CardPhotoView extends StatelessWidget {
  CardPhotoView(
    this.provider,
    this.tag, {
    this.backgroundDecoration,
  });
  final ImageProvider<Object> provider;
  final Decoration backgroundDecoration;
  final String tag;

  factory CardPhotoView.fromCard(CardModel card) {
    return new CardPhotoView(
        FileImage(File(card.metadata.path)), card.metadata.name);
  }

  factory CardPhotoView.fromMeta(Metadata meta) {
    return new CardPhotoView(FileImage(File(meta.path)), meta.name);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: Get.height,
      ),
      child: Stack(children: [
        PhotoView(
            tightMode: true,
            imageProvider: provider,
            backgroundDecoration: backgroundDecoration,
            heroAttributes: PhotoViewHeroAttributes(tag: tag)),
        closeButton(() => Get.back(), padTop: 35, padRight: 25),
      ]),
    );
  }
}
