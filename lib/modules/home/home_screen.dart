import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonar_app/modules/home/share_button.dart';
import 'package:sonar_app/theme/theme.dart';
import 'home_controller.dart';
import 'package:flutter/material.dart';
import 'package:sonar_app/data/model_card.dart';
import 'package:sonr_core/sonr_core.dart';

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
                onTap: () => controller.toggleShareExpand,
                child: _HomeView())));
  }
}

// ** Home Screen Content ** //
class _HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      GestureDetector(
        onTap: () => controller.toggleShareExpand,
        child: Container(
          padding: EdgeInsets.only(top: 10),
          margin: EdgeInsets.only(left: 30, right: 30),
          child: Obx(() => NeumorphicToggle(
                selectedIndex: controller.toggleIndex.value,
                onChanged: (val) => controller.toggleIndex(val),
                thumb: Center(child: Obx(() => controller.getToggleCategory())),
                children: [
                  ToggleElement(),
                  ToggleElement(),
                  ToggleElement(),
                  ToggleElement(),
                ],
              )),
        ),
      ),
      Obx(() => GestureDetector(
            onTap: () => controller.toggleShareExpand,
            child: Container(
              padding: EdgeInsets.only(top: 15),
              margin: EdgeInsets.all(10),
              height: 500, // card height
              child: PageView.builder(
                  itemCount: controller.allCards.length,
                  controller: PageController(viewportFraction: 0.7),
                  onPageChanged: (int index) => controller.pageIndex(index),
                  itemBuilder: (_, idx) {
                    return Obx(() {
                      if (idx == controller.pageIndex.value) {
                        return PlayAnimation<double>(
                          tween: (0.85).tweenTo(0.95),
                          duration: 200.milliseconds,
                          builder: (context, child, value) {
                            return Transform.scale(
                              scale: value,
                              child: _TransferItem(controller.allCards[idx]),
                            );
                          },
                        );
                      } else {
                        return Transform.scale(
                          scale: 0.85,
                          child: _TransferItem(controller.allCards[idx]),
                        );
                      }
                    });
                  }),
            ),
          ))
    ]);
  }
}

// ** Home Screen Item ** //
class _TransferItem extends GetView<HomeController> {
  final CardModel card;
  _TransferItem(this.card);

  @override
  Widget build(BuildContext context) {
    // Intialize
    Widget child;
    // File
    if (card.type == CardType.File || card.type == CardType.Image) {
      child = buildMediaItem(card.metadata);
    }
    // Contact
    else {
      child = buildContactItem(card.contact);
    }

    // @ Return View
    return GestureDetector(
        onTap: () async {},
        child: Neumorphic(
            style: NeumorphicStyle(intensity: 0.85),
            margin: EdgeInsets.all(4),
            child: Container(height: 75, child: child)));
  }

  // ^ Method Builds Media Content from Metadata ^ //
  Widget buildMediaItem(Metadata metadata) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SonrText.normal(metadata.mime.type.toString()),
      SonrText.normal("Owner: " + metadata.owner.firstName),
    ]);
  }

// ^ Method Builds Contact Content ^ //
  Widget buildContactItem(Contact contact) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SonrText.normal(contact.firstName),
      SonrText.normal(contact.lastName),
    ]);
  }
}
