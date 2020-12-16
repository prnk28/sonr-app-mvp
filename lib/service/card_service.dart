import 'package:get/get.dart' hide Node;
import 'package:sonar_app/data/data.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const DATABASE_PATH = 'cards.db';

class CardService extends GetxService {
  // Database Reference
  Database _db;
  String _dbPath;

  // Observable Properties
  final allFiles = new List<Metadata>().obs;
  final allContacts = new List<Contact>().obs;

  // ** Initialize CardService ** //
  Future<CardService> init() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    _dbPath = join(databasesPath, DATABASE_PATH);

    // Open Databases for Cards
    await initMetaDb();
    await initContactDb();

    // Refresh Items
    await refreshFiles();
    await refreshContacts();
    return this;
  }

  // ** Close SQL Database ** //
  onClose() async {
    await _db.close();
  }

  // ^ Open Database create files table ^
  initMetaDb() async {
    _db = await openDatabase(_dbPath, version: 2,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $metaTable (
  $fileColumnId integer primary key autoincrement,
  $fileColumnName text not null,
  $fileColumnPath text not null,
  $fileColumnSize integer not null,
  $fileColumnMime text not null,
  $fileColumnOwner text not null,
  $fileColumnlastOpened integer not null)
''');
    });
  }

  // ^ Insert Metadata into SQL DB ^ //
  Future<Metadata> saveFile(Metadata metadata) async {
    metadata.id = await _db.insert(metaTable, metaToSQL(metadata));
    await refreshFiles();
    return metadata;
  }

  // ^ Delete a Metadata from SQL DB ^ //
  Future deleteFile(int id) async {
    await _db.delete(metaTable, where: '$fileColumnId = ?', whereArgs: [id]);
    await refreshFiles();
  }

  // ^ Update Metadata in DB ^ //
  Future updateFile(Metadata metadata) async {
    await _db.update(metaTable, metaToSQL(metadata),
        where: '$fileColumnId = ?', whereArgs: [metadata.id]);
    await refreshContacts();
  }

  // ^ Get All Files ^ //
  refreshFiles() async {
    // Init List
    List<Metadata> result = new List<Metadata>();
    List<Map> records = await _db.query(
      metaTable,
      columns: [
        fileColumnId,
        fileColumnName,
        fileColumnPath,
        fileColumnSize,
        fileColumnMime,
        fileColumnOwner,
        fileColumnlastOpened
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

  // ^ Open Database create contacts table ^
  initContactDb() async {
    _db = await openDatabase(_dbPath, version: 2,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $contactTable (
  $contactColumnId integer primary key autoincrement,
  $contactColumnFirstName text not null,
  $contactColumnLastName text not null,
  $contactColumnData text not null,
  $contactColumnlastOpened integer not null)
''');
    });
  }

  // ^ Insert Contact into SQL DB ^ //
  Future<Contact> saveContact(Contact contact) async {
    await _db.insert(contactTable, contactToSQL(contact));
    await refreshContacts();
    return contact;
  }

  // ^ Delete a Contact from SQL DB ^ //
  Future deleteContact(int id) async {
    await _db.delete(contactTable, where: '$fileColumnId = ?', whereArgs: [id]);
    await refreshContacts();
  }

  // // ^ Update Contact in DB ^ //
  // Future updateContact(Contact contact) async {
  //   await _db.update(contactTable, contactToSQL(contact),
  //       where: '$fileColumnId = ?', whereArgs: [contact.id]);
  //   await refreshFiles();
  // }

  // ^ Get All Contacts ^ //
  refreshContacts() async {
    // Init List
    List<Contact> result = new List<Contact>();
    List<Map> records = await _db.query(
      contactTable,
      columns: [
        contactColumnId,
        contactColumnFirstName,
        contactColumnLastName,
        contactColumnData,
        contactColumnlastOpened
      ],
    );
    if (records.length > 0) {
      // Convert Each Record into Object
      records.forEach((element) {
        // Implement SQL Bindings for Metadata Protobuf
        Contact meta = contactFromSQL(element);
        result.add(meta);
      });
    }

    // Update All Files
    allContacts(result);
  }
}
