import 'package:moor/ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:moor/moor.dart';
import 'dart:io';
import 'package:sonr_plugin/sonr_plugin.dart';
import 'cards_converter.dart';
part 'cards_db.g.dart';

enum ActivityType { Deleted, Shared, Received }

extension ActivityTypeUtils on ActivityType? {
  String get value {
    return this.toString().substring(this.toString().indexOf('.') + 1);
  }
}

@DataClassName("TransferCardActivity")
class TransferCardActivities extends Table {
  IntColumn? get id => integer().autoIncrement()();
  TextColumn? get owner => text().map(const ProfileConverter())();
  IntColumn? get mime => integer().map(const MimeConverter())();
  IntColumn? get payload => integer().map(const PayloadConverter())();
  IntColumn? get activity => integer().map(const ActivityConverter())();
}

class TransferCardItems extends Table {
  IntColumn? get id => integer().autoIncrement()();
  TextColumn? get owner => text().map(const ProfileConverter())();
  IntColumn? get mime => integer().map(const MimeConverter())();
  IntColumn? get payload => integer().map(const PayloadConverter())();
  TextColumn? get contact => text().map(const ContactConverter()).nullable()();
  TextColumn? get file => text().map(const FileConverter()).nullable()();
  TextColumn? get url => text().map(const URLConverter()).nullable()();
  DateTimeColumn? get received => dateTime()();
}

@UseMoor(tables: [TransferCardItems, TransferCardActivities])
class CardsDatabase extends _$CardsDatabase {
  CardsDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  /// Adds Share/Receive/Delete activity to Database
  Future<int> addActivity(ActivityType type, Payload payload, Profile owner, {MIME_Type mime = MIME_Type.OTHER}) {
    return into(transferCardActivities).insert(TransferCardActivitiesCompanion(
      payload: Value(payload),
      owner: Value(owner),
      mime: Value(mime),
      activity: Value(type),
    ));
  }

  /// Adds Contact/URL card to Database
  Future<int> addCard(TransferCard card) async => into(transferCardItems).insert(TransferCardItemsCompanion(
      owner: Value(card.owner),
      mime: Value.absent(),
      payload: Value(card.payload),
      contact: card.hasContact() ? Value(card.contact) : Value.absent(),
      file: card.hasFile() ? Value(card.file) : Value.absent(),
      url: card.hasUrl() ? Value(card.url) : Value.absent(),
      received: Value(DateTime.fromMillisecondsSinceEpoch(card.received * 1000))));

  /// Add File card to Database
  Future<int> addFileCard(TransferCard card) async => into(transferCardItems).insert(TransferCardItemsCompanion(
      owner: Value(card.owner),
      mime: Value(card.file.single.mime.type),
      payload: Value(card.payload),
      contact: card.hasContact() ? Value(card.contact) : Value.absent(),
      file: card.hasFile() ? Value(card.file) : Value.absent(),
      url: card.hasUrl() ? Value(card.url) : Value.absent(),
      received: Value(DateTime.fromMillisecondsSinceEpoch(card.received * 1000))));

  /// Returns all Transfer Card Items
  Future<List<TransferCardItem>> get allCardEntries => select(transferCardItems).get();

  /// Delete Single Activity from Database
  Future<void> clearActivity(TransferCardActivity activity) => (delete(transferCardActivities)..where((t) => t.id.equals(activity.id))).go();

  /// Deletes All Activity from Database
  Future<void> clearAllActivity() => delete(transferCardActivities).go();

  /// Deletes Card Item from Database with `TransferCardItem`
  Future<void> deleteCard(TransferCardItem item) => (delete(transferCardItems)..where((t) => t.id.equals(item.id))).go();

  /// Deletes Card Item from Database with id
  Future<void> deleteCardFromID(int id) => (delete(transferCardItems)..where((t) => t.id.equals(id))).go();

  /// Deletes ALL Card Items from Database
  Future<void> deleteAllCards() => delete(transferCardItems).go();

  /// Streams Activity Items from Database
  Stream<List<TransferCardActivity>> watchActivity() => (select(transferCardActivities).watch());

  /// Streams Card Items from Database
  Stream<List<TransferCardItem>> watchAll() => (select(transferCardItems).watch());

  /// Streams Contact Card Items from Database
  Stream<List<TransferCardItem>> watchContacts() => (select(transferCardItems)..where((t) => t.payload.equals(Payload.CONTACT.value))).watch();

  /// Streams Metadata Card Items from Database
  Stream<List<TransferCardItem>> watchMetadata() => (select(transferCardItems)
        ..where((t) => t.payload.equals(Payload.FILE.value) | t.payload.equals(Payload.MEDIA.value) | t.payload.equals(Payload.FILES.value)))
      .watch();

  /// Streams URL Card Items from Database
  Stream<List<TransferCardItem>> watchUrls() => (select(transferCardItems)..where((t) => t.payload.equals(Payload.URL.value))).watch();
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db_cards_2.sqlite'));
    return VmDatabase(file);
  });
}
