//import 'package:sonar_app/database/database.dart';
import 'dart:io';
import 'package:get/get.dart' hide Node;
import 'package:sonar_app/data/data.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const DATABASE_PATH = 'localData.db';

class FileService extends GetxService {
  // Database Reference
  Database _db;

  // Observable Properties
  final allFiles = new List<Metadata>().obs;
  File currentFile;
  Metadata currentMetadata;

  Future<FileService> init() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, DATABASE_PATH);

    // Open Database create files table
    _db = await openDatabase(path, version: 2,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $metaTable (
  $columnId integer primary key autoincrement,
  $columnName text not null,
  $columnPath text not null,
  $columnSize integer not null,
  $columnMime text not null,
  $columnOwner text not null,
  $columnlastOpened integer not null)
''');
    });
    await refreshAllFiles();
    return this;
  }

  // ^ Get a File from Metadata ^ //
  getFile(Metadata meta) async {
    // Set Data
    currentMetadata = meta;
    currentFile = File(meta.path);
  }

  // ^ Insert Metadata into SQL DB ^ //
  Future<Metadata> saveMeta(Metadata metadata) async {
    metadata.id = await _db.insert(metaTable, metaToSQL(metadata));
    await refreshAllFiles();
    return metadata;
  }

  // ^ Delete a Metadata from SQL DB ^ //
  Future deleteMeta(int id) async {
    await _db.delete(metaTable, where: '$columnId = ?', whereArgs: [id]);
    await refreshAllFiles();
  }

  // ^ Update Metadata in DB ^ //
  Future updateMeta(Metadata metadata) async {
    await _db.update(metaTable, metaToSQL(metadata),
        where: '$columnId = ?', whereArgs: [metadata.id]);
    await refreshAllFiles();
  }

  // ^ Close SQL Database ^ //
  onClose() async {
    await _db.close();
  }

  // ^ Get All Files ^ //
  refreshAllFiles() async {
    // Init List
    List<Metadata> result = new List<Metadata>();

    // Get Records
    List<Map> records = await _db.query(
      metaTable,
      columns: [
        columnId,
        columnName,
        columnPath,
        columnSize,
        columnMime,
        columnOwner,
        columnlastOpened
      ],
    );
    if (records.length > 0) {
      // Convert Each Record into Object
      records.forEach((element) {
        // Implement SQL Bindings for Metadata Protobuf
        Metadata meta = metaFromSQL(element);
        result.add(meta);
      });
    }

    // Update All Files
    allFiles(result);
  }
}
