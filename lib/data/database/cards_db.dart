import 'package:moor/ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:moor/moor.dart';
import 'dart:io';
import 'package:sonr_plugin/sonr_plugin.dart';
import 'cards_converter.dart';
part 'cards_db.g.dart';

enum ActivityType { Deleted, Shared, Received }

extension ActivityTypeUtils on ActivityType {
  String get value {
    return this.toString().substring(this.toString().indexOf('.') + 1);
  }
}

@DataClassName("TransferCardActivity")
class TransferCardActivities extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get card => text().map(const CardConverter())();
  IntColumn get activity => integer().map(const ActivityConverter())();
}

class TransferCardItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get owner => text().map(const ProfileConverter())();
  IntColumn get payload => integer().map(const PayloadConverter())();
  TextColumn get contact => text().map(const ContactConverter()).nullable()();
  TextColumn get file => text().map(const FileConverter()).nullable()();
  TextColumn get url => text().map(const URLConverter()).nullable()();
  DateTimeColumn get received => dateTime()();
}

// this annotation tells moor to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@UseMoor(tables: [TransferCardItems, TransferCardActivities])
class CardsDatabase extends _$CardsDatabase {
  // we tell the database where to store the data with this constructor
  CardsDatabase() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;

  // loads all todo entries
  Future<List<TransferCardItem>> get allCardEntries => select(transferCardItems).get();
  Stream<List<TransferCardItem>> watchAll() {
    return (select(transferCardItems).watch());
  }

  Stream<List<TransferCardActivity>> watchActivity() {
    return (select(transferCardActivities).watch());
  }

  Stream<List<TransferCardItem>> watchContacts() {
    return (select(transferCardItems)..where((t) => t.payload.equals(Payload.CONTACT.value))).watch();
  }

  Stream<List<TransferCardItem>> watchMetadata() {
    return (select(transferCardItems)
          ..where(
              (t) => t.payload.equals(Payload.FILE.value) | t.payload.equals(Payload.MULTI_FILES.value) | t.payload.equals(MIME_Type.OTHER.value)))
        .watch();
  }

  Stream<List<TransferCardItem>> watchUrls() {
    return (select(transferCardItems)..where((t) => t.payload.equals(Payload.URL.value))).watch();
  }

  // returns the generated id
  Future<int> addActivity(ActivityType type, TransferCard card) {
    return into(transferCardActivities).insert(TransferCardActivitiesCompanion(card: Value(card), activity: Value(type)));
  }

  Future<int> addCard(TransferCard card) async {
    return into(transferCardItems).insert(TransferCardItemsCompanion(
        owner: Value(card.owner),
        payload: Value(card.payload),
        contact: card.hasContact() ? Value(card.contact) : Value.absent(),
        metadata: card.hasFile() ? Value(card.hasFile()) : Value.absent(),
        url: card.hasUrl() ? Value(card.url) : Value.absent(),
        received: Value(DateTime.fromMillisecondsSinceEpoch(card.received * 1000))));
  }

  Future clearActivity(TransferCardActivity activity) {
    return (delete(transferCardActivities)..where((t) => t.id.equals(activity.id))).go();
  }

  Future clearAllActivity() {
    return (delete(transferCardActivities).go());
  }

  Future deleteCard(TransferCardItem item) {
    return (delete(transferCardItems)..where((t) => t.id.equals(item.id))).go();
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db_cards.sqlite'));
    return VmDatabase(file);
  });
}
