import 'dart:typed_data';

import 'package:get/get.dart' hide Node;
import 'package:sonr_core/sonr_core.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// ** Constant Values
const DATABASE_PATH = 'transferCards.db';
const CARD_TABLE = "transfers";
enum QueryType { Payload, Platform, FirstName, LastName, Username }
final cardColumnForType = {
  QueryType.Payload: cardColumnPayload,
  QueryType.Platform: cardColumnPlatform,
  QueryType.FirstName: cardColumnFirstName,
  QueryType.LastName: cardColumnLastName,
  QueryType.Username: cardColumnUserName,
};

// ** Card Model for Transferred Data ** //
final String cardColumnId = '_id'; // integer primary key autoincrement
final String cardColumnPayload = "payload"; // text
final String cardColumnPlatform = "platform"; // text
final String cardColumnPreview = "preview"; // blob
final String cardColumnReceived = 'received'; // integer -> DateTime
final String cardColumnUserName = 'username'; // text
final String cardColumnFirstName = 'firstName'; // text
final String cardColumnLastName = 'lastName'; // text
final String cardColumnContact = 'contact'; // text -> JSON
final String cardColumnMetadata = 'metadata'; // text -> JSON
final cardColumns = [
  cardColumnId,
  cardColumnPayload,
  cardColumnPlatform,
  cardColumnPreview,
  cardColumnReceived,
  cardColumnUserName,
  cardColumnFirstName,
  cardColumnLastName,
  cardColumnContact,
  cardColumnMetadata,
];

// ** SQL Card Service ** //
class SQLService extends GetxService {
  // Database Reference
  Database _db;
  String _dbPath;

  // ** Initialize CardService ** //
  Future<SQLService> init() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    _dbPath = join(databasesPath, DATABASE_PATH);

    // Open Databases for Cards
    _db = await openDatabase(_dbPath, version: 2, onCreate: (Database db, int version) async {
      // Create Cards Table
      await db.execute('''
create table $CARD_TABLE (
  $cardColumnId integer primary key autoincrement,
  $cardColumnPayload text not null,
  $cardColumnPlatform text not null,
  $cardColumnPreview blob,
  $cardColumnReceived integer not null,
  $cardColumnUserName text not null,
  $cardColumnFirstName text not null,
  $cardColumnLastName text not null,
  $cardColumnContact text,
  $cardColumnMetadata text)
''');
    });
    return this;
  }

  // ^ Insert TransferCard into SQL DB ^ //
  Future<TransferCard> storeCard(TransferCard card) async {
    card.id = await _db.insert(CARD_TABLE, {
      // General
      cardColumnPayload: card.payload.toString().toLowerCase(),
      cardColumnPlatform: card.platform.toString().toLowerCase(),
      cardColumnPreview: Uint8List.fromList(card.preview),
      cardColumnReceived: card.received,

      // Owner Properties
      cardColumnUserName: card.username.toLowerCase(),
      cardColumnFirstName: card.firstName.toLowerCase(),
      cardColumnLastName: card.lastName.toLowerCase(),

      // Transfer Properties
      cardColumnContact: card.contact.writeToJson(),
      cardColumnMetadata: card.metadata.writeToJson(),
    });
    return card;
  }

  // ^ Delete a Metadata from SQL DB ^ //
  Future deleteCard(int id) async {
    var i = await _db.delete(CARD_TABLE, where: '$cardColumnId = ?', whereArgs: [id]);
    return i;
  }

  // ^ Get All Cards ^ //
  Future<List<TransferCard>> fetchAll() async {
    // Init List
    List<TransferCard> result = <TransferCard>[];

    // Query SQL
    List<Map> records = await _db.query(
      CARD_TABLE,
      columns: cardColumns,
    );

    // Validate Record Length
    if (records.length > 0) {
      records.forEach((e) {
        // Create TransferCard Object
        var card = createTransferCard(e);

        // Add to List
        result.add(card);
      });
    }
    // Update All Files
    return result;
  }

  // ^ Get Media Cards ^ //
  Future<List<TransferCard>> fetchMedia() async {
    // Init List
    List<TransferCard> result = <TransferCard>[];

    // Query SQL
    List<Map> records = await _db.query(
      CARD_TABLE,
      columns: cardColumns,
    );

    // Validate Record Length
    if (records.length > 0) {
      records.forEach((e) {
        // Create TransferCard Object
        var card = createTransferCard(e);

        // Add to List
        result.add(card);
      });
    }
    // Update All Files
    return result;
  }

  // ^ Query Cards by Type: Payload, Platform, Username, FirstName, LastName ^ //
  Future<Map<QueryType, List<TransferCard>>> search(String args) async {
    // Initialize Map
    Map<QueryType, List<TransferCard>> results = {};
    String queryStr = args.toLowerCase();

    // Iterate through Query Columns
    QueryType.values.forEach((type) async {
      // Initialize Result
      List<TransferCard> result = <TransferCard>[];
      String whereRows = cardColumnForType[type] + ' LIKE ?';

      // Query SQL
      List<Map> records = await _db.query(CARD_TABLE, columns: cardColumns, where: whereRows, whereArgs: ['%$queryStr%']);

      // Validate Record Length
      if (records.length > 0) {
        records.forEach((e) {
          // Create TransferCard Object
          var card = createTransferCard(e);

          // Add to List
          result.add(card);
        });
      }

      // Sort by Date
      result.sort((a, b) {
        var aDate = DateTime.fromMillisecondsSinceEpoch(a.received * 1000);
        var bDate = DateTime.fromMillisecondsSinceEpoch(b.received * 1000);
        return aDate.compareTo(bDate);
      });

      // Add Result to Map
      results[type] = result;
    });

    // Update All Files
    return results;
  }

  // ^ Helper Method to Generate Transfer Card ^ //
  TransferCard createTransferCard(Map<dynamic, dynamic> e) {
    // Clean Data
    String payload = e[cardColumnPayload].toString().toUpperCase();
    String platform = e[cardColumnPlatform].toString().capitalizeFirst;
    Uint8List preview = e[cardColumnPreview];

    // Create TransferCard Object
    return TransferCard(
        id: e[cardColumnId],
        payload: Payload.values.firstWhere((p) => p.toString() == payload),
        platform: Platform.values.firstWhere((p) => p.toString() == platform),
        preview: preview.toList(),
        received: e[cardColumnReceived],
        username: e[cardColumnUserName],
        firstName: e[cardColumnFirstName].toString().capitalizeFirst,
        lastName: e[cardColumnLastName].toString().capitalizeFirst,
        contact: Contact.fromJson(e[cardColumnContact]),
        metadata: Metadata.fromJson(e[cardColumnMetadata]));
  }

  // ** Close SQL Database ** //
  onClose() async {
    await _db.close();
  }
}
