import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/repository/repository.dart';

class Metadata {
  // Reference to JSON Map
  static Map fileTypes;

  // -- Properties --
  String id = uuid.v1();
  String name;
  int size;
  int chunksTotal;
  FileType type;
  String path;
  Map sender;
  DateTime received;
  DateTime lastOpened;

  // ** Constructer: Get MetaData from Map ** //
  static Metadata fromMap(Map map) {
    Metadata temp = new Metadata();
    // Set Chunking Info from Map
    temp.size = map["size"];
    temp.chunksTotal = map["chunks_total"];

    // Set File Info from Map
    temp.name = map["name"];
    temp.type = enumFromString(map["type"], FileType.values);
    return temp;
  }

  // ** Constructer: Get MetaData from File ** //
  static Metadata fromFile(File file) {
    Metadata temp = new Metadata();
    // Calculate File Info
    temp.size = file.lengthSync();
    temp.chunksTotal = (temp.size / CHUNK_SIZE).ceil();
    temp.type = getFileTypeFromPath(temp.path);

    // Set File Info
    temp.path = file.path;
    temp.name = basename(temp.path);
    return temp;
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

// ******************** //
// ** FileType Enum ** //
// ******************** //
// -- FileType Enum --
enum FileType {
  Audio,
  Compressed,
  Data,
  Image,
  Presentation,
  Spreadsheet,
  Unknown,
  Video,
  Word
}

// -- Get FileType Method --
getFileTypeFromPath(path) {
  // Get File Extension
  var kind = extension(path);
  log.i(kind);

  // Init Type
  FileType type = FileType.Unknown;

  // Iterate
  Metadata.fileTypes.forEach((key, value) {
    if (key == kind) {
      type = enumFromString(value, FileType.values);
    }
  });
  return type;
}
