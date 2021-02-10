import 'package:get/get.dart';
import 'package:sonr_app/service/sql_service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

class SearchDialog extends GetView<SearchDialogController> {
  @override
  Widget build(BuildContext context) {
    return NeumorphicBackground(
        margin: EdgeInsets.only(left: 20, right: 20, top: 100, bottom: 420),
        borderRadius: BorderRadius.circular(20),
        backendColor: Colors.transparent,
        child: Neumorphic(
            style: NeumorphicStyle(color: K_BASE_COLOR),
            child: Container(
                width: Get.width - 60,
                margin: EdgeInsets.only(left: 10, right: 10),
                child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  // @ Top Banner
                  SonrHeaderBar.leading(
                      title: SonrText.header("Search", size: 24),
                      leading: SonrButton.close(() {
                        Get.back();
                      })),

                  // @ Window Content
                  Spacer(),
                  Material(
                    color: Colors.transparent,
                    child: SonrTextField(
                        hint: "Search here..", label: "Find a Card", value: controller.searchText.value, onChanged: controller.textFieldChanged),
                  ),
                  Spacer()
                ]))));
  }
}

class SearchDialogController extends GetxController {
  final searchText = "".obs;
  final searchResults = Map<QueryType, List<TransferCard>>().obs;

  textFieldChanged(String query) {
    searchText(query);
  }

  // ^ Query Text Field ^ //
  SearchDialogController() {
    // Query for All Rows
    searchText.listen((text) {
      print("Search text: $text");
      // Query Categories
      Get.find<SQLService>().search(text).then((r) => searchResults(r));

      // Logging
      searchResults.forEach((type, result) {
        print("$type based Card Results: ${result.length}");
      });
    });
  }
}