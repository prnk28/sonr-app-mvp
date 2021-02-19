import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sonr_app/data/social_medium.dart';
import 'package:sonr_app/data/social_twitter.dart';
import 'package:sonr_app/data/social_youtube.dart';
import 'package:sonr_app/modules/profile/profile_controller.dart';
import 'package:sonr_app/modules/profile/social_view.dart';
import 'package:sonr_app/service/device_service.dart';
import 'package:sonr_app/service/social_service.dart';
import 'package:sonr_app/service/user_service.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_core.dart';

// ** Builds Social Tile ** //
class SocialTileItem extends GetWidget<TileController> {
  final Contact_SocialTile item;
  final int index;
  SocialTileItem(this.item, this.index);
  @override
  Widget build(BuildContext context) {
    // Build View
    controller.initialize(item, index);

    // Build View Controller
    return Stack(children: [
      // Draggable Aspect
      LongPressDraggable(
          feedback: _buildView(controller.isEditing.value, isDragging: true),
          child: _buildView(controller.isEditing.value),
          data: item,
          childWhenDragging: Container(),
          onDragStarted: () {
            HapticFeedback.heavyImpact();
            controller.isDragging(true);
          }),

      DragTarget<Contact_SocialTile>(
        builder: (context, candidateData, rejectedData) {
          return Container();
        },
        // Only accept same tiles
        onWillAccept: (data) {
          return true;
        },
        // Switch Index Positions with animation
        onAccept: (data) {
          UserService.swapSocials(item, data);
        },
      ),
    ]);
  }

  // ^ Builds Neumorohic Item ^ //
  Widget _buildView(bool isEditing, {bool isDragging = false}) {
    // Theming View with Drag
    return GestureDetector(
      onTap: () {
        Get.find<ProfileController>().toggleExpand(item);
        HapticFeedback.lightImpact();
      },
      onDoubleTap: () {
        Get.find<DeviceService>().launchURL(item.links.postLink);
        HapticFeedback.mediumImpact();
      },
      child: Neumorphic(
        margin: EdgeInsets.all(4),
        style: isEditing
            ? NeumorphicStyle(intensity: 0.75, shape: NeumorphicShape.flat, depth: 15)
            : NeumorphicStyle(intensity: 0.75, shape: NeumorphicShape.convex, depth: 8),
        child: Container(
          width: isDragging ? 125 : Get.width,
          height: isDragging ? 125 : Get.height,
          child: isDragging ? Icon(Icons.drag_indicator) : SocialView(controller, item, index),
        ),
      ),
    );
  }
}

class TileController extends GetxController {
  // References
  int index;
  Contact_SocialTile tile;

  // Properties
  final isDragging = false.obs;
  final isEditing = false.obs;
  final isExpanded = false.obs;
  final isFetched = false.obs;

  // Social Media Properties
  final medium = Rx<MediumModel>();
  final twitter = Rx<TwitterModel>();
  final youtube = Rx<YoutubeModel>();

  // ^ Create New Tile ^ //
  initialize(Contact_SocialTile value, int index) async {
    // Set Tile
    tile = value;
    index = index;
    fetchSocialData();
  }

  // ^ Fetch Data for Social Media ^ //
  fetchSocialData() async {
    // Medium Data
    if (tile.provider == Contact_SocialTile_Provider.Medium) {
      medium(await Get.find<SocialMediaService>().getMedium(tile.username));
      isFetched(true);
    }
    // Twitter Data
    else if (tile.provider == Contact_SocialTile_Provider.Twitter) {
      twitter(await Get.find<SocialMediaService>().getTwitter(tile.username));
      isFetched(true);
    }
    // Youtube Data
    else if (tile.provider == Contact_SocialTile_Provider.YouTube) {
      youtube(await Get.find<SocialMediaService>().getYoutube(tile.links.postLink));
      isFetched(true);
    }
  }

  // ^ Removes Current Tile ^ //
  deleteTile() {
    UserService.deleteSocial(tile);
  }
}
