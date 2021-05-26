import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonr_app/modules/card/card.dart';
import 'package:sonr_app/style/style.dart';

/// @ QuickAccessScreen from Home
class QuickAccessScreen extends StatelessWidget {
  final TransferItemsType type;
  const QuickAccessScreen({Key? key, required this.type}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SonrScaffold(
        gradient: SonrGradients.NightCall,
        appBar: DesignAppBar(
          centerTitle: true,
          leading: ActionButton(icon: SonrIcons.Backward.gradient(value: SonrGradients.PhoenixStart), onPressed: () => Get.back(closeOverlays: true)),
          subtitle: type.subtitle(),
          title: type.title(),
        ),
        body: CardsGridView(type: type));
  }
}
