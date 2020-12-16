import 'package:sonr_core/sonr_core.dart';

// ^ OpenFilesError couldnt open DB at path ^
class OpenFilesError extends Error {
  final String message;
  OpenFilesError(this.message);
}

// File Table Fields
final String metaTable = "metadata";
final String columnId = '_id';
final String columnName = 'name';
final String columnPath = 'path';
final String columnSize = 'size';
final String columnMime = 'mime';
final String columnOwner = 'owner';
final String columnlastOpened = 'lastOpened';

// @ Convert to SQL Map to Store
Map metaToSQL(Metadata meta) {
  // Create Map
  var map = <String, dynamic>{
    columnName: meta.name,
    columnPath: meta.path,
    columnSize: meta.size,
    columnMime: meta.mime.writeToJson(),
    columnOwner: meta.owner.writeToJson(),
    columnlastOpened: meta.lastOpened,
  };

  // Check if Id Provided
  if (meta.hasId()) {
    map[columnId] = meta.id;
  }
  return map;
}

// @ Convert from SQL Map to Read
Metadata metaFromSQL(Map map) {
  Metadata meta = new Metadata();
  meta.id = map[columnId];
  meta.name = map[columnName];
  meta.path = map[columnPath];
  meta.size = map[columnSize];
  meta.mime = MIME.fromJson(map[columnMime]);
  meta.owner = Peer.fromJson(map[columnOwner]);
  meta.lastOpened = map[columnlastOpened];
  return meta;
}
