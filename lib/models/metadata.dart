import 'dart:io';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repository/repository.dart';

class Metadata {
  // -- SQL Fields --
  String id;
  String name;
  int size;
  FileType type;
  String path;
  Map sender;
  DateTime received;
  DateTime lastOpened;

  // -- Chunking Progress Variables --
  int chunksTotal;

  // ** Constructor **
  Metadata({File file, Map map}) {
    // Set Id
    this.id = uuid.v1();

    // If File Provided
    if (file != null) {
      // Calculate File Info
      this.size = file.lengthSync();
      this.chunksTotal = (this.size / CHUNK_SIZE).ceil();

      // Set File Info
      this.path = file.path;
      this.name = basename(this.path);
    }

    // If Map Provided
    if (map != null) {
      // Set Chunking Info from Map
      this.size = map["size"];
      this.chunksTotal = map["chunks_total"];

      // Set File Info from Map
      this.name = map["name"];
      this.type = enumFromString(map["type"], FileType.values);
    }
  }

  initialize() async {
    this.type = await getFileTypeFromPath(this.path);
    log.i("FileType: " + this.type.toString());
  }

  // ** Read Bytes from Metadata Path **
  Future<Uint8List> getBytes() async {
    Uri myUri = Uri.parse(this.path);
    File audioFile = new File.fromUri(myUri);
    Uint8List bytes;
    await audioFile.readAsBytes().then((value) {
      bytes = Uint8List.fromList(value);
      log.i('reading of bytes is completed');
    }).catchError((onError) {
      log.w('Exception Error while reading audio from path:' +
          onError.toString());
    });
    return bytes;
  }

  // ** Convert to Map **
  toMap() {
    return {
      "name": this.name,
      "size": this.size,
      "path": this.path,
      "chunks_total": this.chunksTotal,
      "type": enumAsString(this.type)
    };
  }
}
