import 'package:get/get.dart';
import 'package:sonar_app/data/medium_model.dart';
import 'package:sonar_app/data/social_model.dart';
import 'package:sonar_app/service/social_service.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';

// ** Social View Displays Tile Item ** //
class TileSocialView extends StatefulWidget {
  final Contact_SocialTile_TileType type;
  final SocialMediaItem item;

  TileSocialView(this.type, this.item, {Key key}) : super(key: key);

  // @ To Display Existing Tile
  factory TileSocialView.fromTile(Contact_SocialTile tile) {
    var item = Get.find<SocialMediaService>().getItem(tile);
    return TileSocialView(tile.type, item);
  }

  // @ To Display Tile Preview
  factory TileSocialView.fromItem(
      SocialMediaItem tile, Contact_SocialTile_TileType type) {
    return TileSocialView.fromItem(tile, type);
  }

  @override
  _TileSocialViewState createState() => _TileSocialViewState();
}

// ** Stateful Widget to Fetch Data ** //
class _TileSocialViewState extends State<TileSocialView> {
  bool _dataLoaded;
  dynamic _data;

  @override
  void initState() {
    // Skip Fetch if Icon
    if (widget.type == Contact_SocialTile_TileType.Icon) {
      _dataLoaded = true;
    }

    // Fetch for Showcase/Feed
    else {
      _dataLoaded = false;
      _fetch();
    }
    super.initState();
  }

  @override
  void dispose() {
    _dataLoaded = false;
    _data = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // @ Await Data to load
    if (_dataLoaded) {
      // Validate Data
      if (_data == null) {
        return Center(
            child: SonrIcon.socialFromProvider(
                IconType.Gradient, widget.item.provider));
      }
      // Check Received Data
      else {
        return _buildView();
      }
    }

    // @ Display Loading
    else {
      return Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent)));
    }
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

  // ^ Builds Data for Corresponding Model ^ //
  Widget _buildView() {
    // Medium Data
    if (_data is MediumFeedModel) {
      return MediumView.asTile(widget.type, _data);
    }
    return Container();
  }
}

// ^ Medium Social View/Preview ^ //
class MediumView extends StatelessWidget {
  // Properties
  final Contact_SocialTile_TileType type;
  final MediumFeedModel data;
  final bool isPreview;

  MediumView(this.type, this.isPreview, {this.data});

  factory MediumView.asTile(
      Contact_SocialTile_TileType type, MediumFeedModel data) {
    return MediumView(type, false, data: data);
  }

  factory MediumView.asPreview(
      Contact_SocialTile_TileType type, MediumFeedModel data) {
    return MediumView(type, true);
  }

  @override
  Widget build(BuildContext context) {
    if (isPreview) {
      return _buildPreview();
    } else {
      return _buildTile();
    }
  }

  Widget _buildTile() {
    // @ Build Feed View
    if (type == Contact_SocialTile_TileType.Feed) {
      return Text("Feed View TODO");
    }
    // @ Build ShowCase View
    else if (type == Contact_SocialTile_TileType.Showcase) {
      return Text("Showcase View TODO");
    }
    // @ Build Icon View
    else {
      return Center(
          child: SonrIcon.socialFromProvider(
              IconType.Gradient, Contact_SocialTile_Provider.Medium));
    }
  }

  Widget _buildPreview() {
    // @ Build Feed View
    if (type == Contact_SocialTile_TileType.Feed) {
      return Text("Feed View TODO");
    }
    // @ Build ShowCase View
    else if (type == Contact_SocialTile_TileType.Showcase) {
      return Text("Showcase View TODO");
    }
    // @ Build Icon View
    else {
      return Center(
          child: SonrIcon.socialFromProvider(
              IconType.Gradient, Contact_SocialTile_Provider.Medium));
    }
  }
}
