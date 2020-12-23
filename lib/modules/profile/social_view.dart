import 'package:get/get.dart';
import 'package:sonar_app/data/medium_model.dart';
import 'package:sonar_app/data/social_model.dart';
import 'package:sonar_app/service/social_service.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';

// ** Social View Displays Tile Item ** //
class SocialView extends StatefulWidget {
  final Contact_SocialTile_TileType type;
  final SocialMediaItem item;

  SocialView(this.type, this.item, {Key key}) : super(key: key);

  // @ To Display Existing Tile
  factory SocialView.fromTile(Contact_SocialTile tile) {
    var item = Get.find<SocialMediaService>().getItem(tile);
    return SocialView(tile.type, item);
  }

  // @ To Display Tile Preview
  factory SocialView.fromItem(
      SocialMediaItem tile, Contact_SocialTile_TileType type) {
    return SocialView.fromItem(tile, type);
  }

  @override
  _SocialViewState createState() => _SocialViewState();
}

// ** Stateful Widget to Fetch Data ** //
class _SocialViewState extends State<SocialView> {
  bool _dataLoaded = false;
  dynamic _data;

  @override
  void initState() {
    _fetch();
    super.initState();
  }

  @override
  void dispose() {
    _dataLoaded = false;
    _data = null;
    super.dispose();
  }

  // ^ Fetch Item Data ^
  _fetch() async {
    var result = await Get.find<SocialMediaService>().fetchData(widget.item);
    if (mounted) {
      setState(() {
        _data = result;
        _dataLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // @ Await Data to load
    if (_dataLoaded) {
      // Medium Data
      if (_data is MediumFeedModel) {
        return _buildMedium(_data);
      }
      // TODO
      else {
        return Center(
            child: SonrIcon.socialFromProvider(
                IconType.Gradient, widget.item.provider));
      }
    }

    // @ Display Loading
    else {
      return Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent)));
    }
  }

  Widget _buildMedium(MediumFeedModel data) {
    // @ Build Feed View
    if (widget.type == Contact_SocialTile_TileType.Feed) {
      return Text("Feed View TODO");
    }
    // @ Build ShowCase View
    else if (widget.type == Contact_SocialTile_TileType.Showcase) {
      return Text("Showcase View TODO");
    }
    // @ Build Icon View
    else {
      return Center(
          child: SonrIcon.socialFromProvider(
              IconType.Gradient, widget.item.provider));
    }
  }
}
