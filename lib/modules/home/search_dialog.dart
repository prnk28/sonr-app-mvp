import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sonr_app/data/model_search.dart';
import 'package:sonr_app/service/sql_service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

import 'home_controller.dart';

class SearchDialog extends GetView<SearchDialogController> {
  @override
  Widget build(BuildContext context) {
    return Neumorphic(
        style: NeumorphicStyle(color: K_BASE_COLOR),
        child: Container(
            width: Get.width - 60,
            margin: EdgeInsets.only(left: 10, right: 10),
            child: Stack(children: [
              Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Padding(padding: EdgeInsets.all(2)),
                // @ Top Banner
                SonrHeaderBar.leading(
                    height: kToolbarHeight + 10,
                    title: Padding(
                      padding: const EdgeInsets.only(top: 8.0, right: 32),
                      child: SonrText.header("Find Card", size: 32),
                    ),
                    leading: SonrButton.circle(
                      onPressed: Get.back,
                      icon: SonrIcon.close,
                      padding: const EdgeInsets.only(top: 8),
                    )),

                // @ Window Content
                Spacer(),
                Material(
                  color: Colors.transparent,
                  child: Obx(() => SonrSearchField.forCards(
                        value: controller.searchText.value,
                        onChanged: controller.textFieldChanged,
                        suggestion: _SonrSearchFieldCardSuggestion(),
                      )),
                ),
                Spacer()
              ]),
              Align(alignment: Alignment.bottomCenter, child: _SonrSearchFieldCardListView()),
            ])));
  }
}

class _SonrSearchFieldCardSuggestion extends GetView<SearchDialogController> {
  _SonrSearchFieldCardSuggestion({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.searchText.value.length == 0) {
        return Container();
      }

      // Build View
      return Container(
        width: 75,
        height: 42,
        child: NeumorphicButton(
            padding: EdgeInsets.all(0),
            style: SonrStyle.cardItem,
            onPressed: () {
              if (controller.hasSuggestion.value) {
                controller.navigateToCard(controller.suggestion.value);
              }
            },
            child: controller.hasSuggestion.value
                ? controller.suggestion.value.payload == Payload.MEDIA
                    ? Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: MemoryImage(
                                  Uint8List.fromList(controller.suggestion.value.preview),
                                ))))
                    : Text(controller.suggestion.value.payload.toString())
                : Container()),
      );
    });
  }
}

class _SonrSearchFieldCardListView extends GetView<SearchDialogController> {
  _SonrSearchFieldCardListView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return AnimatedContainer(
        duration: 1.seconds,
        width: controller.cardCount.value >= 1 ? Get.width - 20 : 0,
        height: controller.cardCount.value >= 1 ? 4000 : 0,
        child: ListView.separated(
          itemCount: controller.cardCount.value,
          itemBuilder: (context, index) {
            // Retreive Data
          },
          separatorBuilder: (context, index) {
            // Retreive Data
          },
        ),
      );
    });
  }
}

class SearchDialogController extends GetxController {
  // Properties
  final searchText = "".obs;
  final cardCount = 0.obs;
  final hasSuggestion = false.obs;
  final searchResults = Rx<QueryCardResult>();
  final suggestion = Rx<TransferCard>();

  textFieldChanged(String query) {
    searchText(query);
  }

  // ^ Query Text Field ^ //
  SearchDialogController() {
    // @ Listen to Current Text
    searchText.listen((text) {
      Get.find<SQLService>().search(text).then((r) {
        cardCount(r.count);
        hasSuggestion(r.hasSuggestion);
        suggestion(r.suggestion.item2);
        searchResults(r);
      });
    });
  }

  // ^ Method to Push to Selected Card ^ //
  navigateToCard(TransferCard card) {
    Get.find<HomeController>().jumpToCard(card);
    HapticFeedback.mediumImpact();
  }
}
