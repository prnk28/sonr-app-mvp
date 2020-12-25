import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sonar_app/data/social_twitter.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';

// ** Medium Social View/Preview ** //
class TwitterView extends StatelessWidget {
  // Properties
  final Contact_SocialTile_TileType type;
  final TwitterData data;
  final Tweet tweet;
  TwitterView(this.type, {this.data, this.tweet});

  factory TwitterView.feed(TwitterData data) {
    return TwitterView(Contact_SocialTile_TileType.Feed, data: data);
  }

  factory TwitterView.showcase(Tweet tweet) {
    return TwitterView(
      Contact_SocialTile_TileType.Showcase,
      tweet: tweet,
    );
  }

  factory TwitterView.icon() {
    return TwitterView(Contact_SocialTile_TileType.Icon);
  }

  @override
  Widget build(BuildContext context) {
    // @ Build Feed View
    if (type == Contact_SocialTile_TileType.Feed) {
      return ListView.separated(
        shrinkWrap: true,
        itemCount: data.tweets.list.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return _buildTweet(data.tweets.list.elementAt(index));
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
      return Stack(
          children: [_buildShowcase(data.tweets.list.first), _buildBadge()]);
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
  _buildShowcase(Tweet tweet) {
    // Build View
    return GestureDetector(
      onTap: () {
        // TODO: Get.find<DeviceService>().launchURL(tweet.id);
        HapticFeedback.lightImpact();
      },
      child: Container(
        width: 150,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SonrText.description(tweet.text, size: 14),
              SonrText.normal(_cleanDate(tweet.createdAt), size: 14)
            ],
          ),
        ),
      ),
    );
  }

  // ^ Build Feed Post for Medium ^ //
  _buildTweet(Tweet tweet) {
    // Build View
    return NeumorphicButton(
      onPressed: () {
        // TODO: Get.find<DeviceService>().launchURL(post.link);
      },
      child: Container(
        width: 275,
        height: 180,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // SonrText.gradient(tweet.id, FlutterGradientNames.premiumDark,
              //     size: 20),
              SonrText.description(tweet.text, size: 14),
              SonrText.normal(_cleanDate(tweet.createdAt), size: 14)
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
}

// ** Twitter Social View/Preview ** //

// ** Spotify Social View/Preview ** //

// ** Spotify Social View/Preview ** //
