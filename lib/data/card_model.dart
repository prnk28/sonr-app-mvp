import 'package:sonr_core/sonr_core.dart';

import 'contact_sql.dart';
import 'meta_sql.dart';

// ^ OpenFilesError couldnt open DB at path ^
class CardsError extends Error {
  final String message;
  CardsError(this.message);
}

enum CardType { File, Contact, Image }

// ^ Card Model for Data ^ //
class CardModel {
  // Properties
  final int id;
  final CardType type;

  // Data
  final Metadata meta;
  final Contact contact;
  DateTime lastOpened = DateTime.now();

  CardModel(
    this.type, {
    this.id = 0,
    this.lastOpened,
    this.meta,
    this.contact,
  });

  factory CardModel.fromContact(Contact c) {
    return CardModel(CardType.Contact, contact: c);
  }

  factory CardModel.fromMetadata(Metadata m) {
    if (m.mime.type == MIME_Type.image) {
      return CardModel(CardType.Image, id: m.id, meta: m);
    } else {
      return CardModel(CardType.File, id: m.id, meta: m);
    }
  }

  // Constructer from data model
  factory CardModel.fromMetaSQL(MetaSQL sql) {
    if (sql.metadata.mime.type == MIME_Type.image) {
      return CardModel(CardType.Image,
          id: sql.id, lastOpened: sql.lastOpened, meta: sql.metadata);
    } else {
      return CardModel(CardType.File,
          id: sql.id, lastOpened: sql.lastOpened, meta: sql.metadata);
    }
  }

  factory CardModel.fromContactSQL(ContactSQL sql) {
    return CardModel(CardType.Contact,
        id: sql.id, lastOpened: sql.lastOpened, contact: sql.contact);
  }
}
