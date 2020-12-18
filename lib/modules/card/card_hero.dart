import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sonar_app/data/card_model.dart';
import 'package:sonar_app/theme/theme.dart';

class CardHeroView extends StatelessWidget {
  CardHeroView(
    this.provider,
    this.tag, {
    this.backgroundDecoration,
  });
  final ImageProvider<Object> provider;
  final Decoration backgroundDecoration;
  final String tag;

  factory CardHeroView.fromCard(CardModel card) {
    return new CardHeroView(FileImage(File(card.meta.path)), card.meta.name);
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
