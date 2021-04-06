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
class CardItem extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get owner => integer()();
  IntColumn get payload => integer().map(const PayloadConverter())();
  IntColumn get transfer => integer()();
  DateTimeColumn get received => dateTime()();
}

// This will make moor generate a class called "Category" to represent a row in this table.
// By default, "Categorie" would have been used because it only strips away the trailing "s"
// in the table name.
@DataClassName("Owner")
class Owners extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get profile => text()();
  TextColumn get firstName => text()();
  TextColumn get lastName => text()();
  TextColumn get userName => text()();
}

// This will make moor generate a class called "Category" to represent a row in this table.
// By default, "Categorie" would have been used because it only strips away the trailing "s"
// in the table name.
@DataClassName("Transfer")
class Transfers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get contact => text().map(const ContactConverter()).nullable()();
  TextColumn get metadata => text().map(const MetadataConverter()).nullable()();
  TextColumn get url => text().map(const URLConverter()).nullable()();
}

// this annotation tells moor to prepare a database class that uses both of the
// tables we just defined. We'll see how to use that database class in a moment.
@UseMoor(tables: [CardItem, Owners, Transfers])
class CardsDatabase extends _$CardsDatabase {
  // we tell the database where to store the data with this constructor
  CardsDatabase() : super(_openConnection());

  // you should bump this number whenever you change or add a table definition. Migrations
  // are covered later in this readme.
  @override
  int get schemaVersion => 1;
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
