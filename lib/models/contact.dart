import 'package:sonar_app/core/core.dart';
import 'models.dart';

// Contact Table Fields
final String _contactsTable = "contacts";
final String _columnId = '_id';
final String _columnFirstName = 'first_name';
final String _columnLastName = 'last_name';
final String _columnProfilePic = 'profile_pic';
final String _columnPhone = 'phone';
final String _columnSnapchat = 'snapchat';
final String _columnFacebook = 'facebook';
final String _columnInstagram = 'instagram';
final String _columnTwitter = 'twitter';
final String _columnLinkedin = 'linkedin';
final String _columnEmail = 'email';
final String _columnWebsite = 'website';
final String _columnReceived = 'received';

class Contact {
  int id;
  String firstName;
  String lastName;
  String profilePic;
  int phone;
  String snapchat;
  String facebook;
  String instagram;
  String twitter;
  String linkedin;
  String email;
  String website;
  DateTime received;

  // ** Constructer: Default ** //
  Contact();

  // ** Convert to Map **
  toMap() {
    var map = <String, dynamic>{
      _columnFirstName: this.firstName,
      _columnLastName: this.lastName,
      _columnProfilePic: this.profilePic,
      _columnPhone: this.phone,
      _columnSnapchat: this.snapchat,
      _columnFacebook: this.facebook,
      _columnInstagram: this.instagram,
      _columnTwitter: this.twitter,
      _columnLinkedin: this.linkedin,
      _columnEmail: this.email,
      _columnWebsite: this.website,
      _columnReceived: this.received.millisecondsSinceEpoch,
    };
    if (this.id != null) {
      map[_columnId] = this.id;
    }
    return map;
  }

  // ** Constructer: Get Contact from Map ** //
  Contact.fromMap(Map map) {
    this.id = map[_columnId];
    this.firstName = map[_columnFirstName];
    this.lastName = map[_columnLastName];
    this.profilePic = map[_columnProfilePic];
    this.phone = map[_columnPhone];
    this.snapchat = map[_columnSnapchat];
    this.facebook = map[_columnFacebook];
    this.instagram = map[_columnInstagram];
    this.twitter = map[_columnTwitter];
    this.linkedin = map[_columnLinkedin];
    this.email = map[_columnEmail];
    this.website = map[_columnWebsite];
    this.received = DateTime.fromMillisecondsSinceEpoch(map[_columnReceived]);
  }
}

// ****************** //
// ** SQL Provider ** //
// ****************** //
class ContactProvider {
  Database db;

  Future open() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, DATABASE_PATH);

// Open Database create files table
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $_contactsTable ( 
  $_columnId integer primary key autoincrement, 
  $_columnFirstName text not null,
  $_columnLastName text not null,
  $_columnProfilePic text not null,
  $_columnPhone integer not null,
  $_columnSnapchat text not null,
  $_columnFacebook text not null,
  $_columnInstagram text not null,
  $_columnTwitter text not null,
  $_columnLinkedin text not null,
  $_columnEmail text not null,
  $_columnWebsite text not null,
  $_columnReceived integer not null
)
''');
    });
  }

  Future<Contact> insert(Contact contact) async {
    contact.id = await db.insert(_contactsTable, contact.toMap());
    return contact;
  }

  Future<Contact> getContact(int id) async {
    List<Map> maps = await db.query(_contactsTable,
        columns: [
          _columnId,
          _columnFirstName,
          _columnLastName,
          _columnProfilePic,
          _columnPhone,
          _columnSnapchat,
          _columnFacebook,
          _columnInstagram,
          _columnTwitter,
          _columnLinkedin,
          _columnEmail,
          _columnWebsite,
          _columnReceived,
        ],
        where: '$_columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Contact.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Contact>> getAllContacts() async {
    // Get Records
    List<Map> records = await db.query(
      _contactsTable,
      columns: [
        _columnId,
        _columnFirstName,
        _columnLastName,
        _columnProfilePic,
        _columnPhone,
        _columnSnapchat,
        _columnFacebook,
        _columnInstagram,
        _columnTwitter,
        _columnLinkedin,
        _columnEmail,
        _columnWebsite,
        _columnReceived,
      ],
    );
    if (records.length > 0) {
      // Init List
      List<Contact> contacts = new List<Contact>();

      // Convert Each Record into Object
      records.forEach((element) {
        Contact contact = Contact.fromMap(element);
        contacts.add(contact);
      });

      // Return List
      return contacts;
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db
        .delete(_contactsTable, where: '$_columnId = ?', whereArgs: [id]);
  }

  Future<int> update(Contact contact) async {
    return await db.update(_contactsTable, contact.toMap(),
        where: '$_columnId = ?', whereArgs: [contact.id]);
  }

  Future close() async => db.close();
}
