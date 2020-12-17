// @ Table Names
import 'package:sonr_core/sonr_core.dart';

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

class MetaSQL {
  int id;
  final Metadata metadata;
  DateTime lastOpened;

  MetaSQL(this.metadata) {
    this.id = id;
    this.lastOpened = DateTime.fromMillisecondsSinceEpoch(metadata.lastOpened);
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
      fileColumnlastOpened: metadata.lastOpened,
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
    meta.mime = MIME.fromJson(map[fileColumnMime]);
    meta.owner = Peer.fromJson(map[fileColumnOwner]);
    meta.lastOpened = map[fileColumnlastOpened];
    return MetaSQL(meta);
  }
}
