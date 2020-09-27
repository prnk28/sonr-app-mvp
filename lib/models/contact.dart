import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

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
    // Set Id
    var uuid = Uuid();
    id = uuid.v1();
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
