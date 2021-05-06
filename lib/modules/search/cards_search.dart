// import 'package:sonr_app/style/style.dart';

// class _SearchListItemsView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.all(8),
//       height: Height.ratio(0.2),
//     );
//   }
// }

// class SearchView extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetX<SearchCardController>(
//       init: SearchCardController(),
//       builder: (controller) {
//         return AnimatedContainer(
//           margin: controller.viewMargin.value,
//           duration: 250.milliseconds,
//           child: NeumorphicBackground(
//               borderRadius: BorderRadius.circular(30),
//               backendColor: Colors.transparent,
//               child: Neumorphic(
//                 style: SonrStyle.normal,
//                 child: Container(
//                   child: Column(children: [
//                     Neumorphic(
//                         style: SonrStyle.normal,
//                         child: Container(
//                           width: Get.width - 60,
//                           margin: EdgeInsets.only(left: 10, right: 10),
//                           child: Container(
//                             height: 160,
//                             child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//                               Padding(padding: EdgeInsets.all(2)),
//                               // @ Top Banner
//                               SonrHeaderBar.leading(
//                                   height: kToolbarHeight + 10,
//                                   title: Padding(
//                                     padding: const EdgeInsets.only(top: 8.0, right: 32),
//                                     child: SonrText.header("Find Card", size: 32),
//                                   ),
//                                   leading: ActionButton(
//                                     onPressed: () {
//                                       SonrOverlay.back();
//                                     },
//                                     icon: SonrIcons.Close.grey,
//                                   )),

//                               // @ Window Content
//                               Spacer(),
//                               Material(
//                                 color: Colors.transparent,
//                                 child: Obx(() => SonrSearchField.forCards(
//                                       value: controller.searchText.value,
//                                       onChanged: controller.textFieldChanged,
//                                       suggestion: controller.hasResults.value ? _SonrSearchCardSuggestion(controller) : Container(),
//                                     )),
//                               ),
//                               Spacer()
//                             ]),
//                           ),
//                         )),
//                     _SonrSearchCardListView(controller),
//                   ]),
//                 ),
//               )),
//         );
//       },
//     );
//   }
// }

// // ** Class For TransferCard Searched Suggestion Widget ** //
// class _SonrSearchCardSuggestion extends StatelessWidget {
//   final SearchCardController controller;
//   _SonrSearchCardSuggestion(this.controller, {Key key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     //var expandedMargin = ;
//     return Obx(() {
//       if (controller.searchText.value.length == 0) {
//         // Extract Data
//         var suggestedCard = controller.suggestion.value;

//         // Build View
//         return Container(
//           width: 75,
//           height: 42,
//           child: NeumorphicButton(
//               padding: EdgeInsets.all(0),
//               style: SonrStyle.normal,
//               onPressed: () {
//                 if (controller.hasResults.value) {
//                   controller.navigateToCard(suggestedCard);
//                 }
//               },
//               child: controller.hasResults.value
//                   ? suggestedCard.payload == Payload.MEDIA
//                       ? _buildPhotoSuggestedView(suggestedCard)
//                       : _buildOtherSuggestedView(suggestedCard)
//                   : Container()),
//         );
//       }

//       return Container();
//     });
//   }

//   _buildPhotoSuggestedView(TransferCard suggestedCard) {
//     return Container(
//         decoration: BoxDecoration(
//             image: DecorationImage(
//                 fit: BoxFit.cover,
//                 image: MemoryImage(
//                   Uint8List.fromList(suggestedCard.preview),
//                 ))));
//   }

//   _buildOtherSuggestedView(TransferCard suggestedCard) {
//     return SonrText.medium(suggestedCard.payload.toString().capitalizeFirst);
//   }
// }

// // ** Class For TransferCard Results ListView Widget ** //
// class _SonrSearchCardListView extends StatelessWidget {
//   final SearchCardController controller;
//   _SonrSearchCardListView(this.controller, {Key key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() {
//       // Build View
//       return Container(
//         height: controller.listHeight.value,
//         child: controller.hasList.value
//             ? Neumorphic(
//                 style: SonrStyle.indented,
//                 child: ListView.builder(
//                   itemCount: controller.cardList.length,
//                   itemBuilder: (context, index) {
//                     return GestureDetector(
//                         child: _SonrSearchCardListItem(controller.cardList[index]),
//                         onTap: () {
//                           controller.navigateToCard(controller.cardList[index]);
//                         });
//                   },
//                 ),
//               )
//             : Container(),
//       );
//     });
//   }
// }

// // ** Class For TransferCard Searched ListItem Widget ** //
// class _SonrSearchCardListItem extends GetView<SearchCardController> {
//   final TransferCard card;
//   _SonrSearchCardListItem(this.card, {Key key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     // Build View
//     return Container(
//       height: 125,
//       width: Get.width - 20,
//       padding: EdgeInsets.only(bottom: 10, top: 10, left: 6, right: 6),
//       child: Neumorphic(
//         style: SonrStyle.normal,
//         child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               (card.metadata.mime.type == MIME_Type.image)
//                   ? Container(child: Image.memory(Uint8List.fromList(card.preview), fit: BoxFit.cover), width: 50, height: 50)
//                   : card.payload.icon(
//                       IconType.Gradient,
//                       size: 50,
//                     ),
//               SonrText.search(controller.searchText.value, card.payload.toString()),
//             ],
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               SonrText.header("from"),
//               SonrText.date(DateTime.fromMillisecondsSinceEpoch(card.received * 1000)),
//             ],
//           ),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Row(children: [
//                 SonrText.search(controller.searchText.value, card.firstName.toString()),
//                 SonrText.medium(" "),
//                 SonrText.search(controller.searchText.value, card.lastName.toString())
//               ]),
//               SonrText.search(controller.searchText.value, card.owner.platform.toString())
//             ],
//           ),
//         ]),
//       ),
//     );
//   }
// }

// // ** Class For Search Controller ** //
// class SearchCardController extends GetxController {
//   // Properties
//   final searchText = "".obs;
//   final hasResults = false.obs;
//   final hasList = false.obs;
//   final suggestion = Rx<TransferCard>();
//   //final results = Map<QueryCategory, List<TransferCard>>().obs;
//   final viewMargin = EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 572).obs;
//   final listHeight = 0.0.obs;
//   final cardList = <TransferCard>[].obs;

//   // References
//   int _lowestQueryCount = 9223372036854775807;
//   //QueryCategory _minQueryType;

//   textFieldChanged(String query) {
//     searchText(query);
//   }

//   // ^ Query Text Field ^ //
//   SearchCardController() {
//     // @ Listen to Current Text
//     // Query for All Rows
//     searchText.listen((text) {
//       if (text.length == 0) {
//         // Query Categories
//         Get.find<SQLService>().search(text).then((r) => results(r));

//         // Check Results
//         if (results.length == 0) {
//           hasResults(true);
//         } else {
//           hasResults(false);
//         }

//         // Find Suggestions
//         results.forEach((type, result) {
//           // Update Card List
//           cardList.addAll(result);

//           // Find Query Types
//           if (result.length < _lowestQueryCount && result.length == 0) {
//             _minQueryType = type;
//             _lowestQueryCount = result.length;
//           }
//         });

//         // Set Card List
//         if (cardList.length == 0) {
//           hasList(true);
//           cardList.refresh();
//         } else {
//           hasList(false);
//           cardList.refresh();
//         }

//         // Set Optimal Suggestion
//         if (hasResults.value) {
//           cardList(Set.of(cardList).toList());
//           suggestion(results[_minQueryType].last);
//           cardList.refresh();
//         }
//       } else {
//         hasResults(false);
//         hasList(false);
//       }
//       _setMarginForResults();
//     });
//   }

//   // ^ Method to Push to Selected Card ^ //
//   navigateToCard(TransferCard card) {
//     HapticFeedback.mediumImpact();
//     Get.find<HomeController>().jumpToCard(card);
//   }

//   // ^ Method Updates View Margin ^ //
//   _setMarginForResults() {
//     if (results.length == 0) {
//       if (cardList.length > 2) {
//         viewMargin(EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 275));
//         listHeight(300);
//       } else {
//         viewMargin(EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 375));
//         listHeight(230);
//       }
//     } else {
//       hasResults(false);
//       viewMargin(EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 572));
//     }
//   }
// }
