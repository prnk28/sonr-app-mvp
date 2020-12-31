import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sonar_app/data/social_youtube.dart';
import 'package:sonar_app/modules/profile/profile_controller.dart';
import 'package:sonar_app/service/social_service.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';

// ** Medium Social View/Preview ** //
class YoutubeView extends StatefulWidget {
  // Properties
  final int index;
  final Contact_SocialTile item;
  YoutubeView(this.item, this.index) {
    // item.type = Contact_SocialTile_TileType.Showcase;
  }

  @override
  _YoutubeViewState createState() => _YoutubeViewState();
}

class _YoutubeViewState extends State<YoutubeView> {
  // Fetched Data
  YoutubeModel video;

  // References
  bool fetched = false;
  bool expanded = false;

  @override
  void initState() {
    super.initState();
    _fetch();

    Get.find<ProfileController>().focusTileIndex.listen((idx) {
      if (idx == widget.index) {
        setState(() {
          expanded = true;
        });
      } else {
        setState(() {
          expanded = false;
        });
      }
    });
  }

  // ^ Fetches Data ^ //
  _fetch() async {
    var res =
        await Get.find<SocialMediaService>().getYoutube(widget.item.showcase);
    setState(() {
      video = res;
      fetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // @ Build ShowCase View
    //if (widget.item.type == Contact_SocialTile_TileType.Showcase) {
    if (fetched) {
      return Stack(children: [
        _buildTile(video.items.first),
        SonrIcon.socialBadge(Contact_SocialTile_Provider.YouTube)
      ]);
    } else {
      return Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent)));
    }
    //}
    // // @ Build Icon View
    // else {
    //   if (fetched) {
    //     return Center(
    //         child: SonrIcon.social(
    //             IconType.Gradient, Contact_SocialTile_Provider.YouTube));
    //   } else {
    //     return Center(
    //         child: CircularProgressIndicator(
    //             valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent)));
    //   }
    // }
  }

  _buildTile(VideoList video) {
    // Build View
    return Container(
      padding: EdgeInsets.all(12),
      width: 150,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SonrText.description(video.video.title, size: 14),
            SonrText.normal(_cleanDate(video.video.publishTime), size: 14)
          ],
        ),
      ),
    );
  }

  String _cleanDate(String pubDate) {
    var date = DateTime.parse(pubDate);
    var output = new DateFormat.yMMMMd('en_US');
    return output.format(date).toString();
  }
}
