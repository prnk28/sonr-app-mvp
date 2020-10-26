import 'package:image/image.dart';
import 'package:file/memory.dart';
import 'dart:io';

class Squeeze {
  static File imageForBytes(File file) {
    // Read an image from file
    Image image = decodeImage(file.readAsBytesSync());

    // Resize the image to a 120x? thumbnail
    Image thumbnail = copyResize(image, width: 120);

    // Save the thumbnail in memory as a PNG.
    File thumbFile = MemoryFileSystem().file('thumbnail.png')
      ..writeAsBytesSync(encodePng(thumbnail));

    // Return thumbnail
    return thumbFile;
  }
}
