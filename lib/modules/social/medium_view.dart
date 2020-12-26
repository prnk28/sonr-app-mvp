import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sonar_app/data/social_medium.dart';
import 'package:sonar_app/service/device_service.dart';
import 'package:sonar_app/service/social_service.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';

// ** Medium Social View/Preview ** //
class MediumView extends StatefulWidget {
  // Properties
  final Contact_SocialTile item;
  MediumView(this.item);

  @override
  _MediumViewState createState() => _MediumViewState();
}

class _MediumViewState extends State<MediumView> {
  MediumModel data;
  bool fetched = false;
  @override
  void initState() {
    super.initState();
    _fetch();
  }

  // ^ Fetches Data ^ //
  _fetch() async {
    var result =
        await Get.find<SocialMediaService>().getMedium(widget.item.username);
    setState(() {
      data = result;
      fetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // * Validate Fetched * //
    if (fetched) {
      // @ Build Feed View
      if (widget.item.type == Contact_SocialTile_TileType.Feed) {
        return ListView.separated(
          shrinkWrap: true,
          itemCount: data.posts.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return _buildPost(data.posts.elementAt(index));
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              width: 25,
              height: 25,
            );
          },
        );
      }
      // @ Build ShowCase View
      else if (widget.item.type == Contact_SocialTile_TileType.Showcase) {
        return Stack(
            children: [_buildShowcase(data.posts.first), _buildBadge()]);
      }
      // @ Build Icon View
      else {
        return Center(
            child: SonrIcon.socialFromProvider(
                IconType.Gradient, Contact_SocialTile_Provider.Medium));
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
            IconType.Gradient, Contact_SocialTile_Provider.Medium,
            size: 30),
      ),
    );
  }

  _buildShowcase(Post post) {
    // Build View
    return GestureDetector(
      onTap: () {
        Get.find<DeviceService>().launchURL(post.link);
        HapticFeedback.lightImpact();
      },
      child: Container(
        padding: EdgeInsets.all(12),
        width: 150,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                  clipper: WaveClipperOne(),
                  child: Image.network(post.thumbnail)),
              SonrText.gradient(post.title, FlutterGradientNames.premiumDark,
                  size: 16),
            ],
          ),
        ),
      ),
    );
  }

  _buildPost(Post post) {
    // Build View
    return NeumorphicButton(
      padding: EdgeInsets.all(12),
      onPressed: () {
        Get.find<DeviceService>().launchURL(post.link);
      },
      child: Container(
        width: 275,
        height: 180,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                  clipper: WaveClipperOne(),
                  child: Image.network(post.thumbnail)),
              SonrText.gradient(post.title, FlutterGradientNames.premiumDark,
                  size: 20),
              SonrText.description(
                  _cleanDescription(post.title.length, post.description),
                  size: 14),
              SonrText.normal(_cleanDate(post.pubDate), size: 14)
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

  String _cleanDescription(int titleLength, String postDesc) {
    // Calculate Description length
    int maxDesc = 118;
    if (titleLength > 50) {
      int factor = titleLength - 50;
      maxDesc = maxDesc - factor;
    }

    // Clean from HTML Tags
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    String cleaned = postDesc.replaceAll(exp, '');

    // Limit Characters
    return cleaned = cleaned.substring(0, maxDesc) + "...";
  }
}
