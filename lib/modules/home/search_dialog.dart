import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';

class SearchDialog extends GetView<SearchDialogController> {
  @override
  Widget build(BuildContext context) {
    return NeumorphicBackground(
        margin: EdgeInsets.only(left: 20, right: 20, top: 100, bottom: 200),
        borderRadius: BorderRadius.circular(20),
        backendColor: Colors.transparent,
        child: Neumorphic(
            style: NeumorphicStyle(color: K_BASE_COLOR),
            child: Container(
                width: Get.width - 60,
                height: 80,
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
                        hint: "Search here..", label: "Find a Card", value: controller.searchValue.value, onChanged: controller.textFieldChanged),
                  ),
                  Spacer()
                ]))));
  }
}

class SearchDialogController extends GetxController {
  final searchValue = "".obs;
  textFieldChanged(String query) {}
}
