import 'package:sonr_core/sonr_core.dart';

import 'sql_contact.dart';
import 'sql_meta.dart';

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
  final Preview preview;
  final Metadata metadata;
  final Contact contact;
  DateTime lastOpened = DateTime.now();

  CardModel(
    this.type, {
    this.id = 0,
    this.lastOpened,
    this.preview,
    this.metadata,
    this.contact,
  });

  factory CardModel.fromContact(Contact c) {
    return CardModel(CardType.Contact, contact: c);
  }

  factory CardModel.fromMetadata(Metadata m) {
    if (m.mime.type == MIME_Type.image) {
      return CardModel(CardType.Image, id: m.id, metadata: m);
    } else {
      return CardModel(CardType.File, id: m.id, metadata: m);
    }
  }

  factory CardModel.fromPreview(Preview m) {
    if (m.mime.type == MIME_Type.image) {
      return CardModel(CardType.Image, preview: m);
    } else {
      return CardModel(CardType.File, preview: m);
    }
  }

  factory CardModel.fromInvite(AuthInvite inv) {
    if (inv.payload == Payload.FILE) {
      if (inv.preview.mime.type == MIME_Type.image) {
        return CardModel(CardType.Image, preview: inv.preview);
      } else {
        return CardModel(CardType.File, preview: inv.preview);
      }
    }
    // Contact
    else if (inv.payload == Payload.CONTACT) {
      return CardModel(CardType.Contact, contact: inv.contact);
    } else {
      throw CardsError("Invalid Payload Type");
    }
  }

  // Constructer from sql data model
  factory CardModel.fromMetaSQL(MetaSQL sql) {
    if (sql.metadata.mime.type == MIME_Type.image) {
      return CardModel(CardType.Image,
          id: sql.id, lastOpened: sql.lastOpened, metadata: sql.metadata);
    } else {
      return CardModel(CardType.File,
          id: sql.id, lastOpened: sql.lastOpened, metadata: sql.metadata);
    }
  }

  factory CardModel.fromContactSQL(ContactSQL sql) {
    return CardModel(CardType.Contact,
        id: sql.id, lastOpened: sql.lastOpened, contact: sql.contact);
  }
}
