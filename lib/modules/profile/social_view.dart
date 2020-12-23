import 'package:get/get.dart';
import 'package:sonar_app/data/medium_model.dart';
import 'package:sonar_app/data/social_model.dart';
import 'package:sonar_app/service/social_service.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';

class SocialView extends StatelessWidget {
  final Contact_SocialTile_TileType type;
  final SocialMediaItem item;

  SocialView(this.type, this.item, {Key key}) : super(key: key);

  // @ To Display Existing Tile
  factory SocialView.fromTile(Contact_SocialTile tile) {
    var item = Get.find<SocialMediaService>().getItem(tile);
    return SocialView(tile.type, item);
  }

  // @ To Display Tile Preview
  factory SocialView.fromItem(
      SocialMediaItem tile, Contact_SocialTile_TileType type) {
    return SocialView.fromItem(tile, type);
  }

  @override
  Widget build(BuildContext context) {
    // Fetch Item Data
    var data = Get.find<SocialMediaService>().fetchData(item);

    // Check Data Model Type
    if (data is MediumFeedModel) {
      return _buildMedium(data);
    }

    return Container();
  }

  // ^ Build Medium Based View ^ //
  Widget _buildMedium(MediumFeedModel data) {
    // @ Build Feed View
    if (type == Contact_SocialTile_TileType.Feed) {
      return Text("Feed View TODO");
    }
    // @ Build ShowCase View
    else if (type == Contact_SocialTile_TileType.Showcase) {
      return Text("Showcase View TODO");
    }
    // @ Build Icon View
    else {
      return Center(
          child: SonrIcon.socialFromProvider(IconType.Gradient, item.provider));
    }
  }
}
