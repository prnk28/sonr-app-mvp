
import 'package:sonr_app/style/style.dart';

/// A SlidingImage that needs to be a statefulWidget
/// because it needs an re build every time a page is scrolled
class SlidingImage extends StatefulWidget {
  const SlidingImage({
    Key? key,
    required ValueNotifier<double> notifier,
    required ImageProvider image,
    required this.screenCount,
  })  : _image = image,
        _notifier = notifier,
        super(key: key);

  final int screenCount;
  final ImageProvider _image;
  final ValueNotifier<double> _notifier;

  @override
  _SlidingImageState createState() => _SlidingImageState();
}

class _SlidingImageState extends State<SlidingImage> {
  late double _aspectRatio;
  late double _maxWidth;

  @override
  initState() {
    // init values before the image gets loaded
    // Should be initialized as they must mot be null
    _aspectRatio = 16 / 9;
    _maxWidth = 360;

    // Get the image width and the image's aspect ratio
    getImageInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _aligner = getAlignment();

    // To Display a fullscreen image
    return OverflowBox(
      // required alignment, maxWidth
      alignment: _aligner,
      maxWidth: _maxWidth,
      child: AspectRatio(
        aspectRatio: _aspectRatio,
        child: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: widget._image,
            ),
          ),
        ),
      ),
    );
  }

  AlignmentGeometry getAlignment() {
    AlignmentGeometry _aligner;

    if (widget.screenCount == 1) {
      // single page
      _aligner = Alignment(0, 0);
    } else if (widget.screenCount == 2) {
      _aligner = Alignment(-0.5 + widget._notifier.value, 0);
    } else {
      double _offset;
      // full scroll
      // -1 to 1 is start to end
      _offset =
          mapValue(widget._notifier.value, 0, widget.screenCount - 1, -1, 1);
      // Equi scroll: scroll a fixed amount, will not reach the end
      //   _offset = -1 + (widget._notifier.value / (widget.screenCount / 2));
      _aligner = Alignment(_offset, 0);
    }
    return _aligner;
  }

  /// Gets the image width and the image's aspect ratio
  /// Then sets the state of this Widget
  void getImageInfo() async {
    widget._image.resolve(ImageConfiguration()).addListener(
          ImageStreamListener(
            (info, _) {
              setState(() {
                // Set the aspect ratio
                _aspectRatio = info.image.width / info.image.height;
                _maxWidth = info.image.width.toDouble();
              });
            },
            // If 404 :(
            onError: (info, trace) {
              // Handle it
              setState(() {});
            },
          ),
        );
  }
  mapValue(n, start1, stop1, start2, stop2) {
  return ((n - start1) / (stop1 - start1)) * (stop2 - start2) + start2;
}
}
