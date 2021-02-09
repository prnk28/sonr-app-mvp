import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:sonr_app/theme/theme.dart';
import 'home_controller.dart';
import 'package:flutter/material.dart';
import 'package:sonr_core/sonr_core.dart';

// ** Home Screen Item ** //
class TransferItem extends GetWidget<TransferItemController> {
  final TransferCard card;
  final int index;
  TransferItem(this.card, this.index);

  @override
  Widget build(BuildContext context) {
    // Initialize TransferItem Controller
    controller.initialize(card, index);

    // Return View
    return Obx(() {
      // @ Current Card is in Focus
      if (controller.isFocused.value) {
        return PlayAnimation<double>(
          tween: (0.85).tweenTo(0.95),
          duration: 200.milliseconds,
          builder: (context, child, value) {
            return Transform.scale(
              scale: value,
              child: buildCard(card),
            );
          },
        );
      }

      if (controller.hasLeftFocus.value) {
        return PlayAnimation<double>(
          tween: (0.95).tweenTo(0.85),
          duration: 200.milliseconds,
          builder: (context, child, value) {
            return Transform.scale(
              scale: value,
              child: buildCard(card),
            );
          },
        );
      }

      // @ Current Card is Out of Focus
      return Transform.scale(
        scale: 0.85,
        child: buildCard(card),
      );
    });
  }

  // ^ Method Creates Card Widget ^ //
  Widget buildCard(TransferCard card) {
    Widget view;
    switch (card.payload) {
      case Payload.MEDIA:
        view = _buildMediaItem(card.metadata, card);
        break;
      case Payload.CONTACT:
        view = _buildContactItem(card.contact);
        break;
    }
    return GestureDetector(
      onTap: () async {
        // controller.toggleShareExpand(options: ToggleForced(false));
      },
      child: Neumorphic(
        style: NeumorphicStyle(intensity: 0.85, boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20))),
        margin: EdgeInsets.all(4),
        child: Container(
          height: 75,
          decoration: BoxDecoration(
              image: DecorationImage(
            fit: BoxFit.cover,
            image: MemoryImage(card.metadata.thumbnail),
          )),
          child: view,
        ),
      ),
    );
  }

  // @ Method Builds Media Content from Metadata ^ //
  Widget _buildMediaItem(Metadata metadata, TransferCard card) {
    return new Stack(
      children: <Widget>[
        Hero(
          tag: metadata.id,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SonrText.normal(metadata.mime.type.toString()),
            SonrText.normal("Owner: " + card.firstName),
          ]),
        ),
      ],
    );
  }

// @ Method Builds Contact Content ^ //
  Widget _buildContactItem(Contact contact) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      SonrText.normal(contact.firstName),
      SonrText.normal(contact.lastName),
    ]);
  }
}

// ** Expanded Hero Home Screen Item ** //
class MediaItemExpanded extends StatelessWidget {
  final Metadata metadata;

  const MediaItemExpanded({Key key, this.metadata}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Hero(
        tag: metadata.id,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: Get.back,
            child: Image.memory(
              metadata.thumbnail,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

class TransferItemController extends GetxController {
  // References
  int index;
  TransferCard card;
  bool _initialized;

  // Properties
  final isFocused = false.obs;
  final hasLeftFocus = false.obs;

  TransferItemController() {
    // Check if Focused
    Get.find<HomeController>().pageIndex.listen((currIdx) {
      if (_initialized) {
        // Check if No Longer Focused
        if (isFocused.value) {
          // Set to Scale Down
          hasLeftFocus(index == currIdx);

          // Reset after Delay
          Future.delayed(200.milliseconds, () {
            hasLeftFocus(false);
          });
        }

        // Update Focused
        isFocused(index == currIdx);
      }
    });
  }

  // ^ Sets TransferCard Data for this Widget ^
  initialize(TransferCard card, int index) {
    this.card = card;
    this.index = index;
    _initialized = true;
    isFocused(index == 0);
  }

  // ^ Expands Transfer Card into Hero ^ //
  expand() {}
}
