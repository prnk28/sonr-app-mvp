// Dart Packages
import 'dart:async';
import 'dart:convert';
import 'dart:html';

// Flutter Packages
import 'package:flutter/material.dart';

class BlobManager {
  static Future<Blob> blobFromImage(image) async {
    List<int> bytes = await image.readAsBytes();
    return Blob(bytes);
  }

  static Image imageFromBlob(Blob blob) {
    var uintlist = base64.decode(blob.toString());
    return new Image.memory(uintlist);
  }
}
