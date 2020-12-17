import 'package:sonr_core/sonr_core.dart';

import 'contact_sql.dart';
import 'meta_sql.dart';

// ^ OpenFilesError couldnt open DB at path ^
class CardsError extends Error {
  final String message;
  CardsError(this.message);
}

enum CardType { File, Contact }

// ^ Card Model for Data ^ //
class CardModel {
  // Properties
  final int id;
  CardType type;

  // Data
  final Metadata meta;
  final Contact contact;
  DateTime lastOpened = DateTime.now();

  CardModel({
    this.id = 0,
    this.lastOpened,
    this.meta,
    this.contact,
  }) {
    if (meta != null) {
      this.type = CardType.File;
    } else {
      this.type = CardType.Contact;
    }
  }

  // Constructer from data model
  factory CardModel.fromSQLData({MetaSQL meta, ContactSQL contact}) {
    if (meta != null) {
      return CardModel(
          id: meta.id, lastOpened: meta.lastOpened, meta: meta.metadata);
    } else {
      return CardModel(
          id: contact.id,
          lastOpened: contact.lastOpened,
          contact: contact.contact);
    }
  }
}
