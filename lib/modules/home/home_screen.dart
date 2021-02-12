import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';
import 'package:sonr_app/service/device_service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';
import 'home_controller.dart';
import 'search_dialog.dart';
import 'share_button.dart';

class HomeScreen extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    // Check for Initial Media after connected
    Get.find<DeviceService>().checkInitialShare();

    return SonrScaffold.appBarLeadingAction(
        resizeToAvoidBottomPadding: false,
        title: "Home",
        leading: SonrButton.circle(
          icon: SonrIcon.profile,
          onPressed: () => Get.offNamed("/profile"),
        ),
        action: SonrButton.circle(
          icon: SonrIcon.search,
          onPressed: () => SonrDialog.search(SearchDialog()),
        ),
        floatingActionButton: ShareButton(),
        body: Container(
          width: Get.width,
          height: Get.height,
          child: Column(children: [
            GestureDetector(
              onTap: () => controller.toggleShareExpand(options: ToggleForced(false)),
              child: Container(
                padding: EdgeInsets.only(top: 10),
                margin: EdgeInsets.only(left: 30, right: 30),
                child: Obx(() => NeumorphicToggle(
                      selectedIndex: controller.toggleIndex.value,
                      onChanged: (val) => controller.setToggleCategory(val),
                      thumb: Center(child: Obx(() => controller.getToggleCategory())),
                      children: [
                        ToggleElement(),
                        ToggleElement(),
                        ToggleElement(),
                        //ToggleElement(),
                      ],
                    )),
              ),
            ),
            TransferCardGrid()
          ]),
        ));
  }
}

class TransferCardGrid extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Initialize
      return Container(
        padding: EdgeInsets.only(top: 15),
        margin: EdgeInsets.all(10),
        height: 500, // card height
        child: PageView.builder(
            itemCount: getCardList(controller).length,
            controller: controller.pageController,
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
                        child: SonrCard.fromItem(getCardList(controller)[idx], idx),
                      );
                    },
                  );
                } else if (idx == controller.pageIndex.value) {
                  return PlayAnimation<double>(
                    tween: (0.95).tweenTo(0.85),
                    duration: 200.milliseconds,
                    builder: (context, child, value) {
                      return Transform.scale(
                        scale: value,
                        child: SonrCard.fromItem(getCardList(controller)[idx], idx),
                      );
                    },
                  );
                } else {
                  return Transform.scale(
                    scale: 0.85,
                    child: SonrCard.fromItem(getCardList(controller)[idx], idx),
                  );
                }
              });
            }),
      );
    });
  }

  List<TransferCard> getCardList(HomeController controller) {
    if (controller.toggleIndex.value == 1) {
      return controller.mediaCards();
    } else if (controller.toggleIndex.value == 2) {
      return controller.contactCards;
    } else {
      return controller.allCards;
    }
  }
}

// ** Expanded Hero Home Screen Item ** //
class ExpandedView extends StatelessWidget {
  final TransferCard card;

  const ExpandedView({Key key, @required this.card}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: Get.back,
      child: SizedBox(
        width: Get.width,
        child: GestureDetector(
          onTap: () {
            Get.back(closeOverlays: true);
          },
          child: Hero(
            tag: card.id,
            child: Material(color: Colors.transparent, child: _buildExpandedChild()),
          ),
        ),
      ),
    );
  }

  // ^ Builds Expanded View by Card Type
  Widget _buildExpandedChild() {
    // @ Media Card =>
    if (card.payload == Payload.MEDIA) {
      // Photo File
      if (card.metadata.mime.type == MIME_Type.image) {
        return PhotoView(imageProvider: MemoryImage(card.metadata.thumbnail));
      }
      // TODO: Video File
      else if (card.metadata.mime.type == MIME_Type.video) {
        return Container();
      }
      // Other
      else {
        return Container();
      }
    }

    // TODO: Contact Card =>
    else if (card.payload == Payload.CONTACT) {
      return Container(color: Colors.blue);
    }
    // TODO: Other Card =>
    else {
      return Container();
    }
  }
}
