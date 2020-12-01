// ^ OpenFilesError couldnt open DB at path ^
import 'package:sonr_core/sonr_core.dart';

class OpenFilesError extends Error {
  final String message;
  OpenFilesError(this.message);
}

// File Table Fields
final String metaTable = "metadata";
final String columnId = '_id';
final String columnUuid = 'uuid';
final String columnName = 'name';
final String columnPath = 'path';
final String columnSize = 'size';
final String columnChunks = 'chunks';
final String columnMime = 'mime';
final String columnOwner = 'owner';
final String columnlastOpened = 'lastOpened';

// @ Convert to SQL Map to Store
Map metaToSQL(Metadata meta) {
  // Create Map
  var map = <String, dynamic>{
    columnUuid: meta.uuid,
    columnName: meta.name,
    columnPath: meta.path,
    columnSize: meta.size,
    columnChunks: meta.chunks,
    columnMime: meta.mime.writeToJson(),
    columnOwner: meta.owner.writeToJson(),
    columnlastOpened: meta.lastOpened,
  };

  // Check if Id Provided
  if (meta.id != null) {
    map[columnId] = meta.id;
  }
  return map;
}

// @ Convert from SQL Map to Read
Metadata metaFromSQL(Map map) {
  Metadata meta = new Metadata();
  meta.id = map[columnId];
  meta.uuid = map[columnUuid];
  meta.name = map[columnName];
  meta.path = map[columnPath];
  meta.size = map[columnSize];
  meta.chunks = map[columnChunks];
  meta.mime = MIME.fromJson(map[columnMime]);
  meta.owner = Peer.fromJson(map[columnOwner]);
  meta.lastOpened = map[columnlastOpened];
  return meta;
}
