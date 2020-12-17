import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sonar_app/data/card_model.dart';

class CardHeroView extends StatelessWidget {
  const CardHeroView(
    this.card, {
    this.backgroundDecoration,
    this.minScale,
    this.maxScale,
  });

  final CardModel card;
  final Decoration backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(
        height: MediaQuery.of(context).size.height,
      ),
      child: PhotoView(
        imageProvider: FileImage(File(card.meta.path)),
        backgroundDecoration: backgroundDecoration,
        minScale: minScale,
        maxScale: maxScale,
        heroAttributes: PhotoViewHeroAttributes(tag: card.meta.name),
      ),
    );
  }
}
