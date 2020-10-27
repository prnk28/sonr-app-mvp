part of 'detail.dart';

Widget buildImageView(
  Uint8List bytes,
  Metadata metadata,
) {
  return Column(
    children: [
      // Image Container
      Container(
          width: screenSize.width,
          child: Center(
              child: FadeInImage(
            placeholder: MemoryImage(kTransparentImage),
            image: MemoryImage(bytes),
          ))),

      // File Type
      Text(enumAsString(metadata.type)),

      // Additional Info
      _buildInfo(metadata)
      // Image
    ],
  );
}

_buildInfo(Metadata metadata) {
  // Init Formatters
  DateFormat dateFormat = new DateFormat.yMMMMd('en_US');
  DateFormat timeFormat = new DateFormat.jm();

  // Create Strings
  String date = dateFormat.format(metadata.received);
  String time = timeFormat.format(metadata.received);

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
      Text(metadata.name),
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

String _convertDate(DateTime date) {
  // Init Formatters
  DateFormat formatter = new DateFormat.yMMMMd('en_US').add_jm();

  // Create String
  return formatter.format(date);
}
