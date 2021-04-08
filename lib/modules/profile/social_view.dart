import 'package:sonr_app/theme/theme.dart';
import 'package:sonr_core/sonr_social.dart';
import 'profile.dart';

class SocialView extends StatelessWidget {
  final TileController controller;
  final Contact_SocialTile item;
  final int index;
  SocialView(this.controller, this.item, this.index);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // @ Await for Data to Fetch
      if (controller.isFetched.value) {
        // Build Expanded
        if (controller.isExpanded.value) {
          return _buildExpanded(item.provider);
        }

        switch (item.provider) {
          // Medium
          case Contact_SocialTile_Provider.Medium:
            var posts = controller.medium.value;
            return Stack(children: [_MediumItem(posts, 0, true), item.provider.badge()]);
            break;

          // Twitter
          case Contact_SocialTile_Provider.Twitter:
            var twitter = controller.twitter.value;
            return Stack(children: [_TweetItem(twitter, 0, true), item.provider.badge()]);
            break;

          // Youtube
          case Contact_SocialTile_Provider.YouTube:
            var youtube = controller.youtube.value;
            return Stack(children: [_YoutubeItem(youtube, 0, true), item.provider.badge()]);
            break;

          // Other
          default:
            return Container();
            break;
        }
      }

      // @ Build Loading View
      else {
        var icon = item.provider.icon(IconType.Gradient);
        return AnimatedWaveIcon(icon.data, gradient: icon.gradient);
      }
    });
  }

  // ** Builds Expanded Tile View - List/Grid ** //
  _buildExpanded(Contact_SocialTile_Provider provider) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: controller.twitter.value.count,
      scrollDirection: provider == Contact_SocialTile_Provider.Twitter ? Axis.vertical : Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return _TweetItem(controller.twitter.value, index, false);
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          width: 25,
          height: 25,
        );
      },
    );
  }
}

// ^ Medium Item ^ //
class _MediumItem extends StatelessWidget {
  final MediumModel medium;
  final int index;
  final bool isTile;
  const _MediumItem(this.medium, this.index, this.isTile, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isTile) {
      return Container(
        padding: EdgeInsets.all(12),
        width: 150,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(clipper: WaveClipperOne(), child: Image.network(medium.posts.first.thumbnail)),
              SonrText.gradient(medium.posts.first.title, FlutterGradientNames.premiumDark, size: 16),
            ],
          ),
        ),
      );
    }
    return Container(
      width: 275,
      height: 180,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(clipper: WaveClipperOne(), child: Image.network(medium.posts[index].thumbnail)),
            SonrText.gradient(medium.posts[index].title, FlutterGradientNames.premiumDark, size: 20),
            SonrText.postDescription(medium.posts[index].title.length, medium.posts[index].description),
            SonrText.postDate(medium.posts[index].pubDate, size: 14)
          ],
        ),
      ),
    );
  }
}

// ^ Twitter Item ^ //
class _TweetItem extends StatelessWidget {
  final TwitterModel twitter;
  final int index;
  final bool isTile;
  const _TweetItem(this.twitter, this.index, this.isTile, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var latestTweet = twitter.tweets.first;
    var user = twitter.user;
    var tweets = twitter.tweets;

    if (isTile) {
      return Container(
        padding: EdgeInsets.all(12),
        width: 150,
        child: SingleChildScrollView(
          child: Column(
            children: [SonrText.normal(latestTweet.text, size: 14), SonrText.postDate(latestTweet.createdAt, size: 14)],
          ),
        ),
      );
    }
    return NeumorphicButton(
      padding: EdgeInsets.all(12),
      onPressed: () {
        Get.find<DeviceService>().launchURL("https://twitter.com/${user.username}/status/${tweets[index].id}");
      },
      child: Container(
        width: 275,
        child: SingleChildScrollView(
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Container(
              width: 55,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [ClipOval(child: Image.network(user.profilePicUrl)), SonrText.medium(user.username, size: 10)]),
            ),
            Container(
              width: 265,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SonrText.postDate((tweets[index].createdAt), size: 20),
                  SonrText.normal(tweets[index].text, size: 14),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

// ^ Youtube Item ^ //
class _YoutubeItem extends StatelessWidget {
  final YoutubeModel youtube;
  final int index;
  final bool isTile;
  const _YoutubeItem(this.youtube, this.index, this.isTile, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var video = youtube.items.first.video;
    // Build View
    return Container(
      padding: EdgeInsets.all(12),
      width: 150,
      child: SingleChildScrollView(
        child: Column(
          children: [SonrText.normal(video.title, size: 14), SonrText.postDate(video.publishTime, size: 14)],
        ),
      ),
    );
  }
}
