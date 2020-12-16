import 'package:sonr_core/sonr_core.dart';

// ^ OpenFilesError couldnt open DB at path ^
class CardsError extends Error {
  final String message;
  CardsError(this.message);
}

// @ Table Names
final String metaTable = "metadata";
final String contactTable = "contact";

// ** Metadata Table Fields ** //
final String fileColumnId = '_id';
final String fileColumnName = 'name';
final String fileColumnPath = 'path';
final String fileColumnSize = 'size';
final String fileColumnMime = 'mime';
final String fileColumnOwner = 'owner';
final String fileColumnlastOpened = 'lastOpened';

// @ Convert Metadata to SQL Map to Store
Map metaToSQL(Metadata meta) {
  // Create Map
  var map = <String, dynamic>{
    fileColumnName: meta.name,
    fileColumnPath: meta.path,
    fileColumnSize: meta.size,
    fileColumnMime: meta.mime.writeToJson(),
    fileColumnOwner: meta.owner.writeToJson(),
    fileColumnlastOpened: meta.lastOpened,
  };

  // Check if Id Provided
  if (meta.hasId()) {
    map[fileColumnId] = meta.id;
  }
  return map;
}

// @ Convert from SQL Map to Metadata
Metadata metaFromSQL(Map map) {
  Metadata meta = new Metadata();
  meta.id = map[fileColumnId];
  meta.name = map[fileColumnName];
  meta.path = map[fileColumnPath];
  meta.size = map[fileColumnSize];
  meta.mime = MIME.fromJson(map[fileColumnMime]);
  meta.owner = Peer.fromJson(map[fileColumnOwner]);
  meta.lastOpened = map[fileColumnlastOpened];
  return meta;
}

// ** Contact Table Fields ** //
final String contactColumnId = '_id';
final String contactColumnFirstName = 'firstName';
final String contactColumnLastName = 'lastName';
final String contactColumnData = "data";
final String contactColumnlastOpened = 'lastOpened';

// @ Convert Contact to SQL Map to Store
Map contactToSQL(Contact contact) {
  // Create Map
  var map = <String, dynamic>{
    contactColumnFirstName: contact.firstName,
    contactColumnLastName: contact.lastName,
    contactColumnData: contact.writeToJson(),
    contactColumnlastOpened: DateTime.now().millisecondsSinceEpoch,
  };
  return map;
}

// @ Convert from SQL Map to Contact
Contact contactFromSQL(Map map) {
  return Contact.fromJson(map[contactColumnData]);
}
