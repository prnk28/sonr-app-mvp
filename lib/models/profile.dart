import 'package:hive/hive.dart';

// ************************
// ** User Profile Model **
// ************************
class Profile extends HiveObject {
  @HiveField(0)
  String firstName;
  @HiveField(1)
  String lastName;
  @HiveField(2)
  String profilePicture;

  // ** Constructer **
  Profile(this.firstName, this.lastName, this.profilePicture);

  // ** Set From Map **
  static Profile fromMap(Map data) {
    return Profile(
        data["first_name"], data["last_name"], data["profile_picture"]);
  }

  // ** Convert Object to Map **
  toMap() {
    return {
      'first_name': this.firstName,
      'last_name': this.lastName,
      'profile_picture': this.profilePicture
    };
  }
}

// ******************
// ** Hive Adapter **
// ******************
class ProfileAdapter extends TypeAdapter<Profile> {
  @override
  final typeId = 1;

  @override
  Profile read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Profile(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Profile obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.firstName)
      ..writeByte(1)
      ..write(obj.lastName)
      ..writeByte(2)
      ..write(obj.profilePicture);
  }
}
