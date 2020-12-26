import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sonar_app/data/social_youtube.dart';
import 'package:sonar_app/service/social_service.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';

// ** Medium Social View/Preview ** //
class YoutubeView extends StatefulWidget {
  // Properties
  final Contact_SocialTile item;
  YoutubeView(this.item);

  @override
  _YoutubeViewState createState() => _YoutubeViewState();
}

class _YoutubeViewState extends State<YoutubeView> {
  // Fetched Data
  YoutubeModel video;

  // References
  bool fetched = false;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  // ^ Fetches Data ^ //
  _fetch() async {
    var res = await Get.find<SocialMediaService>().getYoutube(widget.item.url);
    setState(() {
      video = res;
      fetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // * Validate Fetched * //
    if (fetched) {
      // @ Build ShowCase View
      if (widget.item.type == Contact_SocialTile_TileType.Showcase) {
        return Stack(
            children: [_buildShowcase(video.items.first), _buildBadge()]);
      }
      // @ Build Icon View
      else {
        return Center(
            child: SonrIcon.socialFromProvider(
                IconType.Gradient, Contact_SocialTile_Provider.YouTube));
      }
    } else {
      return Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent)));
    }
  }

  _buildBadge() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: SonrIcon.socialFromProvider(
            IconType.Gradient, Contact_SocialTile_Provider.YouTube,
            size: 30),
      ),
    );
  }

  _buildShowcase(VideoList video) {
    // Build View
    return GestureDetector(
      onTap: () {
        // Get.find<DeviceService>().launchURL(
        //     "https://twitter.com/${widget.item.username}/status/${video.video.id}");
        HapticFeedback.lightImpact();
      },
      child: Container(
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
      ),
    );
  }

  String _cleanDate(String pubDate) {
    var date = DateTime.parse(pubDate);
    var output = new DateFormat.yMMMMd('en_US');
    return output.format(date).toString();
  }
}
