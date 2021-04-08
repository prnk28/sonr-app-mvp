import 'package:sonr_app/modules/profile/profile.dart';
import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_social.dart';

class TileController extends GetxController {
  // Properties
  final isDragging = false.obs;
  final isEditing = false.obs;
  final isExpanded = false.obs;
  final isFetched = false.obs;

  // Social Media Properties
  final medium = Rx<MediumModel>(null);
  final twitter = Rx<TwitterModel>(null);
  final youtube = Rx<YoutubeModel>(null);

  // ^ Create New Tile ^ //
  initialize(Contact_SocialTile tile, int i) async {
    // Medium Data
    if (tile.provider == Contact_SocialTile_Provider.Medium) {
      medium(await MediumController.getUser(tile.username));
      isFetched(true);
    }
    // Twitter Data
    else if (tile.provider == Contact_SocialTile_Provider.Twitter) {
      twitter(await TwitterController.getUser(tile.username));
      isFetched(true);
    }
    // Youtube Data
    else if (tile.provider == Contact_SocialTile_Provider.YouTube) {
      youtube(await YoutubeController.searchVideo(tile.links.postLink));
      isFetched(true);
    }
  }

  // ^ Removes Current Tile ^ //
  deleteTile(Contact_SocialTile tile) {
    UserService.deleteSocial(tile);
  }

  // ^ Toggles Between Expanded and Normal ^ //
  toggleExpand(int index) {
    isExpanded(!isExpanded.value);
    Get.find<ProfileController>().toggleExpand(index, isExpanded.value);
  }
}
