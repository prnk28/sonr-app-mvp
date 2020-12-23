import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:sonar_app/theme/theme.dart';
import 'package:sonr_core/models/models.dart';

class TilePreview extends StatefulWidget {
  // Properties
  final Contact_SocialTile_TileType type;
  final ValueChanged<dynamic> onChanged;
  final dynamic groupValue;

  const TilePreview(this.type,
      {Key key, @required this.onChanged, @required this.groupValue})
      : super(key: key);

  @override
  _TilePreviewState createState() => _TilePreviewState();
}

class _TilePreviewState extends State<TilePreview> {
  Artboard _riveArtboard;
  @override
  void initState() {
    super.initState();
    // Load the RiveFile from the binary data.
    rootBundle.load('assets/animations/tile_preview.riv').then(
      (data) async {
        // Await Loading
        final file = RiveFile();
        if (file.import(data)) {
          // Retreive Artboard
          final artboard = file.mainArtboard;

          // Determine Animation by Tile Type
          artboard.addController(_riveControllerByType(widget.type));
          setState(() => _riveArtboard = artboard);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return NeumorphicRadio(
      style: NeumorphicRadioStyle(
          unselectedColor: K_BASE_COLOR,
          selectedColor: K_BASE_COLOR,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(4))),
      child: SizedBox(
        height: 85,
        width: 85,
        child: Center(
            child: _riveArtboard == null
                ? const SizedBox(
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.blueAccent)))
                : Rive(artboard: _riveArtboard)),
      ),
      value: widget.type,
      groupValue: widget.groupValue,
      onChanged: widget.onChanged,
    );
  }

  // ^ Get Animation Controller By Type ^ //
  SimpleAnimation _riveControllerByType(Contact_SocialTile_TileType type) {
    // Retreive Feed Loop
    if (type == Contact_SocialTile_TileType.Feed) {
      return SimpleAnimation('Feed');
    }
    // Retreive Showcase Loop
    else if (type == Contact_SocialTile_TileType.Showcase) {
      return SimpleAnimation('Showcase');
    }
    // Retreive Icon Loop
    else {
      return SimpleAnimation('Icon');
    }
  }
}
