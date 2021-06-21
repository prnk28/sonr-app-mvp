import 'package:moor/ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:moor/moor.dart';
import 'dart:io';
import 'package:sonr_plugin/sonr_plugin.dart';
import 'converter.dart';
part 'database.g.dart';

enum ActivityType { Deleted, Shared, Received }

extension ActivityTypeUtils on ActivityType? {
  String get value {
    return this.toString().substring(this.toString().indexOf('.') + 1);
  }
}

@DataClassName("TransferActivity")
class TransferActivities extends Table {
  IntColumn? get id => integer().autoIncrement()();
  TextColumn? get owner => text().map(const ProfileConverter())();
  IntColumn? get payload => integer().map(const PayloadConverter())();
  IntColumn? get activity => integer().map(const ActivityConverter())();
}

class TransferCards extends Table {
  IntColumn? get id => integer().autoIncrement()();
  TextColumn? get owner => text().map(const ProfileConverter())();
  IntColumn? get payload => integer().map(const PayloadConverter())();
  TextColumn? get contact => text().map(const ContactConverter()).nullable()();
  TextColumn? get file => text().map(const FileConverter()).nullable()();
  TextColumn? get url => text().map(const URLConverter()).nullable()();
  DateTimeColumn? get received => dateTime()();
}

@UseMoor(tables: [TransferCards, TransferActivities])
class CardsDatabase extends _$CardsDatabase {
  CardsDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /// Adds Share/Receive/Delete activity to Database
  Future<int> addActivity(ActivityType type, Payload payload, Profile owner, {MIME_Type mime = MIME_Type.OTHER}) {
    return into(transferActivities).insert(TransferActivitiesCompanion(
      payload: Value(payload),
      owner: Value(owner),
      activity: Value(type),
    ));
  }

  /// Adds Contact/URL card to Database
  Future<int> addCard(Transfer card) async => into(transferCards).insert(TransferCardsCompanion(
      owner: Value(card.owner),
      payload: Value(card.payload),
      contact: card.hasContact() ? Value(card.contact) : Value.absent(),
      file: card.hasFile() ? Value(card.file) : Value.absent(),
      url: card.hasUrl() ? Value(card.url) : Value.absent(),
      received: Value(DateTime.fromMillisecondsSinceEpoch(card.received * 1000))));

  /// Returns all Transfer Card Items
  Future<List<TransferCard>> get allCardEntries => select(transferCards).get();

  /// Delete Single Activity from Database
  Future<void> clearActivity(TransferActivity activity) => (delete(transferActivities)..where((t) => t.id.equals(activity.id))).go();

  /// Deletes All Activity from Database
  Future<void> clearAllActivity() => delete(transferActivities).go();

  /// Deletes Card Item from Database with `TransferItem`
  Future<void> deleteCard(TransferCard item) => (delete(transferCards)..where((t) => t.id.equals(item.id))).go();

  /// Deletes Card Item from Database with id
  Future<void> deleteCardFromID(int id) => (delete(transferCards)..where((t) => t.id.equals(id))).go();

  /// Deletes ALL Card Items from Database
  Future<void> deleteAllCards() => delete(transferCards).go();

  /// Streams Activity Items from Database
  Stream<List<TransferActivity>> watchActivity() => (select(transferActivities).watch());

  /// Streams Activity Items from Database
  Stream<List<TransferCard>> watchAllCards() => (select(transferCards).watch());

  /// Streams Contact Card Items from Database
  Stream<List<TransferCard>> watchContacts() => (select(transferCards)..where((t) => t.payload.equals(Payload.CONTACT.value))).watch();

  /// Streams Metadata Card Items from Database
  Stream<List<TransferCard>> watchFiles() =>
      (select(transferCards)..where((t) => t.payload.equals(Payload.FILE.value) | t.payload.equals(Payload.FILES.value))).watch();

  /// Streams Media Card Items from Database
  Stream<List<TransferCard>> watchMedia() => (select(transferCards)..where((t) => t.payload.equals(Payload.MEDIA.value))).watch();

  /// Streams URL Card Items from Database
  Stream<List<TransferCard>> watchUrls() => (select(transferCards)..where((t) => t.payload.equals(Payload.URL.value))).watch();
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'sonr-cards2.sqlite'));
    return VmDatabase(file);
  });
}
