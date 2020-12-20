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

  factory CardModel.fromContact(Contact c){

  }

  factory CardModel.fromMetadata(Contact c){

  }

  // Constructer from data model
  factory CardModel.fromMetaSQL(MetaSQL meta) {
    return CardModel(
        id: meta.id, lastOpened: meta.lastOpened, meta: meta.metadata);
  }

  factory CardModel.fromContactSQL(ContactSQL contact) {
    return CardModel(
        id: contact.id,
        lastOpened: contact.lastOpened,
        contact: contact.contact);
  }
}
