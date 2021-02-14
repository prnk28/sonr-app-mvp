import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sonr_app/data/model_search.dart';
import 'package:sonr_app/data/tuple.dart';
import 'package:sonr_app/service/sql_service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

import 'home_controller.dart';

class SearchDialog extends GetView<SearchCardController> {
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
                        suggestion: _SonrSearchCardSuggestion(),
                      )),
                ),
                Spacer()
              ]),
              Align(alignment: Alignment.bottomCenter, child: _SonrSearchCardListView()),
            ])));
  }
}

// ** Class For TransferCard Searched Suggestion Widget ** //
class _SonrSearchCardSuggestion extends GetView<SearchCardController> {
  _SonrSearchCardSuggestion({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Extract Data
      var suggestedCard = controller.suggestion.value.item2;
      var suggestedCardCategory = controller.suggestion.value.item1;
      print(suggestedCardCategory);

      // Build View
      if (controller.searchText.value.length > 0) {
        return Container(
          width: 75,
          height: 42,
          child: NeumorphicButton(
              padding: EdgeInsets.all(0),
              style: SonrStyle.cardItem,
              onPressed: () {
                if (controller.hasSuggestion.value) {
                  controller.navigateToCard(suggestedCard);
                }
              },
              child: controller.hasSuggestion.value
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
      return AnimatedContainer(
        duration: 1.seconds,
        width: controller.cardCount.value >= 1 ? Get.width - 20 : 0,
        height: controller.cardCount.value >= 1 ? 4000 : 0,
        child: ListView.separated(
          itemCount: controller.cardCount.value,
          itemBuilder: (context, index) {
            // Retreive Data
            return _SonrSearchCardListItem(controller.results[index]);
          },
          separatorBuilder: (context, index) {
            // Retreive Data
            if (index > 0) {
              var lastResult = controller.results[index - 1];
              var result = controller.results[index];
              if (result.item1 != lastResult.item1) {
                return Divider();
              }
            }
            return Container();
          },
        ),
      );
    });
  }
}

// ** Class For TransferCard Searched ListItem Widget ** //
class _SonrSearchCardListItem extends GetView<SearchCardController> {
  final Tuple<String, TransferCard> item;
  _SonrSearchCardListItem(this.item, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Extract Data
    var card = item.item2;
    var category = item.item1;
    print(category);

    // Build View
    return Obx(() {
      if (controller.searchText.value.length == 0) {
        return Container();
      }

      // Build View
      return GestureDetector(
        onTap: () {
          controller.navigateToCard(card);
        },
        child: Container(
          height: 125,
          child: Neumorphic(
              padding: EdgeInsets.all(0),
              style: SonrStyle.cardItem,
              child: controller.hasSuggestion.value
                  ? controller.suggestion.value.item2.payload == Payload.MEDIA
                      ? Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: MemoryImage(
                                    Uint8List.fromList(controller.suggestion.value.item2.preview),
                                  ))))
                      : Text(controller.suggestion.value.item2.payload.toString())
                  : Container()),
        ),
      );
    });
  }
}

// ** Class For Search Controller ** //
class SearchCardController extends GetxController {
  // Properties
  final searchText = "".obs;
  final cardCount = 0.obs;
  final hasSuggestion = false.obs;
  final suggestion = Rx<Tuple<String, TransferCard>>();
  final results = RxList<Tuple<String, TransferCard>>();

  textFieldChanged(String query) {
    searchText(query);
  }

  // ^ Query Text Field ^ //
  SearchCardController() {
    // @ Listen to Current Text
    searchText.listen((text) {
      Get.find<SQLService>().search(text).then((r) {
        cardCount(r.count);
        hasSuggestion(r.hasSuggestion);
        suggestion(r.suggestion);
        results(r.results);
      });
    });
  }

  // ^ Method to Push to Selected Card ^ //
  navigateToCard(TransferCard card) {
    Get.find<HomeController>().jumpToCard(card);
    HapticFeedback.mediumImpact();
  }
}
