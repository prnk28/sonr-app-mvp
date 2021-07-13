import 'package:intl/intl.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_app/pages/personal/personal.dart';

class SocialView extends StatelessWidget {
  final TileController controller;
  final Contact_Social item;
  final int index;
  SocialView(this.controller, this.item, this.index);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // @ Await for Data to Fetch
      if (controller.isFetched.value) {
        // Build Expanded
        if (controller.isExpanded.value) {
          return _buildExpanded(item.media);
        }

        switch (item.media) {
          // Medium
          case Contact_Social_Media.Medium:
            var posts = controller.medium.value;
            return Stack(children: [_MediumItem(posts, 0, true), item.media.black()]);

          // Twitter
          case Contact_Social_Media.Twitter:
            var twitter = controller.twitter.value;
            return Stack(children: [_TweetItem(twitter, 0, true, controller), item.media.black()]);

          // Youtube
          case Contact_Social_Media.YouTube:
            var youtube = controller.youtube.value;
            return Stack(children: [_YoutubeItem(youtube, 0, true), item.media.black()]);

          // Other
          default:
            return Container();
        }
      }

      // @ Build Loading View
      else {
        return item.media.gradient();
      }
    });
  }

  /// ** Builds Expanded Tile View - List/Grid ** //
  _buildExpanded(Contact_Social_Media provider) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: controller.twitter.value!.count,
      scrollDirection: provider == Contact_Social_Media.Twitter ? Axis.vertical : Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return _TweetItem(controller.twitter.value, index, false, controller);
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

/// #### Medium Item
class _MediumItem extends StatelessWidget {
  final MediumModel? medium;
  final int index;
  final bool isTile;
  const _MediumItem(this.medium, this.index, this.isTile, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isTile) {
      return Container(
        padding: EdgeInsets.all(12),
        width: 150,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ShapeContainer.wave(child: Image.network(medium!.posts!.first.thumbnail!), width: 150, height: 120),
              medium!.posts!.first.title!.gradient(value: DesignGradients.PremiumDark, size: 16)
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
            ShapeContainer.wave(child: Image.network(medium!.posts![index].thumbnail!), width: 275, height: 140),
            medium!.posts![index].title!.gradient(value: DesignGradients.PremiumDark, size: 20),
            PostText.description(medium!.posts![index].title!.length, medium!.posts![index].description!),
            PostText.date(medium!.posts![index].pubDate!)
          ],
        ),
      ),
    );
  }
}

/// #### Twitter Item
class _TweetItem extends StatelessWidget {
  final TileController controller;
  final TwitterModel? twitter;
  final int index;
  final bool isTile;
  const _TweetItem(
    this.twitter,
    this.index,
    this.isTile,
    this.controller, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var latestTweet = twitter!.tweets!.first;
    var user = twitter!.user;
    var tweets = twitter!.tweets;

    if (isTile) {
      return Container(
        padding: EdgeInsets.all(12),
        width: 150,
        child: SingleChildScrollView(
          child: Column(
            children: [latestTweet.text!.paragraph(), PostText.date(latestTweet.createdAt!)],
          ),
        ),
      );
    }
    return ColorButton.primary(
      padding: EdgeInsets.all(12),
      onPressed: () {
        controller.launchURL("https://twitter.com/${user!.username}/status/${tweets![index].id}");
      },
      child: Container(
        width: 275,
        child: SingleChildScrollView(
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Container(
              width: 55,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [ClipOval(child: Image.network(user!.profilePicUrl!)), user.username!.paragraph()]),
            ),
            Container(
              width: 265,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  PostText.date(tweets![index].createdAt!),
                  tweets[index].text!.paragraph(),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

/// #### Youtube Item
class _YoutubeItem extends StatelessWidget {
  final YoutubeModel? youtube;
  final int index;
  final bool isTile;
  const _YoutubeItem(this.youtube, this.index, this.isTile, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var video = youtube!.items!.first.video!;
    // Build View
    return Container(
      padding: EdgeInsets.all(12),
      width: 150,
      child: SingleChildScrollView(
        child: Column(
          children: [video.title!.paragraph(), PostText.date(video.publishTime!)],
        ),
      ),
    );
  }
}

class PostText {
  // @ Build Date Text
  static Widget date(String pubDate) {
    var date = DateTime.parse(pubDate);
    var output = DateFormat.yMMMMd('en_US');
    return output.format(date).toString().paragraph();
  }

  // @ Build Description Text
  static Widget description(int titleLength, String postDesc) {
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
    var text = cleaned.substring(0, maxDesc) + "...";
    return text.paragraph();
  }
}
