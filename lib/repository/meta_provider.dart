import 'package:path/path.dart';
import 'package:sonar_app/repository/repository.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:sqflite/sqflite.dart';

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
    metadata.id = await db.insert(_filesTable, metadata.writeToJsonMap());
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
      // TODO: Implement SQL Bindings for Metadata Protobuf
      //return Metadata.fromSQL(maps.first);
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
        // TODO: Implement SQL Bindings for Metadata Protobuf
        //Metadata meta = Metadata.fromSQL(element);
        //files.add(meta);
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
    return await db.update(_filesTable, metadata.writeToJsonMap(),
        where: '$_columnId = ?', whereArgs: [metadata.id]);
  }

  Future close() async => db.close();
}
