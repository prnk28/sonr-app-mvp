import 'package:flutter/services.dart';
import '../form/theme.dart';
import 'package:rive/rive.dart' hide LinearGradient, RadialGradient;

enum RiveBoard { Camera, Icon, Gallery, Contact, Feed, Splash, Documents }

// ^ Rive Animation Container Widget ^ //
class RiveContainer extends StatefulWidget {
  final double width;
  final double height;
  final RiveBoard type;
  final Widget placeholder;

  const RiveContainer({Key key, @required this.type, this.width = 55, this.height = 55, this.placeholder}) : super(key: key);
  @override
  _RiveContainer createState() => _RiveContainer();
}

class _RiveContainer extends State<RiveContainer> {
  // References
  final String _splashPath = 'assets/rive/splash_screen.riv';
  final String _tilePath = 'assets/rive/tile_preview.riv';
  final String _documentsPath = 'assets/rive/documents.riv';

  // Properties
  Artboard _riveArtboard;

  // ** Constructer Initial ** //
  @override
  void initState() {
    // Load the RiveFile from the binary data.
    if (widget.type == RiveBoard.Splash) {
      rootBundle.load(_splashPath).then(
        (data) async {
          // Load the RiveFile from the binary data.
          final file = RiveFile.import(data);

          // Retreive Artboard
          final artboard = file.mainArtboard;

          // Determine Animation by Tile Type
          artboard.addController(SimpleAnimation('Default'));
          if (mounted) {
            setState(() => _riveArtboard = artboard);
          }
        },
      );
    } else if (widget.type == RiveBoard.Documents) {
      rootBundle.load(_documentsPath).then(
        (data) async {
          // Load the RiveFile from the binary data.
          final file = RiveFile.import(data);
          // Retreive Artboard
          final artboard = file.mainArtboard;

          // Determine Animation by Tile Type
          artboard.addController(SimpleAnimation('Default'));
          if (mounted) {
            setState(() => _riveArtboard = artboard);
          }
        },
      );
    } else {
      rootBundle.load(_tilePath).then(
        (data) async {
          // Load the RiveFile from the binary data.
          final file = RiveFile.import(data);
          // Retreive Artboard
          final artboard = file.mainArtboard;

          // Retreive Camera
          if (widget.type == RiveBoard.Camera) {
            artboard.addController(SimpleAnimation('Camera'));
          }

          // Retreive Showcase Loop
          else if (widget.type == RiveBoard.Gallery) {
            artboard.addController(SimpleAnimation('Showcase'));
          }
          // Retreive Showcase Loop
          else if (widget.type == RiveBoard.Feed) {
            artboard.addController(SimpleAnimation('Feed'));
          }
          // Retreive Icon Loop
          else {
            artboard.addController(SimpleAnimation('Icon'));
          }
          if (mounted) {
            setState(() => _riveArtboard = artboard);
          }
        },
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Center(
          child: _riveArtboard == null
              ? widget.placeholder ?? Container()
              : Rive(
                  artboard: _riveArtboard,
                )),
    );
  }
}
