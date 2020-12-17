import 'package:sonr_core/models/models.dart';

// ** Contact Table Fields ** //
final String contactColumnId = '_id';
final String contactColumnFirstName = 'firstName';
final String contactColumnLastName = 'lastName';
final String contactColumnData = "data";
final String contactColumnlastOpened = 'lastOpened';

class ContactSQL {
  final int id;
  final Contact contact;
  final DateTime lastOpened;

  ContactSQL(this.contact, {this.id, this.lastOpened});

  // @ Convert Contact to SQL Map to Store
  Map toSQL() {
    // Create Map
    var map = <String, dynamic>{
      contactColumnFirstName: contact.firstName,
      contactColumnLastName: contact.lastName,
      contactColumnData: contact.writeToJson(),
      contactColumnlastOpened: DateTime.now().millisecondsSinceEpoch,
    };

    // Check if Id Provided
    if (id != null) {
      map[contactColumnId] = id;
    }

    return map;
  }

  // @ Convert from SQL Map to Contact
  factory ContactSQL.fromSQL(Map map) {
    return ContactSQL(map[contactColumnData],
        id: map[contactColumnId],
        lastOpened:
            DateTime.fromMillisecondsSinceEpoch(map[contactColumnlastOpened]));
  }
}
