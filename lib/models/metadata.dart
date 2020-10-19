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
  double progress;
  int currentChunkNum;

  // ** Constructor **
  Metadata(File file) {
    // Check if File Provided
    if (file != null) {
      // Set Default Variables
      this.id = uuid.v1();
      this.currentChunkNum = 0;
      this.progress = 0.0;

      // Calculate File Info
      this.size = file.lengthSync();
      this.chunksTotal = (this.size / CHUNK_SIZE).ceil();

      // Set File Info
      this.path = file.path;
      this.type = getFileTypeFromPath(this.path);
      this.name = basename(this.path);
    }
  }

  // ** Build Metadata from Map **
  static fromMap(Map map) {
    // Init Metadata Object
    Metadata meta = new Metadata(null);

    // Set Default Variables
    meta.id = uuid.v1();
    meta.currentChunkNum = 0;
    meta.progress = 0.0;

    // Set from Map
    meta.size = map["size"];
    meta.chunksTotal = map["chunks_total"];
    meta.name = map["name"];
    meta.type = enumFromString(map["type"], FileType.values);

    // Return
    return meta;
  }

  // ** Update Progress
  double addProgress(Role role) {
    // Increase Current Chunk
    this.currentChunkNum += 1;

    // Find Remaining
    var remainingChunks = this.chunksTotal - this.currentChunkNum;

    // Calculate Progress
    this.progress = (this.chunksTotal - remainingChunks) / this.chunksTotal;

    // Logging
    log.i(enumAsString(role) +
        "Current= " +
        this.currentChunkNum.toString() +
        ". Remaining= " +
        remainingChunks.toString() +
        "-- " +
        (this.progress * 100).toString() +
        "%");

    // Return
    return this.progress;
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
