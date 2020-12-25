import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sonar_app/data/social_twitter.dart';
import 'package:sonar_app/service/social_service.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';

// ** Medium Social View/Preview ** //
class TwitterView extends StatefulWidget {
  // Properties
  final Contact_SocialTile item;
  TwitterView(this.item);

  @override
  _TwitterViewState createState() => _TwitterViewState();
}

class _TwitterViewState extends State<TwitterView> {
  TweetsModel data;
  bool fetched = false;
  @override
  void initState() {
    super.initState();
    _fetch();
  }

  // ^ Fetches Data ^ //
  _fetch() async {
    var result =
        await Get.find<SocialMediaService>().getTweets(widget.item.username);
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
        return Container(
          margin: EdgeInsets.all(8),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: data.tweets.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return _buildTweet(data.tweets.elementAt(index));
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                width: 25,
                height: 25,
              );
            },
          ),
        );
      }
      // @ Build ShowCase View
      else if (widget.item.type == Contact_SocialTile_TileType.Showcase) {
        return Stack(
            children: [_buildShowcase(data.tweets.first), _buildBadge()]);
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

  String _cleanDate(String pubDate) {
    var date = DateTime.parse(pubDate);
    var output = new DateFormat.yMMMMd('en_US');
    return output.format(date).toString();
  }
}
