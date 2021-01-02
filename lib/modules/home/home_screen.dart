import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonar_app/modules/home/share_button.dart';
import 'package:sonar_app/modules/home/transfer_item.dart';
import 'package:sonar_app/theme/theme.dart';
import 'home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    // Build View
    return SonrTheme(
        child: Scaffold(
            backgroundColor: NeumorphicTheme.baseColor(context),
            appBar: SonrAppBar.leadingWithAction(
                "Home",
                // Leading Profile
                SonrButton.appBar(
                  SonrIcon.profile,
                  () => Get.offNamed("/profile"),
                ),

                // Action Search
                SonrButton.appBar(
                  SonrIcon.search,
                  () => print("Search"),
                )),
            floatingActionButton: ShareButton(),
            body: GestureDetector(
                onTap: () => controller.toggleExpand, child: _HomeView())));
  }
}

class _HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
          onTap: () {
            if (controller.isShareExpanded.value) {
              controller.toggleExpand();
            }
          },
          child: GridView.builder(
              padding: EdgeInsets.only(left: 4, right: 4, bottom: 20, top: 2),
              itemCount: controller.allCards.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 4),
              itemBuilder: (context, idx) {
                // Generate File Cell
                return TransferItem(controller.allCards[idx]);
              }));
    });
  }
}
