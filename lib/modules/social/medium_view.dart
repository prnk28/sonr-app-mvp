import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sonar_app/data/social_medium.dart';
import 'package:sonar_app/modules/profile/tile_controller.dart';
import 'package:sonar_app/service/social_service.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';

// ** Medium Social View/Preview ** //
class MediumView extends StatefulWidget {
  // Properties
  final Contact_SocialTile item;
  final TileController controller;
  MediumView(this.item, this.controller) {
    item.type = Contact_SocialTile_TileType.Showcase;
  }

  @override
  _MediumViewState createState() => _MediumViewState();
}

class _MediumViewState extends State<MediumView> {
  MediumModel data;
  bool fetched = false;
  bool expanded = false;

  @override
  void initState() {
    super.initState();
    _fetch();

    widget.controller.state.listen((state) {
      if (state == TileState.Expanded) {
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
      // @ Build Expanded Feed View
      if (expanded) {
        return ListView.separated(
          shrinkWrap: true,
          itemCount: data.posts.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int index) {
            return _buildExpandedItem(data.posts.elementAt(index));
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              width: 25,
              height: 25,
            );
          },
        );
      }
      // @ Build Tile View
      else {
        return Stack(children: [
          _buildTile(data.posts.first),
          SonrIcon.socialBadge(Contact_SocialTile_Provider.Medium)
        ]);
      }
    } else {
      return Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent)));
    }
  }

  _buildTile(Post post) {
    // Build View
    return Container(
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
    );
  }

  _buildExpandedItem(Post post) {
    // Build View
    return Container(
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
