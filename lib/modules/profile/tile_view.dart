import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sonar_app/data/medium_model.dart';
import 'package:sonar_app/service/device_service.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

// ^ Medium Social View/Preview ^ //
class MediumView extends StatelessWidget {
  // Properties
  final Contact_SocialTile_TileType type;
  final MediumFeedModel data;
  final Post post;
  MediumView(this.type, {this.data, this.post});

  factory MediumView.feed(MediumFeedModel data) {
    return MediumView(Contact_SocialTile_TileType.Feed, data: data);
  }

  factory MediumView.showcase(Post post) {
    return MediumView(
      Contact_SocialTile_TileType.Showcase,
      post: post,
    );
  }

  factory MediumView.icon() {
    return MediumView(Contact_SocialTile_TileType.Icon);
  }

  @override
  Widget build(BuildContext context) {
    // @ Build Feed View
    if (type == Contact_SocialTile_TileType.Feed) {
      return ListView.separated(
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
    else if (type == Contact_SocialTile_TileType.Showcase) {
      return Stack(children: [
        _buildPost(data.posts.first, isShowcase: true),
        _buildBadge()
      ]);
    }
    // @ Build Icon View
    else {
      return Center(
          child: SonrIcon.socialFromProvider(
              IconType.Gradient, Contact_SocialTile_Provider.Medium));
    }
  }

  // ^ Build Tile Icon Badge for Medium ^ //
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

  // ^ Build Feed Post for Medium ^ //
  _buildPost(Post post, {bool isShowcase = false}) {
    // Build View
    return GestureDetector(
      onTap: () {
        Get.find<DeviceService>().launchURL(post.link);
        HapticFeedback.lightImpact();
      },
      child: Container(
        width: isShowcase ? 150 : 275,
        height: isShowcase ? 90 : 180,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                  clipper: WaveClipperOne(),
                  child: Image.network(post.thumbnail)),
              SonrText.gradient(post.title, FlutterGradientNames.premiumDark,
                  size: isShowcase ? 16 : 20),
              isShowcase
                  ? Container()
                  : SonrText.description(_cleanDescription(post.description),
                      size: 14),
              isShowcase
                  ? Container()
                  : SonrText.normal(_cleanDate(post.pubDate), size: 14)
            ],
          ),
        ),
      ),
    );
  }

  // ^ Method to Clean Description ^ //
  String _cleanDate(String pubDate) {
    var date = DateTime.parse(pubDate);
    var output = new DateFormat.yMMMMd('en_US');
    return output.format(date).toString();
  }

  // ^ Method to Clean Description ^ //
  String _cleanDescription(String postDesc) {
    // Clean from HTML Tags
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    String cleaned = postDesc.replaceAll(exp, '');

    // Limit Characters
    return cleaned = cleaned.substring(0, 130) + "...";
  }
}
