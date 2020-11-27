import 'package:path/path.dart';
import 'package:sonar_app/repository/repository.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:sqflite/sqflite.dart';

// File Table Fields
final String _metaTable = "metadata";
final String _columnId = '_id';
final String _columnUuid = 'uuid';
final String _columnName = 'name';
final String _columnPath = 'path';
final String _columnSize = 'size';
final String _columnChunks = 'chunks';
final String _columnMime = 'mime';
final String _columnOwner = 'owner';
final String _columnlastOpened = 'lastOpened';

class MetadataProvider {
  // Database Reference
  Database db;

// *************************
// ** Database Management **
// *************************
  // ^ Open SQL Database ^ //
  Future open() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, DATABASE_PATH);

    // Open Database create files table
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $_metaTable ( 
  $_columnId integer primary key autoincrement, 
  $_columnUuid text not null,
  $_columnName text not null,
  $_columnPath text not null,
  $_columnSize integer not null,
  $_columnChunks integer not null,
  $_columnMime text not null,
  $_columnOwner text not null,
  $_columnlastOpened integer not null)
''');
    });
  }

  // ^ Insert Metadata into SQL DB ^ //
  Future<Metadata> insert(Metadata metadata) async {
    metadata.id =
        await db.insert(_metaTable, MetadataProvider.toSQL(metadata));
    return metadata;
  }

  // ^ Get One Metadata from SQL DB ^ //
  Future<Metadata> getFile(int id) async {
    List<Map> maps = await db.query(_metaTable,
        columns: [
          _columnId,
          _columnUuid,
          _columnName,
          _columnPath,
          _columnSize,
          _columnChunks,
          _columnMime,
          _columnOwner,
          _columnlastOpened
        ],
        where: '$_columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      // Implement SQL Bindings for Metadata Protobuf
      return MetadataProvider.fromSQL(maps.first);
    }
    return null;
  }

  // ^ Get All Metadata from SQL DB ^ //
  Future<List<Metadata>> getAllFiles() async {
    // Get Records
    List<Map> records = await db.query(
      _metaTable,
      columns: [
        _columnId,
        _columnUuid,
        _columnName,
        _columnPath,
        _columnSize,
        _columnChunks,
        _columnMime,
        _columnOwner,
        _columnlastOpened
      ],
    );
    if (records.length > 0) {
      // Init List
      List<Metadata> files = new List<Metadata>();

      // Convert Each Record into Object
      records.forEach((element) {
        // Implement SQL Bindings for Metadata Protobuf
        Metadata meta = MetadataProvider.fromSQL(element);
        files.add(meta);
      });

      // Return List
      return files;
    }
    return null;
  }

  // ^ Delete a Metadata from SQL DB ^ //
  Future<int> delete(int id) async {
    return await db
        .delete(_metaTable, where: '$_columnId = ?', whereArgs: [id]);
  }

  // ^ Update Metadata in DB ^ //
  Future<int> update(Metadata metadata) async {
    return await db.update(_metaTable, MetadataProvider.toSQL(metadata),
        where: '$_columnId = ?', whereArgs: [metadata.id]);
  }

  // ^ Close SQL Database ^ //
  Future close() async => db.close();

// *********************
// ** Metadata to SQL **
// *********************
  // @ Convert to SQL Map to Store
  static Map toSQL(Metadata meta) {
    // Create Map
    var map = <String, dynamic>{
      _columnUuid: meta.uuid,
      _columnName: meta.name,
      _columnPath: meta.path,
      _columnSize: meta.size,
      _columnChunks: meta.chunks,
      _columnMime: meta.mime.writeToJson(),
      _columnOwner: meta.owner.writeToJson(),
      _columnlastOpened: meta.lastOpened,
    };

    // Check if Id Provided
    if (meta.id != null) {
      map[_columnId] = meta.id;
    }
    return map;
  }

  // @ Convert from SQL Map to Read
  static Metadata fromSQL(Map map) {
    Metadata meta = new Metadata();
    meta.id = map[_columnId];
    meta.uuid = map[_columnUuid];
    meta.name = map[_columnName];
    meta.path = map[_columnPath];
    meta.size = map[_columnSize];
    meta.chunks = map[_columnChunks];
    meta.mime = Metadata_MIME.fromJson(map[_columnMime]);
    meta.owner = Peer.fromJson(map[_columnOwner]);
    meta.lastOpened = map[_columnlastOpened];
    return meta;
  }
}
