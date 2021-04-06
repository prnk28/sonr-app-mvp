import 'package:moor/ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:moor/moor.dart';
import 'dart:io';
import 'package:sonr_core/sonr_core.dart';

import 'cards_converter.dart';

part 'cards_db.g.dart';

// this will generate a table called "todos" for us. The rows of that table will
// be represented by a class called "Todo".
class TransferCardItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get owner => text().map(const ProfileConverter())();
  IntColumn get payload => integer().map(const PayloadConverter())();
  TextColumn get contact => text().map(const ContactConverter()).nullable()();
  TextColumn get metadata => text().map(const MetadataConverter()).nullable()();
  TextColumn get url => text().map(const URLConverter()).nullable()();
  DateTimeColumn get received => dateTime()();
}

// this annotation tells moor to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@UseMoor(tables: [TransferCardItems])
class CardsDatabase extends _$CardsDatabase {
  // we tell the database where to store the data with this constructor
  CardsDatabase() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;

  // loads all todo entries
  Future<List<TransferCardItem>> get allCardEntries => select(transferCardItems).get();

  // watches all todo entries in a given category. The stream will automatically
  // emit new items whenever the underlying data changes.
  Stream<List<TransferCardItem>> watchEntriesInPayload(Payload c) {
    return (select(transferCardItems)..where((t) => t.payload.equals(c.value))).watch();
  }

  // returns the generated id
  Future<void> addCard(TransferCard card) async {}
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return VmDatabase(file);
  });
}
