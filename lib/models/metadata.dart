import 'package:sonar_app/core/core.dart';

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

  // ** Convert to Map **
  toMap() {
    return {
      "name": this.name,
      "size": this.size,
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
