import 'package:sonr_app/style/style.dart';
import 'package:url_launcher/url_launcher.dart';
import '../profile_controller.dart';

class TileController extends GetxController {
  // Properties
  final isDragging = false.obs;
  final isEditing = false.obs;
  final isExpanded = false.obs;
  final isFetched = false.obs;

  // Social Media Properties
  final medium = Rx<MediumModel?>(null);
  final twitter = Rx<TwitterModel?>(null);
  final youtube = Rx<YoutubeModel?>(null);

  // ^ Create New Tile ^ //
  initialize(Contact_Social tile, int i) async {
    // Medium Data
    if (tile.provider == Contact_Social_Provider.Medium) {
      medium(await MediumController.getUser(tile.username));
      isFetched(true);
    }
    // Twitter Data
    else if (tile.provider == Contact_Social_Provider.Twitter) {
      twitter(await TwitterController.getUser(tile.username));
      isFetched(true);
    }
    // Youtube Data
    else if (tile.provider == Contact_Social_Provider.YouTube) {
      youtube(await YoutubeController.searchVideo(tile.links.postLink.link));
      isFetched(true);
    }
  }

  // ^ Launch a URL Event ^ //
  Future launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      SonrSnack.error("Could not launch the URL.");
    }
  }

  // ^ Removes Current Tile ^ //
  deleteTile(Contact_Social tile) {
    UserService.deleteSocial(tile);
  }

  // ^ Toggles Between Expanded and Normal ^ //
  toggleExpand(int index) {
    isExpanded(!isExpanded.value);
    Get.find<ProfileController>().toggleExpand(index, isExpanded.value);
  }
}
