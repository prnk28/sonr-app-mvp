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
  int remainingChunks;

  // ** Constructor **
  Metadata({File file, Map map}) {
    // Set Id
    this.id = uuid.v1();

    // If File Provided
    if (file != null) {
      // Calculate File Info
      this.progress = 0.0;
      this.size = file.lengthSync();
      this.chunksTotal = (this.size / CHUNK_SIZE).ceil();
      this.currentChunkNum = 0;
      this.remainingChunks = this.chunksTotal;

      // Set File Info
      this.path = file.path;
      this.type = getFileTypeFromPath(this.path);
      this.name = basename(this.path);
    }

    // If Map Provided
    if (map != null) {
      // Set Chunking Info from Map
      this.progress = 0.0;
      this.size = map["size"];
      this.chunksTotal = map["chunks_total"];
      this.currentChunkNum = 0;
      this.remainingChunks = this.chunksTotal;

      // Set File Info from Map
      this.name = map["name"];
      this.type = enumFromString(map["type"], FileType.values);
    }
  }

  // ** Update Progress
  double addProgress() {
    // Increase Current Chunk
    this.currentChunkNum += 1;
    this.remainingChunks = this.chunksTotal - this.currentChunkNum;

    // Return Progress
    return (this.chunksTotal - this.remainingChunks) / this.chunksTotal;
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
