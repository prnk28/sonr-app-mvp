// @ Table Names
import 'package:sonr_core/sonr_core.dart';

// ** Metadata Table Fields ** //
final String fileColumnId = '_id';
final String fileColumnName = 'name';
final String fileColumnPath = 'path';
final String fileColumnSize = 'size';
final String fileColumnMime = 'mime';
final String fileColumnOwner = 'owner';
final String fileColumnReceived = 'received';

class MetaSQL {
  int id;
  final Metadata metadata;
  Peer owner;
  DateTime lastOpened;

  MetaSQL(this.metadata) {
    this.id = id;
    this.lastOpened = DateTime.fromMillisecondsSinceEpoch(metadata.received);
  }

  // @ Convert Metadata to SQL Map to Store
  Map toSQL() {
    // Create Map
    var map = <String, dynamic>{
      fileColumnName: metadata.name,
      fileColumnPath: metadata.path,
      fileColumnSize: metadata.size,
      fileColumnMime: metadata.mime.writeToJson(),
      fileColumnOwner: metadata.owner.writeToJson(),
      fileColumnReceived: metadata.received,
    };

    // Check if Id Provided
    if (metadata.hasId()) {
      map[fileColumnId] = metadata.id;
    }
    return map;
  }

  // @ Convert from SQL Map to Metadata
  factory MetaSQL.fromSQL(Map map) {
    Metadata meta = new Metadata();
    meta.id = map[fileColumnId];
    meta.name = map[fileColumnName];
    meta.path = map[fileColumnPath];
    meta.size = map[fileColumnSize];
    meta.owner = Profile.fromJson(map[fileColumnOwner]);
    meta.mime = MIME.fromJson(map[fileColumnMime]);
    meta.received = map[fileColumnReceived];
    return MetaSQL(meta);
  }
}
