import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'models.dart';

@HiveType()
class Contact extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String firstName;

  @HiveField(2)
  String lastName;

  @HiveField(3)
  String profilePic;

  @HiveField(4)
  String phone;

  @HiveField(5)
  String snapchat;

  @HiveField(6)
  String facebook;

  @HiveField(7)
  String instagram;

  @HiveField(8)
  String twitter;

  @HiveField(9)
  String linkedin;

  @HiveField(10)
  String email;

  @HiveField(11)
  String website;

  @HiveField(12)
  DateTime lastContact;

  Contact() {
    var uuid = Uuid();
    id = uuid.v1();
  }

  // ** Method to Print Model **
  read() {
    // Create Contact Map
    var contactMap = {
      "First Name": this.firstName,
      "Last Name": this.lastName,
      "Profile Pic": this.profilePic,
      "Phone": this.phone,
      "Snapchat": this.snapchat,
      "Facebook": this.facebook,
      "Instagram": this.instagram,
      "Twitter": this.twitter,
      "Linkedin": this.linkedin,
      "Email": this.email,
      "Website": this.website,
      "Last Contact": this.lastContact,
    };

    log.i("Contact #" + this.id);
    print(contactMap.toString());
  }
}

class ContactAdapter extends TypeAdapter<Contact> {
  @override
  final typeId = 0;

  @override
  Contact read(BinaryReader reader) {
    return Contact()..id = reader.read();
  }

  @override
  void write(BinaryWriter writer, Contact obj) {
    writer.write(obj.id);
  }
}
