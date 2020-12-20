import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sonar_app/data/card_model.dart';
import 'package:sonar_app/modules/home/home_controller.dart';
import 'package:sonr_core/models/models.dart';
import 'package:sonar_app/theme/theme.dart';
import 'card_controller.dart';

class CardPopup extends GetView<CardController> {
  // Properties
  final CardType type;
  final Metadata metadata;
  final Contact contact;

  // ** Constructer ** //
  CardPopup(this.type, {this.metadata, this.contact}) {
    if (type == CardType.File) {}
  }

  // ** Metadata Popup ** //
  factory CardPopup.metadata(Metadata m) {
    // Create Metadata Card
    var card = CardModel.fromMetadata(m);

    // Add to Cards Display Last Card
    Get.find<HomeController>().addCard(card);

    // @ Check Type
    if (m.mime.type == MIME_Type.image) {
      return CardPopup(CardType.Image, metadata: m);
    }
    return CardPopup(CardType.File, metadata: m);
  }

  // ** Contact Popup ** //
  factory CardPopup.contact(Contact c) {
    return CardPopup(CardType.Contact, contact: c);
  }

  @override
  Widget build(BuildContext context) {
    // @ Check Card Type - Contact
    if (type == CardType.Contact) {
      return _ContactPopupView();
    }
    // @ Check Card Type - MediaFile
    else if (type == CardType.File) {
      if (metadata != null) {
        return _MediaPopupView(metadata);
      } else {
        print("Null Metadata in Popup - MediaFile");
        return Container();
      }
    }

    // @ Check Card Type - ImageFile
    else {
      if (metadata != null) {
        return _ImagePopupView(metadata);
      } else {
        print("Null Metadata in Popup - ImageFile");
        return Container();
      }
    }
  }
}

// ^ Contact Popup View ^ //
class _ContactPopupView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container();
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
    return new CardPhotoView(FileImage(File(card.meta.path)), card.meta.name);
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
