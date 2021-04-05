import 'package:get/get.dart' hide Node;
import 'package:intl/intl.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:sonr_core/sonr_core.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'media.dart';

// ** Constant Values
const DATABASE_PATH = 'transferCards.db';
const CARD_TABLE = "transfers";
const K_QUERY_CATEGORY_COUNT = 5;
enum QueryCategory { Payload, Platform, FirstName, LastName, Username, Month, Day, Year }
final cardColumnForType = {
  QueryCategory.Payload: cardColumnPayload,
  QueryCategory.Platform: cardColumnOwner,
  QueryCategory.FirstName: cardColumnFirstName,
  QueryCategory.LastName: cardColumnLastName,
  QueryCategory.Username: cardColumnUserName,
  QueryCategory.Month: cardColumnMonth,
  QueryCategory.Year: cardColumnYear,
  QueryCategory.Day: cardColumnDay,
};

// ** Card Model for Transferred Data ** //
final String cardColumnId = '_id'; // integer primary key autoincrement
final String cardColumnPayload = "payload"; // text
final String cardColumnOwner = "owner"; // text
final String cardColumnReceived = 'received'; // integer -> DateTime
final String cardColumnMonth = 'month'; // integer -> DateTime
final String cardColumnDay = 'day'; // integer -> DateTime
final String cardColumnYear = 'year'; // integer -> DateTime
final String cardColumnUserName = 'username'; // text
final String cardColumnFirstName = 'firstName'; // text
final String cardColumnLastName = 'lastName'; // text
final String cardColumnContact = 'contact'; // text -> JSON
final String cardColumnMetadata = 'metadata'; // text -> JSON
final cardColumns = [
  cardColumnId,
  cardColumnPayload,
  cardColumnOwner,
  cardColumnReceived,
  cardColumnMonth,
  cardColumnYear,
  cardColumnDay,
  cardColumnUserName,
  cardColumnFirstName,
  cardColumnLastName,
  cardColumnContact,
  cardColumnMetadata,
];

// ** SQL Card Service ** //
class SQLService extends GetxService {
  // Accessors
  static bool get isRegistered => Get.isRegistered<SQLService>();
  static SQLService get to => Get.find<SQLService>();

  // Database Reference
  Database _db;
  String _dbPath;

  final cards = <TransferCard>[].obs;
  final contacts = <TransferCard>[].obs;
  final media = <TransferCard>[].obs;

  // ** Initialize CardService ** //
  Future<SQLService> init() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    _dbPath = join(databasesPath, DATABASE_PATH);

    // Open Databases for Cards
    _db = await openDatabase(_dbPath, version: 1, onCreate: (Database db, int version) async {
      // Create Cards Table
      await db.execute('''
create table $CARD_TABLE (
  $cardColumnId integer primary key autoincrement,
  $cardColumnPayload text not null,
  $cardColumnReceived integer not null,
  $cardColumnMonth text not null,
  $cardColumnYear integer not null,
  $cardColumnDay integer not null,
  $cardColumnOwner text not null,
  $cardColumnUserName text not null,
  $cardColumnFirstName text not null,
  $cardColumnLastName text not null,
  $cardColumnContact text,
  $cardColumnMetadata text)
''');
    });
    refreshCards();
    return this;
  }

  // ^ Insert TransferCard into SQL DB ^ //
  Future<TransferCard> storeCard(TransferCard card) async {
    // Format Received Date
    var date = DateTime.fromMillisecondsSinceEpoch(card.received * 1000);
    var formatter = new DateFormat('MMMM');

    if (card.hasMetadata()) {
      AssetEntity asset = await MediaService.saveTransfer(card.metadata);
      card.metadata.id = asset.id;

      // Insert Card
      card.id = await _db.insert(CARD_TABLE, {
        // General
        cardColumnPayload: card.payload.toString().toLowerCase(),

        cardColumnReceived: card.received,
        cardColumnMonth: formatter.format(date),
        cardColumnYear: date.year,
        cardColumnDay: date.day,

        // Owner Properties
        cardColumnUserName: card.username.toLowerCase(),
        cardColumnFirstName: card.firstName.toLowerCase(),
        cardColumnLastName: card.lastName.toLowerCase(),

        // Transfer Properties
        cardColumnOwner: card.owner.writeToJson(),
        cardColumnContact: card.contact.writeToJson(),
        cardColumnMetadata: card.metadata.writeToJson(),
      });
    } else {
      // Insert Card
      card.id = await _db.insert(CARD_TABLE, {
        // General
        cardColumnPayload: card.payload.toString().toLowerCase(),

        cardColumnReceived: card.received,
        cardColumnMonth: formatter.format(date),
        cardColumnYear: date.year,
        cardColumnDay: date.day,

        // Owner Properties
        cardColumnUserName: card.username.toLowerCase(),
        cardColumnFirstName: card.firstName.toLowerCase(),
        cardColumnLastName: card.lastName.toLowerCase(),

        // Transfer Properties
        cardColumnOwner: card.owner.writeToJson(),
        cardColumnContact: card.contact.writeToJson(),
        cardColumnMetadata: card.metadata.writeToJson(),
      });
    }

    // Refresh Cards and Return
    refreshCards();
    return card;
  }

  // ^ Delete a Metadata from SQL DB ^ //
  void deleteCard(int id) async {
    await _db.delete(CARD_TABLE, where: '$cardColumnId = ?', whereArgs: [id]);
    refreshCards();
  }

  // ^ Get All Cards ^ //
  void refreshCards() async {
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
        var card = cardFromMap(e);

        // Add to List
        result.add(card);
      });
    }
    // Group Cards
    var allCards = result.reversed.toList();
    var contactList = <TransferCard>[];
    var mediaList = <TransferCard>[];

    // Organize Cards
    allCards.forEach((c) {
      if (c.payload == Payload.MEDIA) {
        mediaList.add(c);
      } else if (c.payload == Payload.CONTACT) {
        contactList.add(c);
      }
    });

    // Update Reactive Lists
    cards.assignAll(allCards);
    contacts.assignAll(contactList);
    media.assignAll(mediaList);

    // Refresh Lists
    cards.refresh();
    contacts.refresh();
    media.refresh();
  }

  // ^ Get Total Card Count ^ //
  Future<int> getCount() async {
    // Query SQL
    List<Map> records = await _db.query(
      CARD_TABLE,
      columns: cardColumns,
    );

    // Return Length
    return records.length;
  }

  // ^ Query Cards by Type: Payload, Platform, Username, FirstName, LastName ^ //
  Future<Map<QueryCategory, List<TransferCard>>> search(String args) async {
    // Initialize Map
    Map<QueryCategory, List<TransferCard>> results = {};
    String queryStr = args.toLowerCase();

    // Iterate through Query Columns
    QueryCategory.values.forEach((type) async {
      // Initialize Result
      List<TransferCard> result = <TransferCard>[];
      String whereRows = cardColumnForType[type] + ' LIKE ?';

      // Query SQL
      List<Map> records = await _db.query(CARD_TABLE, columns: cardColumns, where: whereRows, whereArgs: ['%$queryStr%']);

      // Validate Record Length
      if (records.length > 0) {
        records.forEach((e) {
          // Create TransferCard Object
          var card = cardFromMap(e);

          // Add to List
          result.add(card);
        });
      }

      // Add Result to Map
      results[type] = result.reversed.toList();
    });

    // Update All Files
    return results;
  }

  // ^ Helper Method to Generate Transfer Card ^ //
  TransferCard cardFromMap(Map<dynamic, dynamic> e) {
    // Clean Data
    String payload = e[cardColumnPayload].toString().toUpperCase();

    // Create TransferCard Object
    return TransferCard(
        id: e[cardColumnId],
        payload: Payload.values.firstWhere((p) => p.toString() == payload, orElse: () => Payload.UNDEFINED),
        received: e[cardColumnReceived],
        username: e[cardColumnUserName],
        firstName: e[cardColumnFirstName].toString().capitalizeFirst,
        lastName: e[cardColumnLastName].toString().capitalizeFirst,
        owner: Profile.fromJson(e[cardColumnOwner]),
        contact: Contact.fromJson(e[cardColumnContact]),
        metadata: Metadata.fromJson(e[cardColumnMetadata]));
  }

  // ** Close SQL Database ** //
  onClose() async {
    await _db.close();
  }
}
