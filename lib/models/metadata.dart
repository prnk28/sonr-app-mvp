import 'dart:io';

import 'package:hive/hive.dart';
import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/repository/repository.dart';
import 'package:uuid/uuid.dart';

@HiveType()
class Metadata extends HiveObject {
  // -- Stored Metadata --
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int size;

  @HiveField(3)
  FileType type;

  @HiveField(4)
  String path;

  @HiveField(5)
  Map sender;

  @HiveField(6)
  DateTime received;

  @HiveField(7)
  DateTime lastOpened;

  // -- Chunking Progress Variables --
  int chunksTotal;
  double progress;
  int currentChunkNum;
  int remainingChunks;

  Metadata({File file, Map map}) {
    // Set Id
    var uuid = Uuid();
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
      this.remainingChunks = this.chunksTotal;

      // Set File Info from Map
      this.name = map["name"];
      this.type = enumFromString(map["type"], FileType.values);
    }
  }

  // Send with Offer
  toMap() {
    return {
      "name": this.name,
      "size": this.size,
      "path": this.path,
      "chunks_total": this.chunksTotal,
      "type": enumAsString(this.type)
    };
  }

  // ** Method to Print Model **
   read() {
    log.i("Metadata #" + this.id);
    print(this.toMap().toString());
  }
}

class MetadataAdapter extends TypeAdapter<Metadata> {
  @override
  final typeId = 1;

  @override
  Metadata read(BinaryReader reader) {
    return Metadata()..id = reader.read();
  }

  @override
  void write(BinaryWriter writer, Metadata obj) {
    writer.write(obj.id);
  }
}
