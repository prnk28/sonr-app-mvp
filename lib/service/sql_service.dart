import 'dart:typed_data';

import 'package:get/get.dart' hide Node;
import 'package:sonr_core/sonr_core.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// ** Constant Values
const DATABASE_PATH = 'cards.db';
const CARD_TABLE = "cards";

// ** Card Model for Transferred Data ** //
final String cardColumnId = '_id'; // integer primary key autoincrement
final String cardColumnPayload = "payload"; // text
final String cardColumnPlatform = "platform"; // text
final String cardColumnPreview = "preview"; // blob
final String cardColumnLastOpened = 'lastOpened'; // integer -> DateTime
final String cardColumnUserName = 'username'; // text
final String cardColumnFirstName = 'firstName'; // text
final String cardColumnLastName = 'lastName'; // text
final String cardColumnContact = 'contact'; // text -> JSON
final String cardColumnMetadata = 'metadata'; // text -> JSON

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
    _db = await openDatabase(_dbPath, version: 3, onCreate: (Database db, int version) async {
      // Create Cards Table
      await db.execute('''
create table $CARD_TABLE (
  $cardColumnId integer primary key autoincrement,
  $cardColumnPayload text not null,
  $cardColumnPlatform text not null,
  $cardColumnPreview blob,
  $cardColumnLastOpened integer not null,
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
      cardColumnPayload: card.payload.toString(),
      cardColumnPlatform: card.platform.toString(),
      cardColumnPreview: Uint8List.fromList(card.preview),
      cardColumnLastOpened: card.lastOpened,
      cardColumnUserName: card.username,
      cardColumnFirstName: card.firstName,
      cardColumnLastName: card.lastName,
      cardColumnContact: card.contact.toProto3Json(),
      cardColumnMetadata: card.metadata.toProto3Json(),
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
      columns: [
        cardColumnId,
        cardColumnPayload,
        cardColumnPlatform,
        cardColumnPreview,
        cardColumnLastOpened,
        cardColumnUserName,
        cardColumnFirstName,
        cardColumnLastName,
        cardColumnContact,
        cardColumnMetadata,
      ],
    );

    // Validate Record Length
    if (records.length > 0) {
      records.forEach((e) {
        // Create TransferCard Object
        TransferCard card = new TransferCard();
        card.id = e[cardColumnId];
        card.payload = e[cardColumnPayload];
        card.platform = e[cardColumnPlatform];
        card.preview = e[cardColumnPreview];
        card.lastOpened = e[cardColumnLastOpened];
        card.username = e[cardColumnUserName];
        card.firstName = e[cardColumnFirstName];
        card.lastName = e[cardColumnLastName];
        card.contact = e[cardColumnContact];
        card.metadata = e[cardColumnMetadata];

        // Add to List
        result.add(card);
      });
    }
    // Update All Files
    return result;
  }

  // ** Close SQL Database ** //
  onClose() async {
    await _db.close();
  }
}
