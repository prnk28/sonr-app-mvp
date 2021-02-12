import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
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
            child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                      suggestion: SonrSearchFieldCardSuggestion(),
                    )),
              ),
              Spacer()
            ])));
  }
}

class SonrSearchFieldCardSuggestion extends GetView<SearchDialogController> {
  SonrSearchFieldCardSuggestion({Key key}) : super(key: key);
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
              if (controller.foundSuggestion.value) {
                controller.navigateToSuggestion(controller.suggestion.value);
              }
            },
            child: controller.foundSuggestion.value
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

class SearchDialogController extends GetxController {
  // Properties
  final foundSuggestion = false.obs;
  final searchText = "".obs;
  final searchResults = Map<QueryType, List<TransferCard>>().obs;
  final suggestion = Rx<TransferCard>();

  // References
  QueryType _minQueryType;
  int _lowestQueryCount = 9223372036854775807;

  textFieldChanged(String query) {
    searchText(query);
  }

  // ^ Query Text Field ^ //
  SearchDialogController() {
    // Query for All Rows
    searchText.listen((text) {
      // Query Categories
      Get.find<SQLService>().search(text).then((r) => searchResults(r));

      // Find Suggestions
      searchResults.forEach((type, result) {
        if (result.length < _lowestQueryCount && result.length > 0) {
          _minQueryType = type;
          _lowestQueryCount = result.length;
          foundSuggestion(true);
        }
      });

      // Set Optimal Suggestion
      if (foundSuggestion.value) {
        suggestion(searchResults[_minQueryType].last);
      }
    });
  }

  navigateToSuggestion(TransferCard card) {
    print(card.id.toString() + " has been tapped");
    Get.find<HomeController>().jumpToCard(card);
    HapticFeedback.mediumImpact();
  }
}
