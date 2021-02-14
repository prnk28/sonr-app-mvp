import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sonr_app/service/sql_service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

import 'home_controller.dart';

class SearchDialog extends GetView<SearchCardController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedContainer(
          margin: controller.viewMargin.value,
          duration: 400.milliseconds,
          child: NeumorphicBackground(
              borderRadius: BorderRadius.circular(30),
              backendColor: Colors.transparent,
              child: Neumorphic(
                style: NeumorphicStyle(color: K_BASE_COLOR),
                child: Container(
                  child: Column(children: [
                    Neumorphic(
                        style: NeumorphicStyle(color: K_BASE_COLOR),
                        child: Container(
                          width: Get.width - 60,
                          margin: EdgeInsets.only(left: 10, right: 10),
                          child: Container(
                            height: 160,
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
                                      suggestion: _SonrSearchCardSuggestion(),
                                    )),
                              ),
                              Spacer()
                            ]),
                          ),
                        )),
                    _SonrSearchCardListView(),
                  ]),
                ),
              )),
        ));
  }
}

// ** Class For TransferCard Searched Suggestion Widget ** //
class _SonrSearchCardSuggestion extends GetView<SearchCardController> {
  _SonrSearchCardSuggestion({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //var expandedMargin = ;
    return Obx(() {
      if (controller.searchText.value.length > 0) {
        // Extract Data
        var suggestedCard = controller.suggestion.value;

        // Build View
        return Container(
          width: 75,
          height: 42,
          child: NeumorphicButton(
              padding: EdgeInsets.all(0),
              style: SonrStyle.cardItem,
              onPressed: () {
                if (controller.hasResults.value) {
                  controller.navigateToCard(suggestedCard);
                }
              },
              child: controller.hasResults.value
                  ? suggestedCard.payload == Payload.MEDIA
                      ? _buildPhotoSuggestedView(suggestedCard)
                      : _buildOtherSuggestedView(suggestedCard)
                  : Container()),
        );
      }

      return Container();
    });
  }

  _buildPhotoSuggestedView(TransferCard suggestedCard) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: MemoryImage(
                  Uint8List.fromList(suggestedCard.preview),
                ))));
  }

  _buildOtherSuggestedView(TransferCard suggestedCard) {
    return Text(suggestedCard.payload.toString());
  }
}

// ** Class For TransferCard Results ListView Widget ** //
class _SonrSearchCardListView extends GetView<SearchCardController> {
  _SonrSearchCardListView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.hasResults.value
          ? Neumorphic(
              style: SonrStyle.indented,
              child: ListView.builder(
                itemCount: controller.cardCount.value,
                itemBuilder: (context, index) {
                  // Retreive Data
                  return _SonrSearchCardListItem(controller.results[index].first);
                },
              ),
            )
          : Container();
    });
  }
}

// ** Class For TransferCard Searched ListItem Widget ** //
class _SonrSearchCardListItem extends GetView<SearchCardController> {
  final TransferCard card;
  _SonrSearchCardListItem(this.card, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Build View
    return GestureDetector(
      onTap: () {
        controller.navigateToCard(card);
      },
      child: Container(
        height: 125,
        width: Get.width - 20,
        child: Row(children: [
          SonrIcon.preview(
            IconType.Gradient,
            card,
            size: 40,
          )
        ]),
      ),
    );
  }
}

// ** Class For Search Controller ** //
class SearchCardController extends GetxController {
  // Properties
  final searchText = "".obs;
  final cardCount = 0.obs;
  final hasResults = false.obs;
  final suggestion = Rx<TransferCard>();
  final results = Map<QueryCategory, List<TransferCard>>().obs;
  final viewMargin = EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 572).obs;

  // References
  int _lowestQueryCount = 9223372036854775807;
  QueryCategory _minQueryType;

  textFieldChanged(String query) {
    searchText(query);
  }

  // ^ Query Text Field ^ //
  SearchCardController() {
    // @ Listen to Current Text
    // Query for All Rows
    searchText.listen((text) {
      // Query Categories
      Get.find<SQLService>().search(text).then((r) => results(r));

      // Check Results
      if (results.length > 0) {
        hasResults(true);
        viewMargin(EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 200));
      } else {
        hasResults(false);
        viewMargin(EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 572));
      }

      // Find Suggestions
      results.forEach((type, result) {
        if (result.length < _lowestQueryCount && result.length > 0) {
          _minQueryType = type;
          _lowestQueryCount = result.length;
        }
      });

      // Set Optimal Suggestion
      if (hasResults.value) {
        suggestion(results[_minQueryType].last);
      }
    });
  }

  // ^ Method to Push to Selected Card ^ //
  navigateToCard(TransferCard card) {
    Get.find<HomeController>().jumpToCard(card);
    HapticFeedback.mediumImpact();
  }
}
