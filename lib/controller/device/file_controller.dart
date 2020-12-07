//import 'package:sonar_app/database/database.dart';
import 'dart:io';
import 'package:get/get.dart' hide Node;
import 'package:sonar_app/ui/ui.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const DATABASE_PATH = 'localData.db';

class FileController extends GetxController {
  // Database Reference
  Database db;

  // Observable Properties
  var allFiles = new List<Metadata>().obs;
  var currentFile = Rx<File>();
  var currentMetadata = Rx<Metadata>();

  onInit() async {
    super.onInit();
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, DATABASE_PATH);

    // Open Database create files table
    db = await openDatabase(path, version: 1,
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
    print(databasesPath);
    await _refreshAllFiles();
  }

  // ^ Get a File from Metadata ^ //
  getFile(Metadata meta) async {
    // Set Data
    currentMetadata(meta);
    currentFile(File(meta.path));
  }

  // ^ Insert Metadata into SQL DB ^ //
  Future<Metadata> insertMeta(Metadata metadata) async {
    metadata.id = await db.insert(metaTable, metaToSQL(metadata));
    await _refreshAllFiles();
    return metadata;
  }

  // ^ Delete a Metadata from SQL DB ^ //
  Future deleteMeta(int id) async {
    await db.delete(metaTable, where: '$columnId = ?', whereArgs: [id]);
    await _refreshAllFiles();
  }

  // ^ Update Metadata in DB ^ //
  Future updateMeta(Metadata metadata) async {
    await db.update(metaTable, metaToSQL(metadata),
        where: '$columnId = ?', whereArgs: [metadata.id]);
    await _refreshAllFiles();
  }

  // ^ Close SQL Database ^ //
  dispose() async {
    super.dispose();
    await db.close();
  }

  // ^ Get All Files ^ //
  _refreshAllFiles() async {
    // Init List
    List<Metadata> result = new List<Metadata>();
    // Get Records
    List<Map> records = await db.query(
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
