part of 'detail.dart';

class ImageDetailView extends StatefulWidget {
  final Uint8List bytes;
  final Metadata metadata;

  const ImageDetailView(this.bytes, this.metadata, {Key key}) : super(key: key);
  @override
  _ImageDetailViewState createState() => _ImageDetailViewState();
}

class _ImageDetailViewState extends State<ImageDetailView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
            child: PhotoView(
          backgroundDecoration: windowDecoration(context),
          imageProvider: MemoryImage(widget.bytes),
          loadingBuilder: (context, progress) => Center(
            child: Container(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(),
            ),
          ),
          // enableRotation: true,
        )),

        // Spacing
        Padding(padding: EdgeInsets.only(top: 20)),
        // Additional Info
        _buildInfo(widget.metadata)
        // Image
      ],
    );
  }
}

_buildInfo(Metadata metadata) {
  // Init Formatters
  DateFormat dateFormat = new DateFormat.yMMMMd('en_US');
  DateFormat timeFormat = new DateFormat.jm();

  // Create Strings
  var opened = DateTime.fromMillisecondsSinceEpoch(metadata.lastOpened);
  String date = dateFormat.format(opened);
  String time = timeFormat.format(opened);

  // Build View
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    // Owner Info
    Column(children: [
      Text(metadata.owner.firstName),
      Text(metadata.owner.lastName),
    ]),

    // Spacing
    Padding(padding: EdgeInsets.only(left: 10, right: 20)),

    // File Info
    Column(children: [
      Text(_convertSize(metadata.size)),
      Text(date),
      Text(time),
    ])
  ]);
}

String _convertSize(int size) {
  // Byte Size
  if (size < 1000) {
    return size.toString() + "B";
  }
  // Kilobyte Size
  else if (size >= 1000 && size < pow(1000, 2)) {
    return (size / 1000).toStringAsFixed(2) + "KB";
  }
  // Megabyte Size
  else if (size >= pow(1000, 2) && size < pow(1000, 3)) {
    return (size / pow(1000, 2)).toStringAsFixed(2) + "MB";
  }
  // Gigabyte Size
  else {
    return (size / pow(1000, 3)).toStringAsFixed(2) + "GB";
  }
}
