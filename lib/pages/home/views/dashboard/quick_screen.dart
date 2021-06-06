import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonr_app/modules/card/card.dart';
import 'package:sonr_app/pages/detail/detail_page.dart';
import 'package:sonr_app/style.dart';

/// @ QuickAccessScreen from Home
class QuickAccessScreen extends StatelessWidget {
  final TransferItemsType type;
  const QuickAccessScreen({Key? key, required this.type}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SonrScaffold(
        appBar: PageAppBar(
          centerTitle: true,
          leading: ActionButton(iconData: SonrIcons.Back, onPressed: () => Get.back(closeOverlays: true)),
          subtitle: type.subtitle(),
          title: type.title(),
        ),
        body: Details.cardsGrid(type));
  }
}
