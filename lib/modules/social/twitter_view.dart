import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sonar_app/data/social_twitter.dart';
import 'package:sonar_app/service/device_service.dart';
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
  // Fetched Data
  TweetsModel tweets;
  TwitterUserModel user;

  // References
  bool fetched = false;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  // ^ Fetches Data ^ //
  _fetch() async {
    var res =
        await Get.find<SocialMediaService>().getTweets(widget.item.username);
    var resB = await Get.find<SocialMediaService>()
        .getTwitterUser(widget.item.username);
    setState(() {
      tweets = res;
      user = resB;
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
          itemCount: tweets.tweets.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return _buildTweet(tweets.tweets.elementAt(index));
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
            children: [_buildShowcase(tweets.tweets.first), _buildBadge()]);
      }
      // @ Build Icon View
      else {
        return Center(
            child: SonrIcon.socialFromProvider(
                IconType.Gradient, Contact_SocialTile_Provider.Twitter));
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
            IconType.Gradient, Contact_SocialTile_Provider.Twitter,
            size: 30),
      ),
    );
  }

  _buildShowcase(Tweet tweet) {
    // Build View
    return GestureDetector(
      onTap: () {
        Get.find<DeviceService>().launchURL(
            "https://twitter.com/${widget.item.username}/status/${tweet.id}");
        HapticFeedback.lightImpact();
      },
      child: Container(
        padding: EdgeInsets.all(12),
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
      padding: EdgeInsets.all(12),
      onPressed: () {
        Get.find<DeviceService>().launchURL(
            "https://twitter.com/${widget.item.username}/status/${tweet.id}");
      },
      child: Container(
        width: 275,
        child: SingleChildScrollView(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            GestureDetector(
              onTap: () {
                Get.find<DeviceService>().launchURL(user.data.first.url);
              },
              child: Container(
                width: 55,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipOval(
                          child: Image.network(user.data.first.profilePicUrl)),
                      SonrText.normal(user.data.first.username, size: 10)
                    ]),
              ),
            ),
            Container(
              width: 265,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SonrText.gradient(_cleanDate(tweet.createdAt),
                      FlutterGradientNames.premiumDark,
                      size: 20),
                  SonrText.description(tweet.text, size: 14),
                ],
              ),
            ),
          ]),
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
