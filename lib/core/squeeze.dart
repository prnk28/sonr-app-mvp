import 'package:image/image.dart';
import 'dart:isolate';
import 'dart:io';

class SqueezeParam {
  final File file;
  final SendPort sendPort;
  SqueezeParam(this.file, this.sendPort);
}

class Squeeze {
  static void imageForBytes(SqueezeParam param) {
    // Read an image from file
    Image image = decodeImage(param.file.readAsBytesSync());

    // Resize the image to a 120x? thumbnail
    Image thumbnail = copyResize(image, width: 120);

    // Return thumbnail
    param.sendPort.send(thumbnail);
  }
}
