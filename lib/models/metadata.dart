import 'package:sonar_app/core/core.dart';
import 'package:sonar_app/models/models.dart';
import 'package:sonar_app/repository/repository.dart';
import 'package:image/image.dart';
import 'package:file/memory.dart';

// File Table Fields
final String _filesTable = "files";
final String _columnId = '_id';
final String _columnName = 'name';
final String _columnSize = 'size';
final String _columnType = 'type';
final String _columnPath = 'path';
final String _columnOwner = 'owner';
final String _columnThumbnail = 'thumbnail';
final String _columnReceived = 'received';
final String _columnLastOpened = 'lastOpened';

// ** FileType Enum ** //
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

// ** Metadata Class ** //
class Metadata {
  // Reference to JSON Map
  static Map fileTypes;

  // -- Properties --
  int id;
  String name;
  Profile owner;
  int size;
  Uint8List thumbnail;
  FileType type = FileType.Unknown;

  // -- Generated --
  bool isValid;
  String path;
  DateTime received;
  DateTime lastOpened;

  // ** Constructer: Default ** //
  Metadata(Node user, File file) {
    // Set Properties
    this.name = basename(file.path);
    this.owner = user.profile;
    this.path = file.path;
    this.size = file.lengthSync();

    // Set File Type
    Metadata.fileTypes.forEach((key, value) {
      // Find type by extension
      if (key == extension(file.path)) {
        this.type = enumFromString(value, FileType.values);
      }
    });

    // Check if Valid
    isValid = (this.name != null &&
        this.owner != null &&
        this.size != null &&
        this.type != null);
  }

  // ** Constructer: Get MetaData from Map ** //
  Metadata.fromMap(Map map) {
    this.owner = Profile.fromMap(map["owner"]);
    this.name = map["name"];
    this.size = map["size"];
    this.type = enumFromString(map["type"], FileType.values);

    // Check if Valid
    isValid = (this.name != null &&
        this.owner != null &&
        this.size != null &&
        this.type != null);

    // Set Preview
    if (map["thumbnail"] != null) {
      // Get List of int
      List<int> thumbList = new List<int>.from(map["thumbnail"]);

      // Convert to Uint8List
      this.thumbnail = Uint8List.fromList(thumbList);
    }
  }

  // ** Creates file at Metadata Path ** //
  createFile() async {
    // Check if Properties exist
    if (this.isValid && this.path == null) {
      // Get Identifier
      String type = '/' + enumAsString(this.type);

      // Get Directory - Reset when app deleted
      Directory localDir = await getApplicationDocumentsDirectory();

      // Set Path
      this.path = localDir.path + type + '_' + uuid.v1() + "_" + this.name;
      this.received = DateTime.now();

      // Create File
      await new File(this.path).create(recursive: true);
    }
  }

  // ** Create Thumbnail for File ** //
  createThumbnail() async {
    // Create Receive Port
    ReceivePort receivePort = ReceivePort();

    // Compress if Image for Preview
    if (this.type == FileType.Image) {
      // Isolate to avoid stalling the main UI
      await Isolate.spawn(Squeeze.imageForBytes,
          SqueezeParam(new File(this.path), receivePort.sendPort));

      // Get the processed image from the isolate.
      Image thumbnail = await receivePort.first;

      // Save the thumbnail in memory as a PNG.
      File thumbFile = MemoryFileSystem().file('thumbnail.jpg')
        ..writeAsBytesSync(encodeJpg(thumbnail, quality: 50));

      // Set Thumbnail
      this.thumbnail = await thumbFile.readAsBytes();
    } else {
      log.w("No compression for non-images yet");
    }
    // Close Port
    receivePort.close();
  }

  // ** Convert to Map **
  toMap() {
    // Initialize Map
    var map = {
      "name": this.name,
      "size": this.size,
      "owner": this.owner.toMap(),
      "type": enumAsString(this.type)
    };

    // Check for preview
    if (this.thumbnail != null) {
      map["thumbnail"] = this.thumbnail.toList(growable: false);
    }

    // Return Map
    return map;
  }

  // ** Constructer: Get MetaData from SQL Map ** //
  Metadata.fromSQL(Map map) {
    this.id = map[_columnId];
    this.name = map[_columnName];
    this.size = map[_columnSize];
    this.type = enumFromString(map[_columnType], FileType.values);
    this.path = map[_columnPath];
    this.owner = Profile.fromString(map[_columnOwner]);
    this.received = DateTime.fromMillisecondsSinceEpoch(map[_columnReceived]);
    this.lastOpened =
        DateTime.fromMillisecondsSinceEpoch(map[_columnLastOpened]);

    // Set Thumbnail
    if (map[_columnThumbnail] != null) {
      this.thumbnail = map[_columnThumbnail];
    }
  }

  // ** Convert to SQL Map **
  toSQL() {
    // Create Map
    var map = <String, dynamic>{
      _columnName: this.name,
      _columnSize: this.size,
      _columnType: enumAsString(this.type),
      _columnPath: this.path,
      _columnOwner: this.owner.toString(),
      _columnReceived: this.received.millisecondsSinceEpoch
    };

    // Check if Id Provided
    if (this.id != null) {
      map[_columnId] = this.id;
    }

    // Check for Thumbnail
    if (this.thumbnail != null) {
      map[_columnThumbnail] = this.thumbnail;
    }

    // Check if ever opened
    if (this.lastOpened != null) {
      map[_columnLastOpened] = this.lastOpened.millisecondsSinceEpoch;
    } else {
      map[_columnLastOpened] = DateTime.now().millisecondsSinceEpoch;
    }

    return map;
  }
}

// ****************** //
// ** SQL Provider ** //
// ****************** //
class MetadataProvider {
  Database db;

  Future open() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, DATABASE_PATH);

// Open Database create files table
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $_filesTable ( 
  $_columnId integer primary key autoincrement, 
  $_columnName text not null,
  $_columnSize integer not null,
  $_columnType text not null,
  $_columnPath text not null,
  $_columnOwner text not null,
  $_columnThumbnail blob,
  $_columnReceived integer not null,
  $_columnLastOpened integer not null)
''');
    });
  }

  Future<Metadata> insert(Metadata metadata) async {
    metadata.id = await db.insert(_filesTable, metadata.toSQL());
    return metadata;
  }

  Future<Metadata> getFile(int id) async {
    List<Map> maps = await db.query(_filesTable,
        columns: [
          _columnId,
          _columnName,
          _columnSize,
          _columnType,
          _columnPath,
          _columnOwner,
          _columnThumbnail,
          _columnReceived,
          _columnLastOpened
        ],
        where: '$_columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Metadata.fromSQL(maps.first);
    }
    return null;
  }

  Future<List<Metadata>> getAllFiles() async {
    // Get Records
    List<Map> records = await db.query(
      _filesTable,
      columns: [
        _columnId,
        _columnName,
        _columnSize,
        _columnType,
        _columnPath,
        _columnOwner,
        _columnThumbnail,
        _columnReceived,
        _columnLastOpened
      ],
    );
    if (records.length > 0) {
      // Init List
      List<Metadata> files = new List<Metadata>();

      // Convert Each Record into Object
      records.forEach((element) {
        Metadata meta = Metadata.fromSQL(element);
        files.add(meta);
      });

      // Return List
      return files;
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db
        .delete(_filesTable, where: '$_columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Metadata metadata) async {
    return await db.update(_filesTable, metadata.toMap(),
        where: '$_columnId = ?', whereArgs: [metadata.id]);
  }

  Future close() async => db.close();
}
